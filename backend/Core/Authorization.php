<?php
declare(strict_types=1);

namespace AlbaStock\Core;

use RuntimeException;

final class Authorization
{
    private const MODULES = [
        'stock' => 'Stock',
        'approvisionnements' => 'Approvisionnements',
        'ventes' => 'Ventes',
        'caisse' => 'Caisse',
        'comptabilite' => 'Comptabilité',
        'utilisateurs' => 'Utilisateurs et rôles',
        'rapports' => 'Rapports',
        'administration' => 'Succursales et clients',
    ];

    public static function modules(): array
    {
        return self::MODULES;
    }

    public static function moduleForPermission(string $permission): ?string
    {
        if (in_array($permission, ['voir_stock', 'modifier_stock', 'stock', 'creer_produit', 'modifier_produit', 'supprimer_produit', 'voir_fournisseurs', 'creer_fournisseurs', 'modifier_fournisseurs', 'supprimer_fournisseurs', 'gerer_unites_mesure', 'voir_transferts', 'creer_transferts'], true)) return 'stock';
        if (in_array($permission, ['approvisionnement'], true) || str_ends_with($permission, '_approvisionnements')) return 'approvisionnements';
        if (str_ends_with($permission, '_transferts')) return 'stock';
        if (str_ends_with($permission, '_ventes')) return 'ventes';
        if (str_ends_with($permission, '_caisse')) return 'caisse';
        if (str_ends_with($permission, '_comptabilite')) return 'comptabilite';
        if (in_array($permission, ['gerer_utilisateurs', 'gerer_roles', 'voir_roles'], true)) return 'utilisateurs';
        if ($permission === 'voir_rapports') return 'rapports';
        if (in_array($permission, ['voir_succursales', 'gerer_succursales', 'voir_clients', 'gerer_clients'], true) || str_ends_with($permission, '_clients')) return 'administration';
        return null;
    }

    public static function moduleAllowed(array $user, string $module): bool
    {
        if (($user['type'] ?? '') === 'super_admin') return true;
        $modules = $user['modules_autorises'] ?? [];
        return is_array($modules) && in_array($module, $modules, true);
    }

    public static function requireModule(array $user, string $module): void
    {
        if (!self::moduleAllowed($user, $module)) {
            $label = self::MODULES[$module] ?? $module;
            throw new RuntimeException("Accès refusé. Permission requise : module {$label}.");
        }
    }

    /** Convertit une ressource et une méthode HTTP en permission métier à exiger. */
    public static function resourcePermission(string $resource, string $method): string
    {
        $action = match ($method) {
            'GET' => 'voir',
            'POST' => 'creer',
            'PUT', 'PATCH' => 'modifier',
            'DELETE' => 'supprimer',
            default => 'voir',
        };
        $names = [
            'users' => 'utilisateurs',
            'roles' => 'roles',
            'fournisseurs' => 'fournisseurs',
            'produits' => 'produit',
            'stocks' => 'stock',
            'caisses' => 'caisse',
            'achats' => 'approvisionnements',
            'ventes' => 'ventes',
            'mouvements-caisse' => 'caisse',
            'transferts-stock' => 'transferts',
            'types-caisses' => 'caisse',
        ];
        // Les catégories font partie du module stock et suivent les mêmes droits.
        if ($resource === 'categories') {
            return match ($method) {
                'GET' => 'voir_stock',
                'POST' => 'creer_produit',
                'PUT', 'PATCH', 'DELETE' => 'modifier_stock',
                default => 'voir_stock',
            };
        }
        if ($resource === 'unites_mesure') {
            return match ($method) {
                'GET' => 'voir_stock',
                'POST', 'PUT', 'PATCH', 'DELETE' => 'gerer_unites_mesure',
                default => 'voir_stock',
            };
        }
        if ($resource === 'produits') {
            return match ($method) {
                'GET' => 'voir_stock',
                'POST' => 'creer_produit',
                'PUT', 'PATCH' => 'modifier_produit',
                'DELETE' => 'supprimer_produit',
                default => 'voir_stock',
            };
        }
        if ($resource === 'clients') {
            return $method === 'GET' ? 'voir_clients' : 'gerer_clients';
        }
        if ($resource === 'users' || $resource === 'roles') {
            if ($resource === 'roles' && $method === 'GET') return 'voir_roles';
            return $resource === 'users' ? 'gerer_utilisateurs' : 'gerer_roles';
        }
        return $action . '_' . ($names[$resource] ?? $resource);
    }

    /** Refuse l'action si le rôle actuel ne contient pas le droit demandé. */
    public static function requirePermission(array $user, string $permission): void
    {
        if ($user['type'] === 'super_admin') {
            return;
        }

        $module = self::moduleForPermission($permission);
        if ($module !== null) self::requireModule($user, $module);

        $permissions = self::permissions($user);
        if (in_array('*', $permissions, true) || in_array($permission, $permissions, true)) {
            return;
        }

        throw new RuntimeException("Accès refusé. Permission requise : {$permission}.");
    }

    /** Autorise une liste de rôles à consulter les rôles pour gérer utilisateurs ou permissions. */
    public static function requireAnyPermission(array $user, array $permissions, string $deniedMessage = 'Accès refusé. Permission requise : voir_roles, gerer_roles ou gerer_utilisateurs.'): void
    {
        $granted = self::permissions($user);
        if ($user['type'] === 'super_admin') return;
        $allowedPermissions = array_filter($permissions, static function (string $permission) use ($user): bool {
            $module = self::moduleForPermission($permission);
            return $module === null || self::moduleAllowed($user, $module);
        });
        if (($allowedPermissions !== [] && in_array('*', $granted, true)) || array_intersect($allowedPermissions, $granted) !== []) return;
        throw new RuntimeException($deniedMessage);
    }

    /** Décode les droits JSON; le premier compte de l'entreprise reçoit le statut propriétaire. */
    public static function permissions(array $user): array
    {
        if ($user['type'] === 'super_admin') {
            return ['*'];
        }
        $rawPermissions = (string) ($user['permissions'] ?? '[]');
        $permissions = json_decode($rawPermissions, true);
        if (!is_array($permissions)) return [];
        // Convertit l'ancien alias de groupe en droits utilisables par l'API.
        if (in_array('stock', $permissions, true) || (in_array('voir_stock', $permissions, true) && !in_array('approvisionnement', $permissions, true))) {
            $permissions = array_merge($permissions, ['voir_stock', 'modifier_stock', 'creer_produit', 'modifier_produit', 'supprimer_produit', 'voir_succursales', 'voir_fournisseurs', 'creer_fournisseurs', 'modifier_fournisseurs', 'supprimer_fournisseurs', 'voir_approvisionnements', 'creer_approvisionnements']);
        }
        if (in_array('vente', $permissions, true)) $permissions = array_merge($permissions, ['voir_ventes', 'creer_ventes', 'modifier_ventes']);
        if (in_array('caisse', $permissions, true)) $permissions = array_merge($permissions, ['voir_caisse', 'creer_caisse', 'modifier_caisse', 'supprimer_caisse']);
        if (in_array('comptabilite', $permissions, true)) $permissions = array_merge($permissions, ['voir_comptabilite', 'creer_comptabilite', 'modifier_comptabilite']);
        if (in_array('clients', $permissions, true)) $permissions = array_merge($permissions, ['voir_clients', 'gerer_clients']);
        if (in_array('creer_approvisionnements', $permissions, true)) $permissions[] = 'creer_fournisseurs';
        return array_values(array_unique($permissions));
    }

    /** Retourne la succursale autorisée et refuse toute succursale étrangère à l'utilisateur. */
    public static function branchId(array $user, ?int $requestedBranchId): ?int
    {
        if (self::canSeeAllBranches($user)) {
            return $requestedBranchId;
        }

        $ownBranchId = (int) $user['succursale_id'];
        if ($requestedBranchId !== null && $requestedBranchId !== $ownBranchId) {
            throw new RuntimeException('Accès limité à votre succursale.');
        }
        return $ownBranchId;
    }

    // Les administrateurs multi-succursales peuvent voir tous les rapports de leur entreprise.
    public static function canSeeAllBranches(array $user): bool
    {
        return $user['type'] === 'super_admin'
            || $user['succursale_id'] === null
            || in_array('toutes_succursales', self::permissions($user), true);
    }
}

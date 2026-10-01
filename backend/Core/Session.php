<?php
declare(strict_types=1);

namespace AlbaStock\Core;

final class Session
{
    public static function start(): void
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_set_cookie_params([
                'httponly' => true,
                'secure' => !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off',
                'samesite' => 'Lax',
            ]);
            session_start();
        }
    }

    public static function login(array $user, string $type): void
    {
        self::start();
        session_regenerate_id(true);
        $_SESSION['auth'] = [
            'type' => $type,
            // La requête superadministrateur alias sup_admin_id sous super_admin_id.
            'id' => (int) ($user['user_id'] ?? $user['super_admin_id'] ?? $user['sup_admin_id']),
            'email' => $user['email'] ?? null,
            'username' => $user['username'] ?? null,
            'entreprise_id' => isset($user['entreprise_id']) ? (int) $user['entreprise_id'] : null,
            'succursale_id' => isset($user['succursale_id']) ? (int) $user['succursale_id'] : null,
            'role_id' => isset($user['role_id']) ? (int) $user['role_id'] : null,
            'role_name' => $user['role_name'] ?? null,
            'permissions' => $user['permissions'] ?? '[]',
            'full_name' => $user['full_name'] ?? $user['email'],
            'enterprise_name' => $user['enterprise_name'] ?? null,
        ];
    }

    public static function current(): ?array
    {
        self::start();
        return $_SESSION['auth'] ?? null;
    }

    public static function logout(): void
    {
        self::start();
        $_SESSION = [];
        session_destroy();
    }
}

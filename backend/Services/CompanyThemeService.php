<?php
declare(strict_types=1);

namespace AlbaStock\Services;

use mysqli;
use RuntimeException;

final class CompanyThemeService
{
    private const THEMES = ['green', 'teal', 'blue', 'navy', 'purple', 'pink', 'red', 'orange', 'amber', 'black', 'gray'];

    public function __construct(private readonly mysqli $db) {}

    public function settings(array $actor): array
    {
        $enterpriseId = (int) ($actor['entreprise_id'] ?? 0);
        $statement = $this->db->prepare('SELECT activity_type, theme_color FROM entreprises WHERE entreprise_id = ? LIMIT 1');
        $statement->bind_param('i', $enterpriseId);
        $statement->execute();
        $settings = $statement->get_result()->fetch_assoc();
        if (!$settings) throw new RuntimeException('Entreprise introuvable.');

        return [
            'activity_type' => (string) $settings['activity_type'],
            'theme_color' => (string) $settings['theme_color'],
            'themes' => self::THEMES,
        ];
    }

    public function update(array $actor, array $data): array
    {
        if (($actor['type'] ?? '') !== 'user' || empty($actor['is_company_admin'])) {
            throw new RuntimeException('Seul l’administrateur de l’entreprise peut modifier son thème.');
        }
        $theme = $data['theme_color'] ?? null;
        if (!is_string($theme) || !in_array($theme, self::THEMES, true)) {
            throw new RuntimeException('Le thème sélectionné est invalide.');
        }

        $enterpriseId = (int) ($actor['entreprise_id'] ?? 0);
        $statement = $this->db->prepare('UPDATE entreprises SET theme_color = ? WHERE entreprise_id = ?');
        $statement->bind_param('si', $theme, $enterpriseId);
        $statement->execute();
        if ($statement->affected_rows === 0) {
            $exists = $this->db->prepare('SELECT entreprise_id FROM entreprises WHERE entreprise_id = ? LIMIT 1');
            $exists->bind_param('i', $enterpriseId);
            $exists->execute();
            if (!$exists->get_result()->fetch_assoc()) throw new RuntimeException('Entreprise introuvable.');
        }

        return $this->settings($actor);
    }

    public function updateUserTheme(array $actor, array $data): ?string
    {
        if (($actor['type'] ?? '') !== 'user') {
            throw new RuntimeException('Action réservée aux utilisateurs d’entreprise.');
        }
        $theme = $data['theme_color'] ?? null;
        if ($theme !== null && (!is_string($theme) || !in_array($theme, self::THEMES, true))) {
            throw new RuntimeException('Le thème sélectionné est invalide.');
        }

        $userId = (int) ($actor['id'] ?? 0);
        $enterpriseId = (int) ($actor['entreprise_id'] ?? 0);
        $statement = $this->db->prepare('UPDATE users SET interface_theme = ? WHERE user_id = ? AND entreprise_id = ?');
        $statement->bind_param('sii', $theme, $userId, $enterpriseId);
        $statement->execute();
        if ($statement->affected_rows === 0) {
            $exists = $this->db->prepare('SELECT user_id FROM users WHERE user_id = ? AND entreprise_id = ? LIMIT 1');
            $exists->bind_param('ii', $userId, $enterpriseId);
            $exists->execute();
            if (!$exists->get_result()->fetch_assoc()) throw new RuntimeException('Compte utilisateur introuvable.');
        }

        $_SESSION['auth']['interface_theme'] = $theme;
        return $theme;
    }
}

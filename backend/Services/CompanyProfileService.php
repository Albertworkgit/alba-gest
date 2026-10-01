<?php
declare(strict_types=1);

namespace AlbaStock\Services;

use mysqli;
use RuntimeException;

final class CompanyProfileService
{
    private const MAX_IMAGE_BYTES = 8_388_608;
    private const IMAGE_TYPES = [
        'image/jpeg' => 'jpg',
        'image/png' => 'png',
        'image/gif' => 'gif',
        'image/webp' => 'webp',
        'image/bmp' => 'bmp',
        'image/avif' => 'avif',
        'image/tiff' => 'tiff',
        'image/x-icon' => 'ico',
        'image/vnd.microsoft.icon' => 'ico',
        'image/svg+xml' => 'svg',
    ];

    public function __construct(private readonly mysqli $db)
    {
    }

    public function update(int $enterpriseId, array $data, array $files): array
    {
        $name = trim((string) ($data['name'] ?? ''));
        $email = trim((string) ($data['email'] ?? ''));
        $phone = trim((string) ($data['phone'] ?? ''));
        $address = trim((string) ($data['address'] ?? ''));
        $rccm = trim((string) ($data['rccm'] ?? ''));
        $boitePostale = trim((string) ($data['boite_postale'] ?? ''));
        if ($enterpriseId < 1 || $name === '' || mb_strlen($name, 'UTF-8') > 100) {
            throw new RuntimeException('Le nom de l’entreprise est obligatoire (100 caractères maximum).');
        }
        if ($email !== '' && (!filter_var($email, FILTER_VALIDATE_EMAIL) || mb_strlen($email, 'UTF-8') > 100)) {
            throw new RuntimeException('L’adresse électronique de l’entreprise est invalide.');
        }
        if (mb_strlen($phone, 'UTF-8') > 20) throw new RuntimeException('Le numéro de téléphone est trop long.');

        if (mb_strlen($rccm, 'UTF-8') > 100 || mb_strlen($boitePostale, 'UTF-8') > 100) throw new RuntimeException('Le RCCM et la BP sont limités à 100 caractères.');
        $lookup = $this->db->prepare('SELECT logo, cachet FROM entreprises WHERE entreprise_id = ? LIMIT 1');
        $lookup->bind_param('i', $enterpriseId);
        $lookup->execute();
        $current = $lookup->get_result()->fetch_assoc();
        if (!$current) throw new RuntimeException('Entreprise introuvable.');

        $newFiles = [];
        $oldFiles = [];
        $logo = $current['logo'];
        $stamp = $current['cachet'];
        try {
            if (!empty($data['remove_logo'])) { $oldFiles[] = $logo; $logo = null; }
            if (!empty($data['remove_cachet'])) { $oldFiles[] = $stamp; $stamp = null; }
            if (isset($files['logo']) && ($files['logo']['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_NO_FILE) {
                $uploaded = $this->storeImage($enterpriseId, $files['logo'], false);
                $newFiles[] = $uploaded;
                $oldFiles[] = $logo;
                $logo = $uploaded;
            }
            if (isset($files['cachet']) && ($files['cachet']['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_NO_FILE) {
                $uploaded = $this->storeImage($enterpriseId, $files['cachet'], true);
                $newFiles[] = $uploaded;
                $oldFiles[] = $stamp;
                $stamp = $uploaded;
            }

            $update = $this->db->prepare('UPDATE entreprises SET name = ?, email = ?, phone = ?, address = ?, rccm = ?, boite_postale = ?, logo = ?, cachet = ? WHERE entreprise_id = ?');
            $update->bind_param('ssssssssi', $name, $email, $phone, $address, $rccm, $boitePostale, $logo, $stamp, $enterpriseId);
            $update->execute();
        } catch (\Throwable $exception) {
            foreach ($newFiles as $path) $this->deleteStoredFile($enterpriseId, $path);
            throw $exception;
        }

        foreach (array_unique(array_filter($oldFiles)) as $path) $this->deleteStoredFile($enterpriseId, (string) $path);
        return $this->get($enterpriseId);
    }

    public function get(int $enterpriseId): array
    {
        $statement = $this->db->prepare('SELECT entreprise_id, name, email, phone, address, rccm, boite_postale, logo, cachet FROM entreprises WHERE entreprise_id = ? LIMIT 1');
        $statement->bind_param('i', $enterpriseId);
        $statement->execute();
        return $statement->get_result()->fetch_assoc() ?: [];
    }

    private function storeImage(int $enterpriseId, array $file, bool $pngOnly): string
    {
        $error = (int) ($file['error'] ?? UPLOAD_ERR_NO_FILE);
        if ($error !== UPLOAD_ERR_OK) throw new RuntimeException($error === UPLOAD_ERR_INI_SIZE || $error === UPLOAD_ERR_FORM_SIZE ? 'Chaque image doit faire au maximum 8 Mo.' : 'Le téléversement de l’image a échoué.');
        $temporaryPath = (string) ($file['tmp_name'] ?? '');
        $size = (int) ($file['size'] ?? 0);
        if ($temporaryPath === '' || !is_uploaded_file($temporaryPath) || $size < 1 || $size > self::MAX_IMAGE_BYTES) {
            throw new RuntimeException('Fichier image invalide ou supérieur à 8 Mo.');
        }
        $mime = (new \finfo(FILEINFO_MIME_TYPE))->file($temporaryPath);
        if ($pngOnly ? $mime !== 'image/png' : !isset(self::IMAGE_TYPES[$mime])) {
            throw new RuntimeException($pngOnly ? 'Le cachet doit être une image PNG.' : 'Le logo doit être un fichier image valide.');
        }
        $extension = $pngOnly ? 'png' : self::IMAGE_TYPES[$mime];
        $directory = dirname(__DIR__) . '/uploads/companies/' . $enterpriseId;
        if (!is_dir($directory) && !mkdir($directory, 0755, true) && !is_dir($directory)) {
            throw new RuntimeException('Impossible de préparer le stockage des images de l’entreprise.');
        }
        $filename = ($pngOnly ? 'stamp-' : 'logo-') . bin2hex(random_bytes(16)) . '.' . $extension;
        if (!move_uploaded_file($temporaryPath, $directory . '/' . $filename)) {
            throw new RuntimeException('Impossible d’enregistrer l’image envoyée.');
        }
        return 'backend/uploads/companies/' . $enterpriseId . '/' . $filename;
    }

    private function deleteStoredFile(int $enterpriseId, string $relativePath): void
    {
        $expectedPrefix = 'backend/uploads/companies/' . $enterpriseId . '/';
        if (!str_starts_with($relativePath, $expectedPrefix)) return;
        $filename = basename($relativePath);
        if ($filename !== '' && $filename !== '.' && $filename !== '..') {
            $path = dirname(__DIR__) . '/uploads/companies/' . $enterpriseId . '/' . $filename;
            if (is_file($path)) unlink($path);
        }
    }
}

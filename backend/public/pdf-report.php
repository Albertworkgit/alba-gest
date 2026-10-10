<?php
declare(strict_types=1);

require_once __DIR__ . '/../Core/Database.php';
require_once __DIR__ . '/../Core/JsonResponse.php';
require_once __DIR__ . '/../Core/AuthGuard.php';
require_once __DIR__ . '/../Core/Authorization.php';

use AlbaStock\Core\AuthGuard;
use AlbaStock\Core\Authorization;
use AlbaStock\Core\Database;
use AlbaStock\Core\JsonResponse;

if (!is_file(__DIR__ . '/../../vendor/autoload.php')) {
    JsonResponse::error('La bibliothèque FPDF est absente. Exécutez composer install dans le dossier du projet.', 503);
}
require_once __DIR__ . '/../../vendor/autoload.php';

final class AlbaReportPdf extends FPDF
{
    public string $companyName = '';
    public string $reportTitle = '';
    public array $repeatHeaders = [];
    public array $repeatWidths = [];

    public function Header(): void
    {
        $this->SetFont('Arial', 'B', 15);
        $this->Cell(0, 8, self::pdfText($this->reportTitle), 0, 1, 'L');
        $this->SetFont('Arial', '', 9);
        $this->Cell(0, 6, self::pdfText($this->companyName . ' · ' . date('d/m/Y H:i')), 0, 1, 'L');
        $this->SetDrawColor(20, 124, 112);
        $this->Line(10, $this->GetY() + 1, $this->GetPageWidth() - 10, $this->GetY() + 1);
        $this->Ln(5);
    }

    public function Footer(): void
    {
        $this->SetY(-12);
        $this->SetFont('Arial', '', 8);
        $this->Cell(0, 6, self::pdfText($this->companyName . ' · Page ' . $this->PageNo()), 0, 0, 'C');
    }

    public function tableRow(array $values, array $widths, bool $header = false): void
    {
        $values = array_map(self::pdfText(...), $values);
        $lineHeight = 5;
        $lineCounts = [];
        foreach ($values as $index => $value) {
            $lineCounts[] = $this->lineCount($widths[$index], $value);
        }
        $rowHeight = max(1, ...$lineCounts) * $lineHeight + 2;
        if ($this->GetY() + $rowHeight > $this->GetPageHeight() - 15) {
            $this->AddPage('L');
            if (!$header && $this->repeatHeaders !== []) {
                $this->tableRow($this->repeatHeaders, $this->repeatWidths, true);
            }
        }

        $startX = $this->GetX();
        $startY = $this->GetY();
        $x = $startX;
        foreach ($widths as $width) {
            if ($header) {
                $this->SetFillColor(229, 242, 237);
                $this->Rect($x, $startY, $width, $rowHeight, 'DF');
            } else {
                $this->Rect($x, $startY, $width, $rowHeight);
            }
            $x += $width;
        }
        $x = $startX;
        $this->SetFont('Arial', $header ? 'B' : '', 8);
        foreach ($values as $index => $value) {
            $this->SetXY($x + 1, $startY + 1);
            $this->MultiCell($widths[$index] - 2, $lineHeight, $value, 0, 'L');
            $x += $widths[$index];
        }
        $this->SetXY($startX, $startY + $rowHeight);
    }

    private function lineCount(float $width, string $text): int
    {
        $availableWidth = max(1.0, $width - 4);
        $words = preg_split('/\s+/', $text) ?: [''];
        $lines = 1;
        $line = '';
        foreach ($words as $word) {
            $candidate = $line === '' ? $word : $line . ' ' . $word;
            if ($line !== '' && $this->GetStringWidth($candidate) > $availableWidth) {
                $lines++;
                $line = $word;
            } else {
                $line = $candidate;
            }
        }
        return $lines;
    }

    public static function pdfText(string $text): string
    {
        $converted = iconv('UTF-8', 'Windows-1252//TRANSLIT', $text);
        if ($converted === false) {
            throw new RuntimeException('Le texte du rapport ne peut pas être converti pour le PDF.');
        }
        return $converted;
    }
}

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
    JsonResponse::error('Méthode HTTP non autorisée.', 405);
}

try {
    $user = AuthGuard::requireAuthenticated();
    Authorization::requireAnyPermission($user, ['voir_rapports', 'voir_comptabilite']);
    if (!class_exists(FPDF::class)) {
        JsonResponse::error('La bibliothèque FPDF est absente. Exécutez composer install dans le dossier du projet.', 503);
    }

    $body = json_decode((string) file_get_contents('php://input'), true);
    $title = is_array($body) ? trim((string) ($body['title'] ?? '')) : '';
    $tables = is_array($body) ? ($body['tables'] ?? null) : null;
    if ($title === '' || strlen($title) > 160 || !is_array($tables) || $tables === [] || count($tables) > 15) {
        JsonResponse::error('Le titre ou les tableaux du rapport sont invalides.', 422);
    }

    $validatedTables = [];
    $totalRows = 0;
    foreach ($tables as $table) {
        $headers = $table['headers'] ?? null;
        $rows = $table['rows'] ?? null;
        if (!is_array($headers) || $headers === [] || count($headers) > 12 || !is_array($rows)) {
            JsonResponse::error('La structure des tableaux du rapport est invalide.', 422);
        }
        $totalRows += count($rows);
        if ($totalRows > 5000) {
            JsonResponse::error('Le rapport dépasse la limite de 5 000 lignes. Affinez les filtres puis réessayez.', 413);
        }
        $normalizedHeaders = [];
        foreach ($headers as $header) {
            if (!is_string($header) || strlen($header) > 200) JsonResponse::error('Un titre de colonne est invalide.', 422);
            $normalizedHeaders[] = $header;
        }
        $normalizedRows = [];
        foreach ($rows as $row) {
            if (!is_array($row) || count($row) > count($normalizedHeaders)) {
                JsonResponse::error('Une ligne du rapport est invalide.', 422);
            }
            $normalized = [];
            foreach ($normalizedHeaders as $index => $_header) {
                $value = $row[$index] ?? '';
                if (!is_string($value) || strlen($value) > 2000) JsonResponse::error('Une valeur du rapport est invalide.', 422);
                $normalized[] = $value;
            }
            $normalizedRows[] = $normalized;
        }
        $validatedTables[] = ['headers' => $normalizedHeaders, 'rows' => $normalizedRows];
    }

    $enterpriseId = AuthGuard::enterpriseId($user);
    $branchId = isset($body['succursale_id']) && $body['succursale_id'] !== ''
        ? Authorization::branchId($user, (int) $body['succursale_id'])
        : null;
    $companyQuery = Database::connection()->prepare('SELECT name FROM entreprises WHERE entreprise_id = ? LIMIT 1');
    $companyQuery->bind_param('i', $enterpriseId);
    $companyQuery->execute();
    $companyName = (string) ($companyQuery->get_result()->fetch_assoc()['name'] ?? 'ALBA-STOCK');

    $pdf = new AlbaReportPdf('L', 'mm', 'A4');
    $pdf->companyName = $companyName;
    $pdf->reportTitle = $title;
    $pdf->SetMargins(10, 10, 10);
    $pdf->SetAutoPageBreak(true, 15);
    $pdf->AddPage('L');
    $usableWidth = $pdf->GetPageWidth() - 20;
    foreach ($validatedTables as $table) {
        $widths = array_fill(0, count($table['headers']), $usableWidth / count($table['headers']));
        $pdf->repeatHeaders = $table['headers'];
        $pdf->repeatWidths = $widths;
        $pdf->tableRow($table['headers'], $widths, true);
        foreach ($table['rows'] as $row) {
            $pdf->tableRow($row, $widths);
        }
        $pdf->Ln(4);
    }

    $filename = preg_replace('/[^a-z0-9-]+/', '-', strtolower(iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $title) ?: 'rapport'));
    $pdf->Output('D', trim((string) $filename, '-') . '.pdf');
} catch (RuntimeException $exception) {
    $message = $exception->getMessage();
    $status = str_contains($message, 'Authentification requise') ? 401
        : (str_contains($message, 'Permission requise') || str_contains($message, 'Accès refusé') ? 403 : 422);
    JsonResponse::error($message, $status);
} catch (Throwable $exception) {
    JsonResponse::error('La génération du rapport PDF a échoué.', 500);
}

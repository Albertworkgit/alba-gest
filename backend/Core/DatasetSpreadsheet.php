<?php
declare(strict_types=1);

namespace AlbaStock\Core;

use RuntimeException;

final class DatasetSpreadsheet
{
    public static function download(string $filename, array $rows): never
    {
        $content = self::create($rows);
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment; filename="' . $filename . '.xlsx"');
        header('Content-Length: ' . strlen($content));
        header('Cache-Control: no-store');
        echo $content;
        exit;
    }

    public static function read(string $path): array
    {
        $content = file_get_contents($path);
        if ($content === false || strlen($content) > 10 * 1024 * 1024) {
            throw new RuntimeException('Le classeur Excel est illisible ou dépasse 10 Mo.');
        }
        $entries = self::unzip($content);
        $workbook = self::xml($entries['xl/workbook.xml'] ?? '');
        $relationships = self::xml($entries['xl/_rels/workbook.xml.rels'] ?? '');
        $sheetPath = null;
        foreach ($workbook->getElementsByTagNameNS('*', 'sheet') as $sheet) {
            if ($sheet->getAttribute('name') !== 'Jeux des données') continue;
            $relationshipId = $sheet->getAttributeNS('http://schemas.openxmlformats.org/officeDocument/2006/relationships', 'id');
            foreach ($relationships->getElementsByTagNameNS('*', 'Relationship') as $relationship) {
                if ($relationship->getAttribute('Id') === $relationshipId) {
                    $target = ltrim($relationship->getAttribute('Target'), '/');
                    $sheetPath = str_starts_with($target, 'xl/') ? $target : 'xl/' . $target;
                    break 2;
                }
            }
        }
        if ($sheetPath === null || !isset($entries[$sheetPath])) {
            throw new RuntimeException('Le classeur doit contenir un onglet nommé « Jeux des données ».');
        }

        $sharedStrings = [];
        if (isset($entries['xl/sharedStrings.xml'])) {
            $strings = self::xml($entries['xl/sharedStrings.xml']);
            foreach ($strings->getElementsByTagNameNS('*', 'si') as $item) {
                $value = '';
                foreach ($item->getElementsByTagNameNS('*', 't') as $text) $value .= $text->textContent;
                $sharedStrings[] = $value;
            }
        }

        $sheet = self::xml($entries[$sheetPath]);
        $rows = [];
        foreach ($sheet->getElementsByTagNameNS('*', 'row') as $rowNode) {
            if (count($rows) >= 5001) throw new RuntimeException('Le classeur Excel ne peut pas dépasser 5 000 lignes de données.');
            $row = [];
            foreach ($rowNode->getElementsByTagNameNS('*', 'c') as $cell) {
                $reference = $cell->getAttribute('r');
                if (!preg_match('/^([A-Z]+)/', $reference, $match)) continue;
                $column = self::columnIndex($match[1]);
                if ($column > 99) throw new RuntimeException('Le classeur Excel contient trop de colonnes.');
                $valueNode = $cell->getElementsByTagNameNS('*', 'v')->item(0);
                $value = $valueNode?->textContent ?? '';
                if ($cell->getAttribute('t') === 's') {
                    $value = $sharedStrings[(int) $value] ?? '';
                } elseif ($cell->getAttribute('t') === 'inlineStr') {
                    $value = '';
                    foreach ($cell->getElementsByTagNameNS('*', 't') as $text) $value .= $text->textContent;
                }
                $row[$column] = $value;
            }
            if ($row !== []) {
                $rowValues = array_fill(0, max(array_keys($row)) + 1, '');
                foreach ($row as $column => $value) $rowValues[$column] = $value;
                $rows[] = $rowValues;
            } else {
                $rows[] = [];
            }
        }
        return $rows;
    }

    private static function create(array $rows): string
    {
        $sheetRows = '';
        foreach ($rows as $rowIndex => $row) {
            $cells = '';
            foreach (array_values($row) as $columnIndex => $value) {
                $reference = self::columnName($columnIndex + 1) . ($rowIndex + 1);
                $value = (string) $value;
                if ($rowIndex > 0 && in_array($columnIndex, [7, 8, 10], true) && $value !== '' && is_numeric($value)) {
                    $cells .= '<c r="' . $reference . '" t="n"><v>' . self::xmlEscape($value) . '</v></c>';
                } else {
                    $cells .= '<c r="' . $reference . '" t="inlineStr"><is><t xml:space="preserve">' . self::xmlEscape($value) . '</t></is></c>';
                }
            }
            $sheetRows .= '<row r="' . ($rowIndex + 1) . '">' . $cells . '</row>';
        }
        $files = [
            '[Content_Types].xml' => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/><Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/></Types>',
            '_rels/.rels' => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>',
            'xl/workbook.xml' => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets><sheet name="Jeux des données" sheetId="1" r:id="rId1"/></sheets></workbook>',
            'xl/_rels/workbook.xml.rels' => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/></Relationships>',
            'xl/worksheets/sheet1.xml' => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>' . $sheetRows . '</sheetData></worksheet>',
        ];
        return self::zip($files);
    }

    private static function zip(array $files): string
    {
        $body = '';
        $directory = '';
        foreach ($files as $name => $contents) {
            $compressed = gzdeflate($contents);
            if ($compressed === false) throw new RuntimeException('Création du classeur Excel impossible.');
            $nameLength = strlen($name);
            $offset = strlen($body);
            $crc = crc32($contents);
            $body .= pack('VvvvvvVVVvv', 0x04034b50, 20, 0, 8, 0, 0x21, $crc, strlen($compressed), strlen($contents), $nameLength, 0) . $name . $compressed;
            $directory .= pack('VvvvvvvVVVvvvvvVV', 0x02014b50, 20, 20, 0, 8, 0, 0x21, $crc, strlen($compressed), strlen($contents), $nameLength, 0, 0, 0, 0, 0, $offset) . $name;
        }
        $entryCount = count($files);
        return $body . $directory . pack('VvvvvVVv', 0x06054b50, 0, 0, $entryCount, $entryCount, strlen($directory), strlen($body), 0);
    }

    private static function unzip(string $content): array
    {
        $endOffset = strrpos($content, "PK\x05\x06");
        if ($endOffset === false || strlen($content) - $endOffset < 22) {
            throw new RuntimeException('Le fichier sélectionné n’est pas un classeur Excel valide.');
        }
        $end = unpack('Vsignature/vdisk/vstart/ventries_disk/ventries/Vdirectory_size/Vdirectory_offset/vcomment', substr($content, $endOffset, 22));
        if (!$end || $end['signature'] !== 0x06054b50 || $endOffset + 22 + $end['comment'] !== strlen($content)
            || $end['entries'] > 1000 || $end['directory_offset'] + $end['directory_size'] > strlen($content)) {
            throw new RuntimeException('La structure du classeur Excel est invalide.');
        }
        $entries = [];
        $uncompressedTotal = 0;
        $offset = $end['directory_offset'];
        for ($index = 0; $index < $end['entries']; $index++) {
            $header = unpack('Vsignature/vmade/vneeded/vflags/vmethod/vtime/vdate/Vcrc/Vcompressed/Vuncompressed/vname/vextra/vcomment/vdisk/vinternal/Vexternal/Voffset', substr($content, $offset, 46));
            if (!$header || $header['signature'] !== 0x02014b50) throw new RuntimeException('La structure du classeur Excel est invalide.');
            if ($offset + 46 + $header['name'] + $header['extra'] + $header['comment'] > strlen($content) || ($header['flags'] & 1) !== 0) {
                throw new RuntimeException('La structure du classeur Excel est invalide.');
            }
            $name = substr($content, $offset + 46, $header['name']);
            $offset += 46 + $header['name'] + $header['extra'] + $header['comment'];
            if (!in_array($name, ['xl/workbook.xml', 'xl/_rels/workbook.xml.rels', 'xl/sharedStrings.xml'], true)
                && !preg_match('#^xl/worksheets/[^/]+\.xml$#', $name)) continue;
            if ($header['uncompressed'] > 20 * 1024 * 1024) throw new RuntimeException('Une feuille Excel dépasse la taille maximale autorisée.');
            $uncompressedTotal += $header['uncompressed'];
            if ($uncompressedTotal > 30 * 1024 * 1024 || $header['offset'] + 30 > strlen($content)) {
                throw new RuntimeException('Le classeur Excel dépasse la taille décompressée autorisée ou sa structure est invalide.');
            }
            $local = unpack('Vsignature/vversion/vflags/vmethod/vtime/vdate/Vcrc/Vcompressed/Vuncompressed/vname/vextra', substr($content, $header['offset'], 30));
            if (!$local || $local['signature'] !== 0x04034b50) throw new RuntimeException('La structure du classeur Excel est invalide.');
            $start = $header['offset'] + 30 + $local['name'] + $local['extra'];
            if ($start + $header['compressed'] > strlen($content)) throw new RuntimeException('La structure du classeur Excel est invalide.');
            $compressed = substr($content, $start, $header['compressed']);
            $data = match ($header['method']) {
                0 => $compressed,
                8 => gzinflate($compressed),
                default => false,
            };
            if ($data === false || strlen($data) !== $header['uncompressed']) throw new RuntimeException('Lecture d’une feuille Excel impossible.');
            $entries[$name] = $data;
        }
        return $entries;
    }

    private static function xml(string $content): \DOMDocument
    {
        if ($content === '') throw new RuntimeException('Le classeur Excel est incomplet.');
        $document = new \DOMDocument();
        $document->resolveExternals = false;
        $document->substituteEntities = false;
        if (!$document->loadXML($content, LIBXML_NONET | LIBXML_NOBLANKS)) {
            throw new RuntimeException('Une feuille Excel contient un XML invalide.');
        }
        return $document;
    }

    private static function columnIndex(string $letters): int
    {
        $index = 0;
        foreach (str_split($letters) as $letter) $index = $index * 26 + ord($letter) - 64;
        return $index - 1;
    }

    private static function columnName(int $index): string
    {
        $name = '';
        while ($index > 0) {
            $index--;
            $name = chr(65 + $index % 26) . $name;
            $index = intdiv($index, 26);
        }
        return $name;
    }

    private static function xmlEscape(string $value): string
    {
        return htmlspecialchars($value, ENT_XML1 | ENT_QUOTES, 'UTF-8');
    }
}

<?php
declare(strict_types=1);

// Utilise un chemin absolu pour que le téléchargement fonctionne depuis toute URL.
$file = __DIR__ . DIRECTORY_SEPARATOR . 'dsktop' . DIRECTORY_SEPARATOR . 'westock.bat';
if (!is_file($file) || !is_readable($file)) {
    http_response_code(404);
    exit('Le lanceur Windows est introuvable.');
}

// Force le navigateur à télécharger le lanceur comme un fichier Windows.
header('Content-Type: application/octet-stream');
header('Content-Disposition: attachment; filename="westock.bat"');
header('Content-Length: ' . (string) filesize($file));
header('X-Content-Type-Options: nosniff');
readfile($file);

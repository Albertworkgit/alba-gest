<?php
declare(strict_types=1);

// Récupère l’APK en ligne depuis le dossier de cette page, quel que soit le répertoire courant.
$file = __DIR__ . DIRECTORY_SEPARATOR . 'apk' . DIRECTORY_SEPARATOR . 'westock-online.apk';
if (!is_file($file) || !is_readable($file)) {
    http_response_code(404);
    exit('Le fichier APK en ligne est introuvable.');
}

header('Content-Type: application/vnd.android.package-archive');
header('Content-Disposition: attachment; filename="westock-online.apk"');
header('Content-Length: ' . (string) filesize($file));
header('X-Content-Type-Options: nosniff');
readfile($file);

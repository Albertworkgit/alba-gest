<?php
$file = 'westock.bat'; // Nom du fichier

if (file_exists($file)) {
    header('Content-Type: application/vnd.android.package-archive');
    header('Content-Disposition: attachment; filename="' . basename($file) . '"');
    readfile($file);
    exit;
} else {
    echo "Fichier introuvable.";
}
?>

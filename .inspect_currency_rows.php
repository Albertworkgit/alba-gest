<?php
require_once __DIR__ . '/backend/Core/Database.php';
$db = AlbaStock\Core\Database::connection();
$result = $db->query('SELECT type_monais, description FROM tb_monais ORDER BY type_monais');
echo json_encode($result->fetch_all(MYSQLI_ASSOC), JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT), PHP_EOL;

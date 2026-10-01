<?php
declare(strict_types=1);

namespace AlbaStock\Core;

use mysqli;

final class Database
{
    private static ?mysqli $connection = null;

    public static function connection(): mysqli
    {
        if (self::$connection instanceof mysqli) {
            return self::$connection;
        }

        $host = getenv('DB_HOST') ?: '127.0.0.1';
        $database = getenv('DB_NAME') ?: 'bd_stock_multitenant';
        $username = getenv('DB_USER') ?: 'root';
        $password = getenv('DB_PASSWORD') ?: '';
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
        self::$connection = new mysqli($host, $username, $password, $database);
        self::$connection->set_charset('utf8mb4');

        return self::$connection;
    }
}

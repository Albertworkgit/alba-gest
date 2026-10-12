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

        /*
         * Exemple pour l’hébergement cPanel : définissez ces variables dans la
         * configuration d’environnement PHP fournie par votre hébergeur :
         * DB_HOST=localhost
         * DB_NAME=nomcpanel_albastock
         * DB_USER=nomcpanel_utilisateur
         * DB_PASSWORD=remplacez_par_le_mot_de_passe_mysql
         *
         * Remplacez « nomcpanel » par le préfixe réellement affiché dans cPanel,
         * créez la base et l’utilisateur MySQL, puis donnez à cet utilisateur
         * les privilèges nécessaires sur cette base. N’enregistrez pas le vrai
         * mot de passe dans le dépôt Git ni dans un fichier public.
         */
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

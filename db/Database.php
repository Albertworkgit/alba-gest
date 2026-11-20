<?php // Ouvre le script PHP qui gère la connexion à la base de données.
declare(strict_types=1); // Active le contrôle strict des types dans ce fichier.

final class Database // Déclare la classe finale qui centralise l’accès à la base de données.
{ // Ouvre le bloc de la classe Database.
    private static ?PDO $connection = null; // Conserve une connexion PDO réutilisable, ou null avant sa création.

    public static function connection(): PDO // Déclare la méthode publique qui fournit la connexion PDO.
    { // Ouvre le bloc de la méthode connection.
        if (self::$connection instanceof PDO) { // Vérifie si la connexion a déjà été initialisée.
            return self::$connection; // Réutilise la connexion existante au lieu d’en créer une nouvelle.
        } // Termine la vérification de la connexion existante.

        $host = getenv('DB_HOST') ?: '127.0.0.1'; // Lit l’hôte depuis l’environnement, avec l’adresse locale par défaut.
        $database = getenv('DB_NAME') ?: 'bd_stock_multitenant'; // Lit le nom de la base, avec le nom par défaut du projet.
        $username = getenv('DB_USER') ?: 'root'; // Lit l’utilisateur MySQL, avec root comme valeur locale par défaut.
        $password = getenv('DB_PASSWORD') ?: ''; // Lit le mot de passe MySQL, vide par défaut en environnement local.
        $dsn = "mysql:host={$host};dbname={$database};charset=utf8mb4"; // Construit la chaîne PDO pour MySQL et l’encodage UTF-8.

        self::$connection = new PDO($dsn, $username, $password, [ // Crée et mémorise la connexion avec les identifiants configurés.
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, // Demande à PDO de signaler les erreurs sous forme d’exceptions.
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC, // Configure les résultats SQL pour être retournés en tableaux associatifs.
            PDO::ATTR_EMULATE_PREPARES => false, // Utilise les requêtes préparées natives de MySQL plutôt que leur émulation.
        ]); // Termine la configuration et la création de la connexion PDO.

        return self::$connection; // Retourne la connexion initialisée à l’appelant.
    } // Termine la méthode connection.
} // Termine la classe Database.

<?php
declare(strict_types=1);

namespace AlbaStock\Core;

final class JsonResponse
{
    public static function send(mixed $data, int $status = 200): never
    {
        http_response_code($status);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
        exit;
    }

    public static function error(string $message, int $status = 400): never
    {
        self::send(['success' => false, 'message' => $message], $status);
    }

    public static function messageFor(\Throwable $exception): string
    {
        if (!$exception instanceof \mysqli_sql_exception) {
            return $exception->getMessage();
        }

        error_log(sprintf('Database error [%d]: %s', $exception->getCode(), $exception->getMessage()));
        return match ((int) $exception->getCode()) {
            1054, 1146 => 'La structure de la base de données n’est pas à jour. Appliquez les dernières migrations puis réessayez.',
            1062 => 'Cette valeur existe déjà. Vérifiez les informations saisies.',
            1451, 1452 => 'Cette opération est impossible car des données liées sont encore utilisées.',
            default => 'Une erreur est survenue lors de l’accès aux données. Réessayez ou contactez l’administrateur.',
        };
    }
}

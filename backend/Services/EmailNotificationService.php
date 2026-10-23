<?php
declare(strict_types=1);

namespace AlbaStock\Services;

use PHPMailer\PHPMailer\PHPMailer;
use RuntimeException;

final class EmailNotificationService
{
    public function sendEnterpriseRegistration(array $registration): void
    {
        $host = trim((string) getenv('ALBA_STOCK_SMTP_HOST'));
        $recipient = trim((string) getenv('ALBA_STOCK_NOTIFICATION_EMAIL'));
        $fromAddress = trim((string) getenv('ALBA_STOCK_SMTP_FROM'));
        $fromName = trim((string) (getenv('ALBA_STOCK_SMTP_FROM_NAME') ?: 'ALBA-STOCK'));
        $username = (string) getenv('ALBA_STOCK_SMTP_USERNAME');
        $password = (string) getenv('ALBA_STOCK_SMTP_PASSWORD');
        $encryption = strtolower(trim((string) (getenv('ALBA_STOCK_SMTP_ENCRYPTION') ?: 'tls')));
        $port = filter_var(getenv('ALBA_STOCK_SMTP_PORT') ?: '587', FILTER_VALIDATE_INT);

        if ($host === '' || !filter_var($recipient, FILTER_VALIDATE_EMAIL)
            || !filter_var($fromAddress, FILTER_VALIDATE_EMAIL)
            || $port === false || !in_array($encryption, ['tls', 'ssl', 'none'], true)) {
            throw new RuntimeException('La configuration SMTP ou l’adresse de notification est invalide ou incomplète.');
        }

        $mailer = new PHPMailer(true);
        $mailer->isSMTP();
        $mailer->Host = $host;
        $mailer->Port = $port;
        $mailer->SMTPAuth = $username !== '' || $password !== '';
        if ($mailer->SMTPAuth) {
            if ($username === '' || $password === '') throw new RuntimeException('Les identifiants SMTP sont incomplets.');
            $mailer->Username = $username;
            $mailer->Password = $password;
        }
        if ($encryption === 'tls') $mailer->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
        if ($encryption === 'ssl') $mailer->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
        $mailer->CharSet = PHPMailer::CHARSET_UTF8;
        $mailer->setFrom($fromAddress, $fromName);
        $mailer->addAddress($recipient);

        $enterpriseName = trim((string) ($registration['enterprise_name'] ?? ''));
        $contactName = trim((string) ($registration['full_name'] ?? ''));
        $contactEmail = trim((string) ($registration['email'] ?? ''));
        $phone = trim((string) ($registration['phone'] ?? ''));
        $address = trim((string) ($registration['address'] ?? ''));
        $mailer->Subject = 'Nouvelle demande de création d’entreprise';
        $mailer->Body = implode("\n", [
            'Une nouvelle demande d’inscription d’entreprise a été reçue.',
            '',
            'Entreprise : ' . $enterpriseName,
            'Responsable : ' . $contactName,
            'Email : ' . $contactEmail,
            'Téléphone : ' . ($phone !== '' ? $phone : 'Non renseigné'),
            'Adresse : ' . ($address !== '' ? $address : 'Non renseignée'),
            '',
            'Connectez-vous à ALBA-STOCK pour examiner et activer cette demande.',
        ]);
        if (filter_var($contactEmail, FILTER_VALIDATE_EMAIL)) $mailer->addReplyTo($contactEmail, $contactName);
        $mailer->send();
    }
}

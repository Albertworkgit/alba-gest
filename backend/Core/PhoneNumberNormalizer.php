<?php
declare(strict_types=1);

namespace AlbaStock\Core;

final class PhoneNumberNormalizer
{
    public static function normalize(string $phone): string
    {
        $phone = trim($phone);
        return str_starts_with($phone, '0') ? '+243' . substr($phone, 1) : $phone;
    }
}

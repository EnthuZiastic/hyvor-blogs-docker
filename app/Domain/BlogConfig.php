<?php

namespace App\Domain;

class BlogConfig
{

    public static function fromEnv()
    {

        $subdomains = self::env('BLOG_SUBDOMAIN');
        // $hostingDomains = self::env('BLOG_HOSTING_DOMAIN');
        $hostingPaths = self::env('BLOG_HOSTING_PATH');
        $deliveryApiKeys = self::env('BLOG_DELIVERY_API_KEY');
        $webhookSecrets = self::env('BLOG_WEBHOOK_SECRET');

        $blogs = [];

        foreach ($subdomains as $i => $subdomain) {

            $hostingPath = $hostingPaths[$i] ?? '/';
            $deliveryApiKey = $deliveryApiKeys[$i] ?? null;
            $webhookSecret = $webhookSecrets[$i] ?? null;

            $blogs[] = [
                'subdomain' => $subdomain,
                'delivery_api_key' => $deliveryApiKey,
                'webhook_secret' => $webhookSecret,
                'route' => $hostingPath,
                'cache_store' => null,
                'middleware' => [],
            ];

        }

        return $blogs;

    }

    /**
     * @return string[]
     */
    public static function env($key): array
    {
        $val = env($key);

        if (empty($val)) {
            return [];
        }

        $val = explode(',', $val);

        return array_map('trim', $val);
    }

}

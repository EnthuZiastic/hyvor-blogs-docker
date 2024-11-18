<?php

use App\Domain\BlogConfig;

return [

    /**
     * Tutorial: <https://hyvor.com/blog/laravel-blog>
     * Set up one or more blogs within your application
     */
    'blogs' => BlogConfig::fromEnv(),

    /**
     * Hyvor Blog's Base URL to call the delivery API
     * Only useful for package maintainers
     */
    'hb_base_url' => 'https://blogs.hyvor.com',

];

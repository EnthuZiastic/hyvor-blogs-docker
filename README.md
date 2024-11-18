## hyvor-blogs-docker

This repository contains a Docker image for serving a blog with [Hyvor Blogs](https://blogs.hyvor.com).

-   [Docs](https://blogs.hyvor.com/docs/subdirectory)
-   [Docker Hub](https://hub.docker.com/r/hyvor/hyvor-blogs)

## Environment Variables

-   Blog (supports comma-separated values for multiple blogs):

    -   `BLOG_SUBDOMAIN`: The subdomain of the blog. Required.
    -   `BLOG_HOSTING_PATH`: The path where the blog is hosted. Default: `/`.
    -   `BLOG_DELIVERY_API_KEY`: The API key of the blog. Required.
    -   `BLOG_WEBHOOK_SECRET`: The webhook secret of the blog. Required.

-   Laravel

    -   `APP_ENV` - The environment of the Laravel application. Default: `production`.
    -   `APP_DEBUG` - Whether to enable debugging. Default: `false`.
    -   `CACHE_STORE` - The cache store to use. Default: `file`.
    -   In addition, you can set any other Laravel environment variables like Redis, MySQL, etc.

-   PHP
    -   `PHP_MAX_CHILDREN` - Number of PHP-FPM children to spawn. Default: `16`. Increase this if you have a high traffic website.

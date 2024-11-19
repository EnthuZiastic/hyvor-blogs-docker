## hyvor-blogs-docker

This repository contains a Docker image for serving a blog with [Hyvor Blogs](https://blogs.hyvor.com).

-   [Docs](https://blogs.hyvor.com/docs/subdirectory)
-   [Docker Hub](https://hub.docker.com/r/hyvor/hyvor-blogs-docker)

### Usage

```bash
docker run -d \
    -e BLOG_SUBDOMAIN=your-blog \
    -e BLOG_HOSTING_PATH=/blog \
    -e BLOG_DELIVERY_API_KEY=your-api-key \
    -e BLOG_WEBHOOK_SECRET=your-webhook-secret \
    -p 8080:80 \
    hyvor/hyvor-blogs-docker
```

`hyvor/hyvor-blogs-docker` exposes port `80` by default. You can map it to any port on your host machine. See below for the list of environment variables. With the above command, your blog will be available at `http://localhost:8080/blog`. You can run a reverse proxy like Nginx to serve it at `https://your-domain.com/blog`.

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

## Examples

### Multiple Blogs with ENV File

Create a file named `.env` with the following content:

```bash
BLOG_SUBDOMAIN=blog1,blog2
BLOG_HOSTING_PATH=/blog1,/blog2
BLOG_DELIVERY_API_KEY=api-key-1,api-key-2
BLOG_WEBHOOK_SECRET=webhook-secret-1,webhook-secret-2
```

Run the following command:

```bash
docker run -d --env-file .env -p 8080:80 hyvor/hyvor-blogs-docker
```

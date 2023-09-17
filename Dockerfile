# Use the official PHP 8 image as a base image
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    libzip-dev \
    unzip \
    nodejs \
    npm \
    redis-server

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Set the working directory
WORKDIR /var/www/html

# Clone the Voting-App repository
RUN git clone https://github.com/AlpetGexha/Voting-App.git .

# Install Composer dependencies
RUN composer update

# Install npm dependencies
RUN npm install

# Copy .env.example to .env
RUN cp .env.example .env

# Run migrations and seed the database
RUN php artisan migrate --seed

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM and Redis
CMD ["php-fpm"]

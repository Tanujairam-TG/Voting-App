# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Install system dependencies and required PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Set the working directory in the container
WORKDIR /var/www/html

# Clone the repository
RUN git clone https://github.com/AlpetGexha/Voting-App.git .

# Install PHP dependencies
RUN composer update

# Install Node.js dependencies
RUN npm install

# Copy the environment file
RUN cp .env.example .env

# Run database migrations and seed
RUN php artisan migrate --seed

# Expose port 9000 (change as needed)
EXPOSE 9000

# Start PHP-FPM server
CMD ["php-fpm"]

# You may need to customize other configuration settings as per your needs.

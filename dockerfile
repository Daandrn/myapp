FROM php:8.3-fpm

#Define variáveis
ARG user=daan
ARG uid=1000

# Instala dependencias de sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev\
    zip \
    unzip 

# Limpa cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala extensões do PHP
RUN docker-php-ext-install pdo_pgsql mbstring exif pcntl bcmath gd sockets

# Busca ultima versão do composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Cria usuário no sistema para executar comandos do Composer e Artisan
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Escolhe pasta de trabalho principal
WORKDIR /var/www

# Copia os dados do custom.ini para o PHP
COPY docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini

# Cria arquivo php.ini.. para produção usar: php.ini-production
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

#Define usuário
USER $user

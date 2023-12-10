FROM ubuntu:20.04

# Установка необходимых пакетов и очистка кэша APT
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/www/* && \
    rm -rf /var/lib/apt/lists/*

# Создание директорий и копирование файлов
RUN mkdir -p /var/www/my_project/img
COPY index.html /var/www/my_project/
COPY img/img.jpeg /var/www/my_project/img/

# Установка прав на директорию
RUN chmod -R 755 /var/www/my_project

# Создание пользователя и группы, настройка прав
RUN groupadd -r imkenova_group && \
    useradd --no-log-init -r -g imkenova_group imkenova && \
    chown -R imkenova:imkenova_group /var/www/my_project

# Настройка NGINX
RUN sed -i 's/\/var\/www\/html/\/var\/www\/my_project/g' /etc/nginx/sites-enabled/default && \
    nginx_user_file=$(grep -rl 'user .*;' /etc/nginx/) && \
    sed -i 's/user .*;/user imkenova imkenova_group;/g' "$nginx_user_file"

# Запуск NGINX
CMD ["nginx", "-g", "daemon off;"]

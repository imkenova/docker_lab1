#1.Выберите базовый образ
FROM ubuntu:20.04
#2.Выполнить обновление apt-кеша
RUN apt-get update
#3.Обновить все пакеты в контейнере
RUN apt-get upgrade -y
#4.Установить веб сервер nginx
RUN apt-get install nginx -y
#5.Очистить скачанный apt-cache
RUN apt-get clean
#6.Удалить содержимое директории /var/www/
RUN rm -rf /var/www/*
#7.Создать в директории /var/www/ директорию с именем вашего сайта и папку с картинками
RUN mkdir -p /var/www/my_project/img
#8.Поместить из папки с докер файлом в директорию /var/www/ my_project файл index.html.
COPY index.html /var/www//my_project/
#9.Поместить из папки с докер файлом в директорию /var/www/my_project/img файлimg.jpg
COPY img/img.jpeg /var/www/my_project/img/
#10.Задать рекурсивно на папку /var/www/my_project права
RUN chmod -R 755 /var/www/my_project
#11.С помощью команды useradd создать пользователя
RUN useradd -m imkenova
#12.С помощью команды groupadd создать группу
RUN groupadd imkenova_group
#13.С помощью команды usermod поместить пользователя в группу
RUN usermod -a -G imkenova_group imkenova
#14.Рекурсивно присвоить созданных пользователя и группу на папку /var/www/my_project
RUN chown -R imkenova:imkenova_group /var/www/my_project
#15.Воспользоваться конструкцией и заменить в файле /etc/nginx/sites-enabled/default следующую подстроку (/var/www/html)
RUN sed -i 's/\/var\/www\/html/\/var\/www\/my_project/g' /etc/nginx/sites-enabled/default
#16.С помощью команды grep найти в каком файле задается пользователь (user), от которого запускается nginx
RUN grep -rl 'user .*;' /etc/nginx/
#17.С помощью команды sed проделать операцию замены пользователя в файле,найденном в пункте 17 на вашего пользователя
RUN nginx_user_file=$(grep -rl 'user .*;' /etc/nginx/) && sed -i 's/user .*;/user imkenova;/g' "$nginx_user_file"
#18.Соберите ваш контейнер: docker build -t test . - успешно
#19.Проведите тест nginx командой nginx -t - успешно
#20.Определите порт подключения. - по умолчанию 80
#21. Задайте в команды запуска веб-сервера. 
CMD ["nginx", "-g", "daemon off;"]

# Отчёт по лабораторной №4
## Задание
## Выполнение 
1. Установлен Docker по инструкции с [видео](https://yandex.ru/video/preview/3719090281561281090)
2. Создан файл с именем `Dockerfile` с таким содержимым:
```
FROM ubuntu:latest
RUN apt-get update && apt-get install -y libaa-bin iputils-ping && apt-get clean
CMD ["aafire"]
```
*Объяснение:*
- `FROM ubuntu:latest` — указывает базовый образ `Ubuntu`, на основе которого будут работать контейнеры. Команда, указанная после RUN, исполняется в контейнере во время сборки образа
- `RUN apt-get update && apt-get install -y libaa-bin iputils-ping` указывает, какие команды необходимо выполнить в контейнере во время сборки образа:
  - устанавливает пакет `libaa-bin` (содержит `aafire`).
  - устанавливает `iputils-ping` (утилита `ping`).
  - `apt-get clean` — удаляет временные файлы `apt`.
- `CMD ["aafire"]` — указывает команду, которая будет запускаться при старте контейнера.

3. Собран `Docker-образ`
В папке с файлом `Dockerfile` выполнена команда:
```bash
sudo docker build -t aafire_image .
```
![image](https://github.com/user-attachments/assets/e4632194-dddd-4e9a-8447-b5ad6906221f)

*Объяснение:*
- `docker build` — собирает Docker-образ.
- `-t aafire_image` — задаёт имя (`tag`) образу.
- `.` — указывает, что `Dockerfile` находится в текущей директории.

Проверена успешность сборки:
Следующая команда ...
```bash
sudo docker images
```
... вывела:
![image](https://github.com/user-attachments/assets/78772063-325d-49aa-871f-8a0e2df4f3c0)

4. Запуск контейнеров
```bash
sudo docker run --name first_container -it aafire_image
sudo docker run --name second_container -it aafire_image
```

*Объяснение:*
- `docker run` — запускает новый контейнер.
- `--name <container_name>` — задаёт имя контейнеру.
- `-it` — запускает контейнер в интерактивном режиме.
- `aafire_image` — имя образа, на основе которого будет создан контейнер.
  
На экране появилась анимация огня `aafire`:
![image](https://github.com/user-attachments/assets/c18a1fc1-823d-4ad5-994f-5a8dc5a623d7)

Проверка, что оба контейнера созданы:
```bash
sudo docker ps -a
```
![image](https://github.com/user-attachments/assets/4d95f25e-1197-4375-ae2e-31c129a61640)

5. Запуск контейнеров:
```bash
sudo docker start first_container second_container
```
Статус контейнеров должен поменяться.
![image](https://github.com/user-attachments/assets/fb9e5003-7ebc-4146-986e-428612e8aeff)


5. Создание и подключение сети
```bash
sudo docker network create Network
```
Подключение контейнеров к сети:
```bash
sudo docker network connect Network first_container
sudo docker network connect Network second_container
```
![image](https://github.com/user-attachments/assets/36e12006-f981-41f5-bce7-74ed936a83ce)

Проверка подключения контейнеров:
```bash
sudo docker network inspect Network
```
В поле `containers` должны быть указаны данные о созданных контейнерах:
![image](https://github.com/user-attachments/assets/09bb48ca-9c8b-4e99-b53e-cc7c5f293228)

***Запомним также адреса контейнеров в сети** (поле `"IPv4Address"`):*

`first_container` — `172.18.0.2/16`

`second_container` — `172.18.0.3/16`

7. Проверка соединения
Запуск `bash` внутри `first_container`:
```bash
sudo docker exec -it first_container bash
```
*Объяснение:*
- `docker exec` — запускает команду внутри работающего контейнера.
- `-it` — интерактивный режим.
- `bash` — запускает оболочку Bash внутри контейнера.

Проверка соединения с `second_container`:
```bash
ping 172.18.0.3
```
![image](https://github.com/user-attachments/assets/01f6cf81-71ce-460d-8be7-4f63d9d3a659)


Аналогично проверяем доступ `second_container` к `first_container`:
![image](https://github.com/user-attachments/assets/13b33a82-fe62-4218-ae3d-0d0a44d54f29)

8. Выключение контейнеров:
```bash
sudo docker stop first_container second_container
```
![image](https://github.com/user-attachments/assets/c921f9e3-e717-49e6-b73e-04a9ebcfce2c)


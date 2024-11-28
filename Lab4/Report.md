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
docker build -t aafire_image .
```

*Объяснение:*
- `docker build` — собирает Docker-образ.
- `-t aafire_image` — задаёт имя (`tag`) образу.
- `.` — указывает, что `Dockerfile` находится в текущей директории.

Проверена успешность сборки:
Следующая команда ...
```bash
docker images
```
... вывела:

4. Запустить первый контейнер
Запустите первый контейнер:

bash
Копировать код
docker run --name mycontainer1 -it aafire_image
Объяснение:

docker run — запускает новый контейнер.
--name mycontainer1 — задаёт имя контейнеру.
-it — запускает контейнер в интерактивном режиме.
aafire_image — имя образа.
На экране появится анимация огня aafire. Сделайте скриншот.

5. Запустить второй контейнер
Откройте новое окно терминала и запустите второй контейнер:

bash
Копировать код
docker run --name mycontainer2 -it aafire_image
Проверьте, что оба контейнера работают:

bash
Копировать код
docker ps
6. Создать и подключить сеть
Создайте сеть myNetwork:

bash
Копировать код
docker network create myNetwork
Объяснение:

docker network create — создаёт новую сеть.
myNetwork — имя сети.
Подключите оба контейнера к сети:

bash
Копировать код
docker network connect myNetwork mycontainer1
docker network connect myNetwork mycontainer2
Объяснение:

docker network connect — подключает контейнер к указанной сети.
mycontainer1, mycontainer2 — имена контейнеров.
Убедитесь, что контейнеры подключены:

bash
Копировать код
docker network inspect myNetwork
Объяснение:

docker network inspect — отображает информацию о сети.
7. Проверить соединение
Подключитесь к контейнеру mycontainer1:

bash
Копировать код
docker exec -it mycontainer1 bash
Объяснение:

docker exec — запускает команду внутри работающего контейнера.
-it — интерактивный режим.
bash — запускает оболочку Bash внутри контейнера.
Найдите IP-адрес второго контейнера:

bash
Копировать код
docker network inspect myNetwork
Обратите внимание на поле "IPv4Address" для контейнера mycontainer2.

Проверьте соединение с mycontainer2, выполнив команду:

bash
Копировать код
ping <IP-адрес mycontainer2>
Сделайте скриншот результата.

8. Финальная проверка
Убедитесь, что:

Анимация aafire работает в обоих контейнерах.
ping между контейнерами успешен.


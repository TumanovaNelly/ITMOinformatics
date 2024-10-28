# Отчёт по лабораторной №1
## Задание
1. Настроить виртуальные машины А, B, C с Ubuntu в VirtualBox. 
2. Обеспечить доступ машины А в сеть Интернет. Осуществить проверку этого доступа и приложить скриншот из терминала.
3. Организовать сетевой доступ:
- из машины А к машине B (запретить доступ из машины B к машине А)
- из машины А в машину С (запретить доступ из машины С к машине А),
- запретить доступ из машины В к машине С, из машины С к машине В

![image](https://github.com/user-attachments/assets/ddf90244-e5d3-499e-b335-7ed8cead6d01)

Приложить скриншот, на котором видно терминалы всех трёх машин и видно что между машинами есть (или нет) доступа.
## Выполнение
1. Установка VirtualBox
- Скачиваем VirtualBox.exe по ссылке [https://www.virtualbox.org/wiki/Download_Old_Builds_6_0] (версия 6.0.24)
- На странице находится список дистрибутивов для загрузки на ПК под управлением разных ОС. Т.к. программа устанавливалась на ПК под управлением Windows, была выбрана версия Windows hosts (она первая в списке).

![image](https://github.com/user-attachments/assets/92217887-5a9b-43c8-b8f4-c8065fb69e0a)

2. Создание виртуальных машин:
**for i in range(3):**
- В VirtualBox, нажимаем "Создать".

![image](https://github.com/user-attachments/assets/07bf6cda-e39d-4e02-8425-700aeeb7b4db)

- Указываем имя, выбераем тип ОС (Linux) и версию (Ubuntu 64-bit).
- Указываем объем оперативной памяти (рекомендуется не менее 2048 МБ).
- Создаем виртуальный жёсткий диск (тип VDI, динамически распределяемый, размер не менее 20 ГБ).

3. Установка Ubuntu на машины:
**for i in range(3):**
- скачиваем установочный образ Ubuntu Desktop (ISO файл) по ссылке [https://ubuntu.com/download/desktop] с официального сайта.
- Запускаем машину и выбераем установочный образ Ubuntu.
- Следуем шагам установки (выбор языка, создание пользователя и т.д.).

4. Обеспечение доступа А к интернету
- В настройках VirtualBox для машины А выбираем сетевой адаптер. ("настройки" - "сеть")
- Включаем "Сетевой мост" (Bridge Adapter), чтобы получить доступ в интернет через физический адаптер.

![image](https://github.com/user-attachments/assets/807c8a1a-af96-4624-96cc-9b9c7b6548ca)

- Запускаем машину, открываем терминал и выполняем команду для проверки доступа в интернет:
```bash
ping ya.ru
```

![image](https://github.com/user-attachments/assets/5ad00cfe-6574-42ea-8a6e-aad2966e8dcf)


5. Настройка локальной сети машин
- В настройках VirtualBox для каждой машины выбираем сетевой адаптер ("настройки" - "сеть"). Для машины А включаем второй адаптер. 
- Выбираем тип подключения "Локальная сеть", вводим имя локальной сети.
- Убеждаемся, что имя локальной сети для всех трех машин одинаково.

Для машины А это будет выглядеть так:

![image](https://github.com/user-attachments/assets/45ad14f0-5d94-4a2d-97a1-8c159003ffb7)

Для машины В:

![image](https://github.com/user-attachments/assets/6ec01b0c-c209-42c6-9831-0f54a8ea7bb3)

Для машины С:

![image](https://github.com/user-attachments/assets/cfb5f22f-48b9-4805-8906-531461a9d5a8)

7. Настройка адресов машин в локальной сети
После настройки виртуальных машин на использование внутренней сети, необходимо настроить статические IP-адреса, так как VirtualBox в режиме "Внутренняя сеть" не использует DHCP по умолчанию.
- Запускаем машину А, открываем сетевые настройки при помощи команды:
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```
- Изменяем файл по образцу:
```yaml
network:
  ethernets:
    enp0s3:
      dhcp4: no
      addresses:
        - 192.168.100.1/24
  version: 2
```
\- и сохраняем его.
Так это выглядит для машины А:

![image](https://github.com/user-attachments/assets/a1dc3172-e5c5-4b09-8052-f2ccb5b99a0d)

- Применяем настройки к сети при помощи команды:
```bash
sudo netplan apply
```
- Можно проверить, что все сделано верно, посмотрев ip-адреса машины:
```bash
ip addr show
```

![image](https://github.com/user-attachments/assets/6226ec33-b825-4d92-b3d6-ffba5a33e178)

- Устанавливаем другие адреса на машины В и С аналогичным образом:

(В)
![image](https://github.com/user-attachments/assets/ec9b094b-5b41-49cf-bab6-68cfe2325ca9)
![image](https://github.com/user-attachments/assets/feec5722-a376-459f-b89a-0977a6e0af7a)
(С)
![image](https://github.com/user-attachments/assets/dd385f71-f119-4340-9dea-771e4b5ec5be)
![image](https://github.com/user-attachments/assets/4c93876d-bc1d-47a2-97d3-4b3975ee633f)

Далее адреса машин в локальной сети:

**А - 192.168.100.1**

**В - 192.168.100.2**

**С - 192.168.100.3**

8. Организация сетевого доступа между А и С
- Сейчас все машины имеют доступ ко всем. Проверим, например доступ между А и С. Для этого на одной из машин пишем команду:
```bash
ping <ip-адрес другой машины>
```
![image](https://github.com/user-attachments/assets/13814d22-eb63-48d6-9d47-35f50a0cbd41)

- Запретим все новые исходящие от C к А соединения. Для этого на машине С выполним:
```bash
sudo iptables -A OUTPUT -d <ip-адрес машины А> -m state --state NEW -j DROP
```
- При этом разрешим исходящие соединения от С к А, если они являются установленными или связанными. Это позволит машине С отправлять ответы на соединения, которые были инициированы машиной А. На машине С напишем:
```bash
sudo iptables -A OUTPUT -d <ip-адрес машины А> -m state --state ESTABLISHED,RELATED -j ACCEPT
```
- Проверим, что у С нет доступа к А, а у машины А он есть.

![image](https://github.com/user-attachments/assets/e1e804c5-843e-42f6-98a3-39168ed4bc9e)

9. Организация сетевого доступа между А и В
Абсолютно аналогично предыдущему пункту

![image](https://github.com/user-attachments/assets/88aa3634-7dcf-4322-b317-cc2dc3980f7e)

10. Организация сетевого доступа между В и С
- Запретим все новые исходящие от C к В соединения. Для этого на машине С выполним:
```bash
sudo iptables -A OUTPUT -d <ip-адрес машины В> -m state --state NEW -j DROP
```
- Запретим все новые исходящие от В к С соединения. Для этого на машине В выполним:
```bash
sudo iptables -A OUTPUT -d <ip-адрес машины С> -m state --state NEW -j DROP
```
- Проверим, что у В и С нет доступа друг к другу

![image](https://github.com/user-attachments/assets/e3955c83-b823-4f33-a5f5-257a492aedc4)

11. Посмотрим итоговые таблицы маршрутиризации машин
Команда
```bash
sudo iptables -L
```
выводит таблицу маршрутиризации для данного устройства

(А)

![image](https://github.com/user-attachments/assets/d9aed4cc-9162-434e-99dc-53ad3b46b1f3)

(В)

![image](https://github.com/user-attachments/assets/64c62b41-641f-48f9-a23f-7791db1c305c)

(С)

![image](https://github.com/user-attachments/assets/9618b3f9-9ba3-4f35-9fb3-8a4b120db403)

12. Сохранение настроек таблиц
Для того чтобы правила оставались после перезагрузки, их нужно сохранить.
- в `/etc` создадим папку `iptables\`, а в ней файл `iptables.rules`, для безопасности изменим права доступа к файлу на 640
```bash
sudo mkdir /etc/iptables
sudo touch /etc/iptables/iptables.rules
sudo chmod 640 /etc/iptables/iptables.rules
```
- сохраним настройки iptables в файл `iptables.rules`
```bash
sudo iptables-save | sudo tee /etc/iptables/iptables.rules > /dev/null
```
- проверим, что все записалось
```bash
sudo cat /etc/iptables/iptables.rules
```

Для машины В это выглядит так:

![image](https://github.com/user-attachments/assets/0e6eaa70-3f43-406d-8e91-1d2a05c4ffb2)

Для С аналогично:

![image](https://github.com/user-attachments/assets/a5344015-d6eb-480a-8c78-43337b964312)

13.  Восстановление настроек после перезагрузки
После перезагрузки, чтобы восстановить настройки, надо выполнить:
```bash
sudo iptables-restore /etc/iptables/iptables.rules
```

![image](https://github.com/user-attachments/assets/458319c5-2937-4704-949c-9460beccff97)

## Вывод
В результате работы настроена виртуальная сеть с доступом в Интернет для одной из ВМ и возможностью обмена данными между всеми ВМ с ограничением на соединение ВМ Б с ВМ В.


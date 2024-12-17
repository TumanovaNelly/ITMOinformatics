# Отчёт по лабораторной №5
## [Задание](README.md)
1) Автоматизировать проверку формата файлов при коммите с использованием `Git Hooks`.
2) Сымитировать работу над проектом, реализующим модель ветвления `Git Flow`

## Выполнение 
Создадим на `GitHub` отдельный репозиторий (https://github.com/TumanovaNelly/GitPractice), склонируем его на локальную машину и перейдем в корневую папку этого репозитория:
```
git clone https://github.com/TumanovaNelly/GitPractice
cd GitPractice
```
### 1 task
1. Перейдем в папку `.git/hooks` и создадим там файл `pre-commit`
```
cd .git/hooks
touch pre-commit
```
2. В этом файле напишем и сохраним следующий скрипт, который проверяет все `.txt` файлы в коммите на наличие надписи `"Подпись автора"`:
```
#!/bin/bash

# Получаем список файлов, добавленных в коммит
FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.txt$')

# Если нет файлов .txt, завершаем
if [[ -z "$FILES" ]]; then
    echo "No .txt files to check."
    exit 0
fi

# Переменная для хранения статуса проверки
STATUS=0

# Проверяем каждый .txt файл
for FILE in $FILES; do
    # Проверяем, что файл существует
    if [[ ! -f $FILE ]]; then
        echo "File $FILE does not exist."
        STATUS=1
        continue
    fi

    # Проверяем наличие "Подпись автора" в конце файла
    if ! grep -q "Подпись автора" "$FILE"; then
        echo "Error: File $FILE does not contain 'Подпись автора'."
        STATUS=1
    fi
done

# Если хотя бы один файл не прошел проверку, прерываем коммит
if [[ $STATUS -ne 0 ]]; then
    echo "Commit aborted due to errors in .txt files."
    exit 1
fi

echo "All .txt files passed the check."
exit 0
```
3. Сделаем `pre-commit` исполняемым и вернемся в корень репозитория:
```
chmod +x pre-commit
cd ../..
```
<img width="559" alt="image" src="https://github.com/user-attachments/assets/19eef356-a0c8-48db-8d6a-1f3f7815955e"/>

4. Осталось проверить, что все работает:

Попробуем закоммитить `file.txt` с надписью `Файл, содержащий 'Подпись автора'`:
![image](https://github.com/user-attachments/assets/0a5f0b45-63f8-47b9-870b-3bfe6315d286)
Коммит удачно создается, выводится сообщение `All .txt files passed the check.`

Теперь попробуем закоммитить измененный `file.txt` с надписью `Теперь это файл без подписи`:
![image](https://github.com/user-attachments/assets/3f154848-2dc0-4207-ab27-d4412ff9525b)
При создании коммита возникает ошибка и выводится сообщение `File file.txt does not contain 'Подпись автора'`

### 2 task
1. Убедимся, что `Git Flow` установлен на локальной машине и, находясь в корне того же репозитория, выполним инициализацию `Git Flow` (оставляем все имена веток по умолчанию):
```
sudo apt-get install git-flow
git flow init
```

![image](https://github.com/user-attachments/assets/b220a1da-a1df-42ef-b53c-21dc61df3a83)
`Git flow` сразу же создает новую ветку `develop` на основе `main` и переключается на нее. 

2. Добавим новую функциональность в наш проект. Для этого сначала создадим фича-ветку `hello-task`:

![image](https://github.com/user-attachments/assets/62192602-0fcc-4da2-a5c0-cf93015c98fc)
`Git flow` автоматически переключает на созданную ветку.

Создадим программу на `python`, содержащую функцию вывода `Hello, World` на экран:

![image](https://github.com/user-attachments/assets/b7711346-c92c-47b2-a66b-9d87cea1bf50)

Закоммитим изменения в ветку `feature/hello-task`:

![image](https://github.com/user-attachments/assets/e3885f7a-7eff-4666-bdaf-5ef30c72a97f)

Допустим, на одном коммите разработка новой функциональности завершилась. Теперь можно слить фича-ветку с `develop`:

![image](https://github.com/user-attachments/assets/e27b63eb-5075-4dab-8a8e-dabf655e8806)
`Git flow` переключается автоматически на ветку `develop` и выполняет слияние

3. Создадим новый релиз проекта. Сначала создадим новую релиз-ветку `v1.0.0`:

![image](https://github.com/user-attachments/assets/d44d9ab2-6c50-4209-9a7d-0e28f957e016)
`Git flow` автоматически переключается на созданную ветку.

Внесем изменения, связанные с релизом. Например, обновим `README.md` и закоммитим изменения в ветку `release/v1.0.0`

![image](https://github.com/user-attachments/assets/d4de41d3-529b-4649-aff0-f9dbe6debe52)

Допустим, это все изменения, которые необходимо сделать. Значит, можно слить релиз-ветку с `main` и `develop` ветками

![image](https://github.com/user-attachments/assets/429d78a3-2095-42e8-a583-d60a94895da2)
`Git flow` переключается на ветку `main` и выполняет слияние с релиз-веткой, далее переключается на ветку `develop` и выполняет слияние с релиз-веткой.

5. Допустим, в процессе использования (после слития релиза с основными ветками) была выявлена критическая ошибка. Исправим ее.

6. Завершаем работу и отправляем все на удаленный репозиторий

## Вывод
[Источник, где можно найти все](https://www.google.com/)

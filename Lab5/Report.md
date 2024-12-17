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

## Вывод
[Источник, где можно найти все](https://www.google.com/)

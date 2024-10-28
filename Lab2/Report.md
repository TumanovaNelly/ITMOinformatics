
# Отчёт по лабораторной №1
## Задание
На основе изученного материала лабораторной работы, лекций (2 и 3), дополнительных источников напишите скрипт, который на вход принимает IPv4-адрес в десятичном формате, а на выходе обеспечивает данный IP-адрес в двоичном формате.

Пример работы:
```bash
./convert_ip.bash 192.168.10.1
```
\>\>\> `11000000.10101000.00001010.00000001`

## Выполнение
### 1. Инициализация и проверка аргументов
Cкрипт начинается с проверки количества входных аргументов: он ожидает ровно один аргумент (IP-адрес). Если количество аргументов не соответствует ожиданиям, выводится сообщение и выполнение скрипта завершается.
```bash
if [[ $# -ne 1 ]]; then
  echo "Передайте ровно один аргумент"
  exit 1
fi
```
***Более подробно:***

1. `if [[ ... ]]; then ... fi` — стандартная конструкция в Bash для выполнения блоков кода в зависимости от условий.

- `if` — начинается условие.
- `[[ ... ]]` — конструкция расширенной проверки условия (новее и безопаснее, чем одинарные скобки `[ ... ]`).
- `then` — указывает на начало кода, который выполняется, если условие истинно (возвращает true).
- `fi` — закрывающий оператор, который завершает блок условия `if`.

2. `$#` — переменная, которая показывает, сколько аргументов было использовано при запуске скрипта.

2. `-ne` — оператор, который означает "не равно" (от англ. "not equal").
В данном случае, сравнивается количество элементов в массиве с числом 4.

*Другие подобные операторы:*

`-eq` — равно.

`-lt` — меньше.

`-gt` — больше.

`-le` — меньше или равно.

`-ge` — больше или равно.

3. `exit 1` завершает выполнение скрипта с кодом выхода 1.

Код выхода 1 (или любое ненулевое значение) обычно используется для обозначения ошибки.

Если код выхода 0, это обычно означает, что программа завершилась успешно.

### 2. Чтение и разделение IP-адреса
Вводимый IP-адрес сохраняется в переменной $ip_address. После этого адрес разбивается на отдельные октеты с использованием точки (.) как разделителя. Результат записывается в массив octets.
IFS (Internal Field Separator) 
```bash
ip_address=$1

declare -a octets
IFS="." read -r -a octets <<< "$ip_address"
```
***Более подробно:***

1. `IFS (Internal Field Separator)` — специальная переменная в Bash, которая определяет символы-разделители, используемые для разделения строки на слова.
В данном случае, IFS временно устанавливается в точку ".", чтобы разделить IP-адрес по точкам.

2. `read` — команда, которая читает данные из ввода.

`-r` — флаг, предотвращающий обработку escape-последовательностей (например, чтобы обратный слеш `\` не интерпретировался как управляющий символ и не игнорировался).

`-a octets` — флаг `-a` означает, что результат будет сохранён в массив (здесь в `octets`)

3. `<<< "$ip_address"` — это так называемый "here string", специальный синтаксис Bash, который позволяет передать содержимое переменной или строки как стандартный ввод для команды.

### 3. Проверка структуры IP-адреса
После разбития необходимо проверить корректность введенного адреса. В этом шаге проверяется, что массив содержит ровно 4 элемента.
```bash
if [[ ${#octets[@]} -ne 4 ]]; then
  echo "IP-адрес должен состоять из 4х октетов"
  exit 1
fi
```

***Более подробно:***

1. `${ ... }` — синтаксис для получения длины строки или количества элементов в массиве.

2. `octets[@]` — обозначение всех элементов массива octets.

### 4. Для каждого октета проводится:
#### 4.1. Проверка
Для каждого октета выполняется дальнейшая проверка на соответствие требованиям. А именно:
Проверка, что октет представляет собой натуральное число (используется регулярное выражение).
Проверка, что значение октета не превышает 255.
Если какой-либо октет не соответствует этим критериям, выводится сообщение об ошибке и выполнение скрипта завершается.

#### 4.2. Конвертация в двоичный формат:
Для каждого корректного октета используется команда printf вместе с утилитой bc для преобразования десятичного числа в двоичный. Результат записывается в массив octets_binary, при этом добавляются ведущие нули (до 8 бит).

```bash
declare -a octets_binary
for i in "${!octets[@]}"; do
  # Проверка, что текущий октет - натуральное число
  if ! [[ ${octets[$i]} =~ ^[0-9]+$ ]]; then
    echo "Октеты должны быть натуральными числами"
    exit 1
  fi

  # Проверка, что текущий октет - число до 255
  if [[ ${octets[$i]} -ge 256 ]]; then
    echo "Октеты должны быть числами до 255"
    exit 1
  fi

  octets_binary[$i]=$(printf "%08d" "$(echo "obase=2; ${octets[$i]}" | bc)")
done
```

***Более подробно:***
1. `for i in ...; do ... done` — стандартный цикл for в Bash, который позволяет пройти по каждому элементу или индексу массива.

2. `"${!octets[@]}"` — синтаксис для получения индексов массива octets. В данном случае вернет `0 1 2 3`

*Вообще, можно было заменить `for i in "${!octets[@]}"` на `for ((i=0; i<${#octets[@]}; i++))`, но...*

Вроде как `for i in "${!octets[@]}"` может быть немного быстрее, так как он напрямую использует индексы массива, и Bash оптимизирован для работы с этим синтаксисом.

`for ((i=0; i<${#octets[@]}; i++))` может иметь небольшую накладную на вычисление длины массива, особенно для больших массивов. Для маленьких массивов эта разница минимальна и, скорее всего, неощутима.

*Или можно было бы использовать `for ((i=0; i<4; i++))` или `for i in {0..3}`, ведь размер массива сто процентов известен но в таком случае теряется гибкость программы и читаемость кода*

3. `echo "obase=2; ${octets[$i]}" | bc` — преобразование октета в двоичную систему счисления.

`| bc` — передача команды (в данном случае вывод строки `"obase=2; ${octets[$i]}"`) через пайплайн в калькулятор `bc`. `bc` *[basic calculator]* — это командный калькулятор, который выполняет арифметические операции. 

`obase=2` — команда для калькулятора `bc`, которая устанавливает выходную систему счисления на двоичную (базу 2). Это означает, что любое число, которое мы передаём после этого, будет преобразовано в двоичный формат.

4. `printf` — команда для форматированного вывода.

`"%08d"` — форматная строка, которая определяет, как выводить значение:
- `%d` — означает, что выводится целое число.
- `08` — указывает, что выводимое число должно быть ровно 8 символов в длину, и если число короче, добавляются ведущие нули.

### 5. Вывод результата
Наконец, результирующие двоичные октеты объединяются в строку и выводятся на экран в необходимом формате
```bash
echo "${octets_binary[0]}.${octets_binary[1]}.${octets_binary[2]}.${octets_binary[3]}"
```
## Вывод
В данной лабораторной работе был разработан Bash-скрипт, который позволяет конвертировать IPv4-адрес, заданный в десятичном формате, в двоичный формат. Он обеспечивает надежность работы благодаря корректной валидации и обработке ошибок. 

Структура работы основывается на использовании условных операторов, циклов и функциональности Bash для обработки строк и работы с массивами.

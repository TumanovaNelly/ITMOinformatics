#!/bin/bash

# Проверка на количество аргументов
if [[ $# -ne 1 ]]; then
    echo "Передайте ровно один аргумент"
    exit 1
fi


# Получение IP-адреса из 1 аргумента
IP_ADDRESS=$1


# Разделение IP-адреса на слова (разделитель - ".") и их запись в массив OCTETS
declare -a OCTETS
IFS="." read -r -a OCTETS <<< "$IP_ADDRESS"
# IFS - глоб. массив разделителей
# -a для записи каждого слова в отдельную ячеуку массива
# -r для того, чтобы \ не воспринимался как символ экранирования


# Проверка, что введенный IP-адрес состоит из четырех октетов
if [[ ${#OCTETS[@]} -ne 4 ]]; then
  echo "IP-адрес должен состоять из 4х октетов"
  exit 1
fi
# array[@] предстаялет собой все элементы array


declare -a OCTETS_BINARY
for i in "${!OCTETS[@]}"; do
  # Проверка, что текущий октет - натуральное число
  if ! [[ ${OCTETS[$i]} =~ ^[0-9]+$ ]]; then
    echo "Октеты должны быть натуральными числами"
    exit 1
  fi


  # Проверка, что текущий октет - число до 255
  if [[ ${OCTETS[$i]} -ge 256 ]]; then
    echo "Октеты должны быть числами до 255"
    exit 1
  fi


  OCTETS_BINARY[$i]=$(printf "%08d" "$(echo "obase=2; ${OCTETS[$i]}" | bc)")
done
# !array[@] == range(0, {#array[@]})


echo "${OCTETS_BINARY[0]}.${OCTETS_BINARY[1]}.${OCTETS_BINARY[2]}.${OCTETS_BINARY[3]}"




# Bash: Bourne Again Shell  
**2 режима:** интерактивный и неинтерактивный (скрипты)  
  
**bash** распознает каждое слово как аргумент, чтобы, например, не удалить лишнее, используйте кавычки:
```rm "one two three four.mp3"```, иначе  попытается удалить 4 файла  
также нужны пробелы в следующей ситуации: ```[ -f file ]``` вместо ```[-f file]``` так как [ - это команда, все остальное аргументы  
  
> почти всё - строка (имя команды, каждый аргумент, имена и значения переменных, ...)  
  
в начале скрипта идет шебанг (#!)
```bash
#!/bin/bash или #!/usr/bin/env bash  
```
   
# Cпец символы  

|   символ     |                                      описание                                      |
| :---:        |             :---                                                      |
|   **$**            | expansion: parameter expansion ```$var``` or ```${var}```, command substitution ```$(command)```, or arithmetic expansion ```$(( expression ))```. | 
|   **' '**          | single quotes: защищает строку от интерпретации, например ```echo``` выведет как есть выражение с **''** |
|   **" "**          | double quotes: защищает строку от разбиения на несколько аргументов, пример с ```rm``` выше| 
|   **\\**           | escape: защищает следующий символ от интерпретации, игнорируется в **' '** |  
|   **#**            | comment  
|   **[[ ]]**        | test: вычисляет условное выражение в ```true``` или ```false``` соотв  
|   **!**            | negate  
|   **><**           | redirecton: перенаправляет ввод и вывод команды  
|   **\|**           | pipe: перенаправляет вывод начальной команды в ввод другой ```(echo "Hello world" | grep -o world)```
|   **;**            | separator: разделяет команды находящиеся на 1 строке  
|   **{ }**          | inline group: команды внутри воспринимаются как 1 команда (No subshell is created)  
|   **( )**          | subshell group: похоже на предыдущую, но если есть сайд-эффекты такие как изменения переменных - не повлияет на текущий shell  
|   **(( ))**        | arithmetic expression: используется для присваивания ```(( a = 1 + 4 ))``` или тестов ```if (( a < b ))``` 
| **$(( ))**         | arithmetic expansion: как и прошлое, но выражение заменяется рез-татом вычисления ```echo "Среднее значение = $(( (a+b)/2 ))"```
| **~**              | home dir  
  
  
# Переменные    
```varname=vardata```  

Нет пробелов между ```=```, так как иначе воспримет ```=``` и ```vardata``` как аргументы к некой команде ```varname```

Для доступа к значению переменной используем parameter expansion:
```bash
$ foo=bar; echo "Foo is $foo"  
```
  
### Параметры
 
Переменные - это один из видов параметров, которые доступны по имени, остальные это **спец параметры:**

|   имя       |   использование   |                         описание                                   |
| :---:        |    :----:         |          :---                                                      |
|  **0**      |     **$0**        |    Содержит название или путь скрипта  
|  **1 2 и т.д.**      |     **$1**        |     Positional parameters: аргументы, переданные данному скрипту/функции
|  **\***     |    **$\***        |  Содержит все positional parameters, в двойных кавычках, 1 строка  |
|  **@**     |    **$@**         |  Содержит все positional parameters, в двойных кавычках, список    |
|  **#**     |    **$#**         |  Число positional parameters                                       |
|  **?**     |    **$?**         |  Exit code предыдущей команды                                      |
|  **$**     |    **$$**         |  PID (process ID) текущей shell                                    |
|  **!**     |    **$!**         |  PID of the most recently executed background pipeline             |
|  **_**     |    **$_**         |  Последний аргумент последней выполненной команды                  |
  
## Типы переменных:
 
> **bash** не типизирован, но есть разные виды переменных  
  
**Array**: ```declare -a variable```: Массив строк  

**Associative array**: ```declare -A variable```: Ассоциативный массив строк (bash 4.0 or higher)  

**Integer**: ```declare -i variable```: Присвоение к этому числу автоматически вызывает Arithmetic Evaluation
  
**Read Only**: ```declare -r variable```

**Export**: ```declare -x variable```: Будет унаследовано дочерними процессами  
  
*Примеры :*
```bash 
$ a=5; a+=2; echo "$a"; unset a  
52  
$ a=5; let a+=2; echo "$a"; unset a  
7  
$ declare -i a=5; a+=2; echo "$a"; unset a  
7  
$ a=5+2; echo "$a"; unset a  
5+2  
$ declare -i a=5+2; echo "$a"; unset a  
7
``` 
  
Лучше не использовать Integer, а писать явно ```((...))``` или использовать ```let```, ибо не очевидно  
Для массива (не ассоциативного) лучше писать ```array=(...)```  
 
## Parameter expansion  
  
Иногда ```$variable``` не хватает и требуется ```${variable}``` 
```bash
$ echo "'$USER', '$USERs', '${USER}s'"  
'lhunath', '', 'lhunaths'
```
|   синтаксис                |                         описание                                            |
|----------------------------|-----------------------------------------------------------------------------|
| **${parameter:-word}**    &nbsp;&nbsp;&nbsp;&nbsp; |  Use default value. Если 'parameter' unset или null, 'word' (может являться expansion) подставится  |
| **${parameter:=word}**       |  Assign default value. Если 'parameter' unset или null, 'word' (может являться expansion) присвоится 'parameter' |
| **${parameter:+word}**       |      Use Alternate Value. Если 'parameter' unset или null ничего не подставится, в противном случае 'word' |  
| **${parameter:offset:length}**&nbsp;   |  Substring expansion. Здесь offset - позиция (с нуля), length - число символов, length необязателен, offset бывает отрицательным |
| **${#parameter}**            | Количество символов 'parameter' |  
| **${parameter#pattern}**     | Паттерн матчится с начала, результат - выкидывание из строки наиболее короткого совпадения |
| **${parameter##pattern}**    | Как и прошлое, только выкидывается длиннейшее совпадение (жадность)  |
| **${parameter%pattern}**     | Паттерн матчится с конца, кротчайшее |
| **${parameter%%pattern}**    | ..., длиннейшее |
| **${parameter/pat/string}**  | Первое совпадение 'pat' меняется на 'string'  
| **${parameter//pat/string}** | Каждое совпадение ... |  
| **${parameter/#pat/string}** | |        
| **${parameter/%pat/string}** | |  
  
Нельзя использовать множественные **PE**, надо разбивать выражения:
```bash  
$ file="${HOME}/image.jpg"; file="${file##*/}"; echo "${file%.*}"  
image
```
  
  
 
# Паттерны  
Есть три вида - ```globs```, ```extended globs```, ```regular expression``` (в основном в скриптах для проверки ввода юзера).
Для выборки файлов только *globs* и *ext globs*.  
  
## Glob Patterns  
Важны (can be used to match filenames or other strings), **состоят из символов и метасимволов:**  
- **\*** Matches any string, including the null string.  
- **?** Matches any single character.  
- **[. . .]** Matches any one of the enclosed characters.  
  
Они неявно содержат якоря с двух сторон, то есть ```a*``` не сматчит **cat**, но ```ca*``` сматчит  
```bash
$ ls  
a abc b c
$ echo *
a abc b c
$ echo a*
a abc
```
  
> Bash видит glob, расширяет (expand) его, превращая в список, то есть echo a* -> echo a abc  
Когда bash матчит filenames, то * и ? не могут в слэш (/), то есть матчят до него  
например */bin сматчится на foo/bin, но не сможет на /usr/local/bin  
  
Для обхода вместо ls лучше использовать glob *, пример:
```bash
$ touch "a b.txt"  
$ ls  
a b.txt  
$ for file in `ls`; do rm "$file"; done  
rm: cannot remove 'a': No such file or directory  
rm: cannot remove 'b.txt': No such file or directory  
$ for file in *; do rm "$file"; done  
$ ls
```
  
glob используется не только для матчинга filenames, пример:
```bash
$ filename="some.jpg"  
$ if [[ $filename = *.jpg ]]; then  
> echo "true"  
> fi  
true
```
  
## Extended Globs  
По умолчанию могут быть выключены, включаются через: ```$ shopt -s extglob```
  
- **?(list)**: Matches zero or one occurrence of the given patterns.  
- **\*(list)**: Matches zero or more occurrences of the given patterns.  
- **+(list)**: Matches one or more occurrences of the given patterns.  
- **@(list)**: Matches one of the given patterns.  
- **!(list)**: Matches anything but the given patterns.  
  
**list** внутри - список **globs** или **ext globs**, разделенные **|**  

Пример:  
```bash
$ ls  
names.txt tokyo.jpg california.bmp  
$ echo !(*jpg|*bmp)  
names.txt
```  
  
## Regular Expressions  
Похожи на **glob patterns**, но не могут использоваться для **filenames matching**
С версии 3.0 Bash поддерживает оператор ```=~``` для ```[[```  
Этот оператор матчит строку с этим регэкспом и возвращает ``0("true")`` если матч, ``1("false")`` если нет и ``2``, если ошибка

bash использует **Extended Regular Expression** (ERE) диалект  
http://mywiki.wooledge.org/RegularExpression  
  
## Brace Expansion  
По сути это не относится к паттернам, они расширяются ко всевозможным вариантам, это не матчинг, а просто все варианты (прямое произведение)  
```bash
$ echo th{e,a}n  
then than   
$ echo {/home/*,/root}/.*profile  
/home/axxo/.bash_profile /home/lhunath/.profile /root/.bash_profile /root/.profile  
$ echo {1..9} # тут нельзя variables, только константы, умеет в обратную сторону - {9..1}  
1 2 3 4 5 6 7 8 9  
$ echo {0,1}{0..9}  
00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19  
```
Похоже на glob, но возвращает не filenames, а все что может, но происходит до filename expansion,  
второй пример показывает это (комбинацию с glob), где уже находятся реальные файлы, 
получается: ```echo /home/*/.*profile /root/.*profile```  
   
# Exit status/code  
это число от 0 до 255 (0 - успех)  
Для выхода с кодом - команда `exit`  
   
# Control Operators (&& and ||)  
Простейший способ управления последовательностью команд в зависимости от успеха/неуспеха предыдущей  
```bash
$ mkdir d && cd d #выполнится cd, если успешно выполнился mkdir  
$ rm file || { echo 'Could not delete file!' >&2; exit 1; } # >&2 это в стандартный вывод для ошибок   
```
Лучше не перебарщивать с **||** и **&&**  
  
Также лучше группировать:
```bash
$ grep -q goodword "$file" && ! grep -q badword "$file" && { rm "$file" || echo "Couldn't delete: $file" >&2;}
```  
  
Группируем не только для таких простых вещей  
Например следующее:  
```bash
{  
    read firstLine  
    read secondLine  
    while read otherLine; do  
        something  
    done  
} < file
```  
  
Читаем построчно файл  
  
# Условные блоки (if, test, [[)  

```  
if COMMANDS; then  
    OTHER COMMANDS  
fi
``` 
  
Вместо **fi** может быть **elif**, если хотим несколько условий  
  
## Команда test (или [)
  
Более продвинутая аналогичная команда **[[**  

```bash  
$ if [ a = b ]  
> then echo "a is the same as b."  
> else echo "a is not the same as b."  
> fi  
a is not the same as b.
```  
  
В отличии от **[**, команда **[[** поддерживает **pattern matching**: 
```bash
$ [[ $filename = *.png ]] && echo "$filename looks like a PNG file"  
```

Желательно всегда использовать **" "** при работе с **PE**, и только в редких случаях избегать, например тут:  
 ```bash 
$ foo=[a-z]* name=lhunath  
$ [[ $name = $foo ]] && echo "Name $name matches pattern $foo"  
Name lhunath matches pattern [a-z]*  
$ [[ $name = "$foo" ]] || echo "Name $name is not equal to the string $foo"  
Name lhunath is not equal to the string [a-z]*  
```

В этом случае pattern matching работает если правая часть не в кавычках  
  
### Дальше следуют тесты, поддерживаемые [ и [[ 
|   пример                |                         описание                                            |
|-------------------------|-----------------------------------------------------------------------------| 
|**-e FILE**                |True if file exists.|  
|**-f FILE**                |True if file is a regular file.  
|**-d FILE**               |True if file is a directory.  
|**-h FILE**                |True if file is a symbolic link.  
|**-p PIPE**                |True if pipe exists.  
|**-r FILE**                |True if file is readable by you.  
|**-s FILE**                |True if file exists and is not empty.  
|**-t FD**                 |True if FD is opened on a terminal.  
|**-w FILE**                |True if the file is writable by you.  
|**-x FILE**                |True if the file is executable by you.  
|**-O FILE**                |True if the file is effectively owned by you.  
|**-G FILE**                |True if the file is effectively owned by your group.  
|**FILE -nt FILE**        |True if the first file is newer than the second.  
|**FILE -ot FILE**          |True if the first file is older than the second.    
|**-z STRING**             |True if the string is empty (it’s length is zero).  
|**-n STRING**              |True if the string is not empty (it’s length is not zero).  
|**STRING = STRING**        |True if the first string is identical to the second.  
|**STRING != STRING**       |True if the first string is not identical to the second.  
|**STRING < STRING**        |True if the first string sorts before the second.  
|**STRING > STRING**        |True if the first string sorts after the second.   
|**! EXPR**                 |Inverts the result of the expression (logical NOT).  
|**INT -eq INT**            |True if both integers are identical.  
|**INT -ne INT**            |True if the integers are not identical.  
|**INT -lt INT**            |True if the first integer is less than the second.  
|**INT -gt INT**           |True if the first integer is greater than the second.  
|**INT -le INT**            |True if the first integer is less than or equal to the second.  
|**INT -ge INT**            |True if the first integer is greater than or equal to the second.  
  
### Дальше следуют тесты, поддерживаемые только [

|   пример                |                         описание                                            |
|-------------------------|-----------------------------------------------------------------------------| 
|**EXPR -a EXPR**          | True if both expressions are true (logical AND).  |
|**EXPR -o EXPR**          | True if either expression is true (logical OR).  |
  
### Дальше следуют тесты, поддерживаемые только [[

|   пример                |                         описание                                            |
|-------------------------|-----------------------------------------------------------------------------|  
|**STRING = (or ==) PATTERN** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   |   Not string comparison like with [ (or test), but pattern matching is performed.  True if the string matches the glob pattern.  |
| **STRING != PATTERN**        |       Not string comparison like with [ (or test), but pattern matching is performed. True if the string does not match the glob pattern. |  
| **STRING =~ REGEX**          |     True if the string matches the regex pattern. | 
| **( EXPR )**                 |    Parentheses can be used to change the evaluation precedence.  |
| **EXPR && EXPR**            |    Much like the ’-a’ operator of test, but does not evaluate the second expression if the first already turns out to be false.  
| **EXPR \|\| EXPR**           | Much like the ’-o’ operator of test, but does not evaluate the second expression if the first already turns out to be true. |
  
Если пишите скрипт на bash, лучше использовать **[[**  
  
# Conditional Loops (while, until and for)  

**while** command:               Повторяет пока команда успешно завершается (exit code is 0).
  
**until** command:               Повторяет пока команда неуспешно завершается (exit code is not 0).  

**for** variable **in** words:       Цикл по списку  

**for ((** expression; expression; expression **))**: Starts by evaluating the first arithmetic expression; repeats the loop  
so long as the second arithmetic expression is successful; and at the end of each loop evaluates the third arithmetic  
expression.  
  
После каждого идет **do** и в конце **done**  
Есть **break** и **continue**  
  
Примеры:  
```bash
$ while true  
> do echo "Infinite loop"  
> done
``` 
```bash
$ while ! ping -c 1 -W 1 1.1.1.1; do  
> echo "still waiting for 1.1.1.1"  
> sleep 1  
> done
```  
```bash
$ for (( i=10; i > 0; i-- ))  
> do echo "$i empty cans of beer."  
> done
``` 
```bash  
$ for i in {10..1}  
> do echo "$i empty cans of beer."  
> done
``` 
  
# Choices (case and select)  
```bash  
case $LANG in  
    en*) echo 'Hello!' ;;  
    fr*) echo 'Salut!' ;;  
    de*) echo 'Guten Tag!' ;;  
    nl*) echo 'Hallo!' ;;  
    it*) echo 'Ciao!' ;;  
    es*) echo 'Hola!' ;;  
    C|POSIX) echo 'hello world' ;;  
    *) echo 'I do not speak your language.' ;;  
esac
```  
```bash  
case $var in  
    foo|bar|more) ... ;;  
esac
```
  
Работает с **globs**, также есть **select** (помимо case)  
  
# Arrays  
> An **array** is a numbered list of strings: It maps integers to strings  

Пример *нерабочего* кода (проблемы с пробелами):  
```bash
$ files=$(ls ~/*.jpg); cp $files /backups/  
```
Адекватный фикс с массивами:
```bash
$ files=(~/*.jpg); cp "${files[@]}" /backups/  
```
Использование массивов для представления множества строк - самый безопасный способ  
  
## Создание массивов   

Способов несколько, зависит от данных, откуда приходят и т.д.  
  
**Простейший способ**:
```bash
$ names=("Bob" "Peter" "$USER" "Big Bad John")  
```  
**Можно задать индексы явно**:
```bash  
$ names=([0]="Bob" [1]="Peter" [20]="$USER" [21]="Big Bad John")  
# or...  
$ names[0]="Bob"
```
  
В первом варианте есть дыра между индексами 1 и 20, такой массив называется **Sparse Array**  
  
**Также для создания можно использовать Globs**:
```bash 
$ photos=(~/"My Photos"/*.jpg)  
```
Как записать результат команды (например find) в массив? Правильный вариант:  
```bash 
$ files=()                     # объявили пустой массив  
$ while read -r -d ''; do  
$     files+=("$REPLY")        # добавляем элемент в конец массива  
$ done < <(find /foo -print0)  # < <(..) это комбинация File Redirection (<) и Process Substitution (<(..))
```  
  
## Использование массивов 

Сперва напечатаем массив, используя команду ```declare -p```, она печатает содержимое переменных и какой у них тип. 

**Пример**:
```bash
$ a=(1 2 3)  
$ declare -p a  
declare -a a=([0]="1" [1]="2" [2]="3")  
```  
**Напечатаем сами**:  
```bash
$ a=(1 10 100)  
$ for n in "${!a[@]}"; do echo "$n: ${a[n]}"; done  
0: 1  
1: 10  
2: 100  
```
  
**Или цикл не по индексам, а по самим значениям**:
```bash
$ for v in "${a[@]}"; do echo "$v"; done  
1  
10  
100
```  
  
> Важно брать в кавычки (```"${a[@]}" и "${!a[@]}"```), иначе профита от массивов мало. Каждый элемент в таком случае заключается в кавычки, защита от word splitting 
  
*Рассмотрим*:
```bash  
$ myfiles=(db.sql home.tbz2 etc.tbz2)  
$ cp "${myfiles[@]}" /backups/
```  
Последнее трансформируется в:  
```bash
$ cp "db.sql" "home.tbz2" "etc.tbz2" /backups/  
```
  
Также есть форма ```"${arrayname[*]}"```, она конвертирует в строку  
  
**Использование IFS** (чтобы указать разделитель для элементов в массиве):
```bash
$ names=("Bob" "Peter" "Big Bad John")  
$ ( IFS=,; echo "Today's contestants are: ${names[*]}" )  
Today's contestants are: Bob,Peter,Big Bad John  
```  
Взяли в скобки ( IFS=... чтобы создалась subshell и не зааффектила переменную в текущей shell  
  
**Доступ по индексам**: 
Можем производить арифметические вычисления без использования **$**, по умолчанию ariphmetic context  
```bash
$ a=(a b c q w x y z)  
$ for ((i=0; i<${#a[@]}; i+=2)); do  
> echo "${a[i]} and ${a[i+1]}"  
> done 
``` 
  
  
## Associative Arrays  
**2 основных отличия от обычных массивов:**
  
1) порядок ключей не гарантирован (при получении через ```"${!array[@]}"```)  
2) для индекса необходим **$**, [...] не интерпретируется в арифметическом контексте по умолчанию как в обычных массивах, что логично, необязательно индексы числа
  
**Примеры:**  
  
```bash  
$ indexedArray=( "one" "two" )  
$ declare -A associativeArray=( ["foo"]="bar" ["alpha"]="omega" )  
$ index=0 key="foo"  
$ echo "${indexedArray[$index]}"  
one  
$ echo "${indexedArray[index]}"  
one  
$ echo "${indexedArray[index + 1]}"  
two  
$ echo "${associativeArray[$key]}"  
bar  
$ echo "${associativeArray[key]}"  
$ echo "${associativeArray[key + 1]}"  
```

# Input и Output

> **Входные данные** относятся к любой информации, которую ваша программа получает (или читает)

Существуют разные источники:
- **Command-line arguments** (которые размещены в позиционных параметрах)
- **Environment variables** (унаследованные от любого процесса, запускающего скрипт)
- **Files**
- **Все, на что может указывать дескриптор файла** (pipes, terminals, sockets, etc.). This will be discussed below.

> **Вывод** относится к любой информации, которую ваша программа производит (или записывает)

Может направляться в:
- **Files**
- **Все, на что может указывать дескриптор файла**
- **Command-line arguments** к другой программе
- **Environment variables** переданные другой программе

## Command-line Arguments

Выше знакомились с параметрами: **спец параметры** (**\$0**,  **\$\***, **\$@**, **\$\#**, **\$?**, **\$\$**, **\$!**, **\$_**) и **positional parameters** (**\$1**, **\$2**, ...)

Важно не забыть про кавычки и word splitting при работе с параметрами

## The Environment

> Каждая программа наследует определенную информацию, ресурсы, привилегии и ограничения от своего родительского процесса. Одним из таких ресурсов является набор переменных, называемых переменными среды.

В Bash переменные окружения работают очень похоже на обычные переменные оболочки, к которым мы привыкли. Единственная реальная разница, что они уже установлены при запуске скрипта; нам не нужно устанавливать их самим.

Традиционно переменные среды имеют имена, которые являются заглавными буквами, например, ```PATH``` или ```HOME```. Это позволяет избежать конфликтов с локальными переменными в скриптах.

Переменные среды могут быть легко изменены на лету. Например так:
```bash
$ ls /tpm
ls: no se puede acceder a /tpm: No existe el fichero o el directorio
$ LANG=C ls /tpm
ls: cannot access /tpm: No such file or directory
```
Это временное изменение среды, которое вступает в силу только в течение этой команды. ```LANG``` изменится только для данной команды ```ls```.

В сценарии, если вы знаете, что некоторая информация находится в переменной окружения, вы можете просто использовать ее как любую другую переменную:
```bash
$ if [[ $DISPLAY ]]; then
>	xterm -e top
> else
>	top
> fi
```
Запускает ```xterm -e top```, если установлена переменная окружения ```DISPLAY``` (не пустая); в противном случае запускает ```top```.

Если вы хотите поместить информацию в ```environment``` для наследования дочерними процессами, используйте команду ```export```:
```bash
$ export MYVAR=something
```

Изменения среды наследуются только вашими потомками. Вы не можете изменить среду программы, которая уже запущена, или программы, которую вы не запускаете.

## File Descriptors

**File Descriptors** (сокращённо FDs) - это способ, которым программы обращаются к файлам или к другим ресурсам, которые работают как файлы (pipes, devices, sockets, or terminals).

**FDs** - это своего рода указатели на источники данных или места, в которые можно записывать данные. Когда что-то читает или записывает в этот FD, данные считываются или записываются в ресурс этого FD.

По умолчанию каждый новый процесс стартует с тремя открытыми FDs:
- **Standard Input (stdin)**: File Descriptor 0
- **Standard Output (stdout)**: File Descriptor 1
- **Standard Error (stderr)**: File Descriptor 2

Пример работы ```stdin``` и ```stdout```:
```bash
$ read -p "What is your name? " name; echo "Good day, $name. Would you like some tea?"
What is your name? 123
Good day, 123. Would you like some tea?
```

Команда ```read``` читает информацию из  ```stdin``` и сохраняет в переменную. Далее с помощью команды ```echo``` отправляем данные в ```stdout```.

Что с ```stderr```?
```bash
$ rm secrets
rm: cannot remove `secrets': No such file or directory
```

По умолчанию ```stderr``` подключен к устройству вывода вашего терминала, так же как и ```stdout```.

В shell скриптах на FDs всегда ссылаются по числу:
```bash
$ echo "Uh oh. Something went really bad.." >&2
```

## Redirection

Самая основная форма ввода/вывода в ```BASH``` - это **перенаправление**. Перенаправление используется для изменения источника (```source```) данных или назначения (```target```) FD вашей программы. Таким образом, вы можете отправить вывод в файл вместо терминала или прочитать данные из файла, а не с клавиатуры.

Перенаправления выполняются BASH прежде, чем оболочка выполнит команду, к которой перенаправления
применяются.

### File Redirection

Перенаправление файлов включает в себя изменение одного FD для указания на файл.
Начнем с перенаправления вывода:
```bash
$ echo "It was a dark and stormy night. Too dark to write." > story
$ cat story
It was a dark and stormy night. Too dark to write.
```

Оператор **```>```** начинает перенаправление вывода. Перенаправление применяется только к одной команде (в данном случае, к команде ```echo```). Он сообщает BASH, что ```stdout``` должен указывать на файл, а не туда, куда он указывал ранее.
По умолчанию Bash не проверяет, существует ли файл, он просто открывает его и если файл с таким именем уже был, его прежнее содержимое будет потеряно. Если файла не существует, он создается как пустой файл, так что FD можно указать на него.

Другой пример:
```bash
$ cat < story
It was a cold december night. Too cold to write.
```
В прошлом примере с помощью ```cat``` получили идентичный вывод, но тут есть отличия в работе. В первом примере ```cat``` открывал FD к файлу story и читал содержимое через него. Во втором примере ```cat``` читает из ```stdin``` как будто с клавиатуры (с помощью перенаправления подменили ```stdin```).

Операторам перенаправления может предшествовать число. Это число обозначает FD, который будет изменен.

**В итоге**:

- **command > file**: Направляет ```stdout``` команды в файл.
- **command 1> file**: Направляет ```stdout``` команды в файл. Идентично предыдущему, поскольку ```FD 1``` это FD по умолчанию для оператора **```>```**.
- **command < file**: Использует содержимое файла в качестве ```stdin``` для команды.
- **command 0< file**: Идентично предыдущему.

Номер FD для ```stderr``` это 2, рассмотрим пример:
```bash
$ for homedir in /home/*
> do rm "$homedir/secret"
> done 2> errors
```
Мы обходим каждый каталог или файл в ```/home```. Затем пытаемся удалить секретный файл в каждом из них.
В случае если операция удаления не удастся, она отправит данные в ```errors```.

В результате увидим следующее:
```bash
$ cat errors
rm: cannot remove '/home/axxo/secret': No such file or directory
rm: cannot remove '/home/lhunath/secret': No such file or directory
```

Можем заглушить (спрятать) вывод:
```bash
$ for homedir in /home/*
> do rm "$homedir/secret"
> done 2> /dev/null
```
Направили в ```/dev/null``` и скрыли от пользователя ошибки. Когда пишем туда ошибки, они просто исчезают, файл ```/dev/null``` всегда пустой, фактически это не файл а virtual device.

**Важный момент**: если мы не хотим, чтобы файл пересоздавался при использовании **```>```**, тогда надо использовать оператор **```>>```**, он будет дописывать данные в конец файла.

### File Descriptor Manipulation

Рассмотрим пример:
```bash
$ echo "I am a proud sentence." > file
$ grep proud file 'not a file'
file:I am a proud sentence.
grep: not a file: No such file or directory
```

Допустим мы хотим заглушить вывод ```grep```, или просто перенаправить куда-то ```stdout``` и ```stderr```.

**Неправильный код**:
```bash
grep proud file 'not a file' > proud.log 2> proud.log
```
Это не сработает, поскольку мы создали два FD, которые указывают на один файл независимо друг от друга. Один FD может перебить другой и потеряется часть информации, тут всё зависит от реализации FD в операционной системе.

**Правильный код**:
```bash
$ grep proud file 'not a file' > proud.log 2>&1
```
Для понимания надо знать, что мы читаем перенаправления слева-направо, здесь мы сначала перенаправили ```stdout``` в файл ```proud.log```, а затем с помощью оператора **```>&```** создали дубликат `FD 1` и поместили его в `FD 2`.

**Правильный код, другой способ**:
```bash
$ grep proud file 'not a file' &> proud.log
```

## Pipes

```Pipe``` соединяет ```stdout``` одного процесса с ```stdin``` другого, передавая данные из одного процесса в другой. Весь набор команд, который передается по каналу вместе называется ```pipeline```:

```bash
$ echo "rat
> cow
> deer
> bear
> snake" | grep bea
bear
```

**Примечание**: ```Pipe``` оператор создает `subshell environment` для каждой команды. Таким образом любая переменная созданная или измененная в другой команде вне этой команды останется неизменной.

Пример:

```bash
$ message=Test
$ echo 'Salut, le monde!' | read message
$ echo "The message is: $message"
The message is: Test
$ echo 'Salut, le monde!' | { read message; echo "The message is: $message"; }
The message is: Salut, le monde!
$ echo "The message is: $message"
The message is: Test
```

## Process Substitution

Имеет две формы: **```<()```** и **```>()```**.

> Это удобный способ использовать именованные каналы без необходимости создания временных файлов. Всякий раз, когда вы думаете, что вам нужен временный файл, чтобы сделать что-то, ```Process substitution``` может быть лучшим способом.

При ```Process Substitution```  команда в ```()``` просто запускается. 

**Когда используем оператор  **```<()```**** вывод команды помещается в именованный канал (named pipe) или нечто схожее, создаваемое bash. А оператор в нашей команде заменяется на этот файл.

**Представим ситуацию когда мы хотим сравнить вывод двух команд**

Обычный способ:
```bash
$ head -n 1 .dictionary > file1
$ tail -n 1 .dictionary > file2
$ diff -y file1 file2
Aachen                                   | zymurgy
$ rm file1 file2
```

А теперь используя ```Process Substitution```:

```bash
$ diff -y <(head -n 1 .dictionary) <(tail -n 1 .dictionary)
Aachen                                   | zymurgy
```

Часть с **```<(..)```** заменяется временный FIFO, созданным bash, `diff` получает на вход примерно следующее:

```bash
$ diff -y /dev/fd/63 /dev/fd/62
```

**Оператор ```>()```** похож на **```<()```**, но вместо перенаправления вывода команды во временный файл, здесь мы перенаправляем в ```input``` команды. Используется для команд, которые пишут в файл, а мы хотим чтобы они писали в stdin другой команды.

# Compound Commands

```BASH``` предоставляет множество способов комбинировать простые команды. Ранее мы рассматривали такие конструкции как **```if```** statements, **```for```** loops, **```while```** loops, the **```[[```** keyword, **```case```** и **```select```**.

На них не будем останавливаться, рассмотрим остальные: **`subshells`**, **`command grouping`** и **`arithmetic evaluation`**.

## Subshells

Они похожи на дочерние процессы, за исключением того, что наследуется больше информации. Подоболочки создаются неявно для каждой команды в ```pipeline```. Они также создаются явно с помощью скобок вокруг команды:

```bash
$ (cd /tmp || exit 1; date > timestamp)
$ pwd
/home/lhunath
```

Когда завершается `subshell`, изменения команды cd исчезют. Можно думать о `subshell` как о временной оболочке.

## Command grouping

Команды могут быть сгруппированы с помощью фигурных скобок. Такие группы команд представляют собой как бы одну команду, с соответствующими возможностями `pipe` и `redirection` как одной команды. Они похожи на `subshell`, с разницей в том, что выполняются в текущей `shell`. Это быстрее и позволяет например изменять переменные.

**Пример**:
```bash
$ { echo "Starting at $(date)"; rsync -av . /backup; echo "Finishing at $(date)"; } >backup.log 2>&1
```
В данном примере файловый дескриптор `backup.log` открывается лишь один раз и остается открытым пока выполнятся все команды из группы.

**Примечание**: команда `for` - это составная команда, которая ведет себя также как и командная группа. 

Рассмотрим пример:
```bash 
$ echo "cat
> mouse
> dog" > inputfile
$ for var in {a..c}; do read -r "$var"; done < inputfile
$ echo "$b"
mouse
```

Командные группы часто полезны в подобных случаях:
```bash
$ [[ -f $CONFIGFILE ]] || { echo "Config file $CONFIGFILE not found" >&2; exit 1; }
```

Если командная группа является однострочником как в примере выше, то в конце должна идти **;**
В случае нескольких строк в конце может быть перевод строки:

```bash
$ {
>   echo "Starting at $(date)"
>   rsync -av . /backup
>   echo "Finishing at $(date)"
> } > backup.log 2>&1
```

## Arithmetic Evaluation

Существует несколько способов указать, что мы хотим использовать арифметические преобразования вместо строковых.

**Первый способ**: команда **`let`**

```bash
$ unset a; a=4+5
$ echo $a
4+5
$ let a=4+5
$ echo $a
9
```

Можно использовать пробелы, скобки, если заключить в одинарные кавычки:
```bash
$ let a='(5+2)*3'
```

**Второй способ**: сам **`arithmetic evaluation`**

```bash
$ ((a=(5+2)*3))
```
Это эквивалент `let`, но его можно использовать как команду, например в `if`:

```bash
$ if (($a == 21)); then echo 'Blackjack!'; fi
```

Такие операторы, как **==**, **<**,**>** и т. д., производят сравнение. Если "истина" (например, 10> 2 верно в арифметике - но не в строках!), тогда составная команда завершается со статусом 0. Если сравнение ложно, оно завершается со статусом 1.

Примечание: **`((...))`** имеет множество C-like features, например:
```bash
$ ((abs = (a >= 0) ? a : -a))
```

**Третий способ**: **`arithmetic substitution`**
```bash
$ echo "There are $(($rows * $columns)) cells"
```

## Functions

Это блоки команд, очень похожие на обычные скрипты, но они не находятся в отдельных файлах и не приводят к выполнению отдельного процесса. Тем не менее, они принимают аргументы как скрипты - и в отличие от них могут влиять на переменные внутри вашего скрипта, если вы этого хотите.

```bash
$ sum() {
> echo "$1 + $2 = $(($1 + $2))"
> }
$ sum 1 4
1 + 4 = 5
```

Функции могут иметь `local variables`, объявленные с помощью `local` или `declare` keyword. Это позволяет избежать перезаписи важных переменных извне.

## Aliases

На первый взгляд **`aliases`** внешне похожи на функции, но при детальном рассмотрении они ведут себя совершенно иначе:

- **`Aliases`** не работают в скриптах, совсем. Только в интерактивном режиме.
- **`Aliases`** не принимают аргументы.
- **`Aliases`** не могут вызывать себя рекурсивно.
- **`Aliases`** не могут иметь локальных переменных.

**Aliases** - по сути сочетания клавиш (keyboard shortcuts), предназначенные для использования в файлах .bashrc, чтобы сделать вашу жизнь проще. Они обычно выглядят так:

```bash
$ alias ls='ls --color=auto'
```

Bash проверяет первое слово каждой простой команды, чтобы определить, является ли это псевдонимом, и если да, то выполняет простую замену текста.

# Sourcing

> Я пытаюсь написать скрипт, который будет изменять директорию или устанавливать переменную, но когда скрипт завершается все изменения пропадают, я остаюсь в начальной директории и тд..

Тут может помочь **`sourcing`** вместо запуска скрипта как child:

```bash
. ./myscript #runs the commands from the file myscript in this environment
```

Команды запускаются в `current shell`, таким образом могут менять переменные, рабочие директории, открытые FD и т.д.

Вместо **`.`** можно использовать **`source`**, это то же самое.
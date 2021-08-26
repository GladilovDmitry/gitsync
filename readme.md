Синхронизация хранилища 1С с репозиторием git
=============================================

Обсудить [![oscript_library](https://img.shields.io/badge/chat-telegram-blue)](https://t.me/oscript_library)

[![GitHub release](https://img.shields.io/github/release/khorevaa/gitsync.svg)](https://github.com/oscript-library/gitsync/releases)

Оглавление
==========

<!-- TOC insertAnchor:true -->

- [Введение](#введение)
- [Установка](#установка)
  - [Через пакетный менеджер opm](#через-пакетный-менеджер-opm)
  - [Вручную](#вручную)
- [Требования](#требования)
- [Особенности](#особенности)
  - [Отличия от `gitsync` версий 2.x](#отличия-от-gitsync-версий-2x)
  - [Описание функциональности](#описание-функциональности)
- [Использование приложения `gitsync`](#использование-приложения-gitsync)
  - [Подготовка](#подготовка)
    - [Подготовка нового репозитория (локального)](#подготовка-нового-репозитория-локального)
    - [Установка соответствия пользователей](#установка-соответствия-пользователей)
    - [Установка номера начальной версии хранилища 1С для синхронизации](#установка-номера-начальной-версии-хранилища-1с-для-синхронизации)
  - [Синхронизация](#синхронизация)
    - [Справка по использованию команды](#справка-по-использованию-команды)
    - [Глобальные переменные окружения](#глобальные-переменные-окружения)
    - [Переменные окружения команды](#переменные-окружения-команды)
    - [Значения по умолчанию](#значения-по-умолчанию)
    - [Примеры использования](#примеры-использования)
    - [Настройка плагинов синхронизации](#настройка-плагинов-синхронизации)
- [Использование библиотеки `gitsync`](#использование-библиотеки-gitsync)
- [Доработка и разработка плагинов](#доработка-и-разработка-плагинов)
- [Механизм подписок на события](#механизм-подписок-на-события)
- [Сборка проекта](#сборка-проекта)
- [Доработка](#доработка)
- [Лицензия](#лицензия)

<!-- /TOC -->

<a id="markdown-введение" name="введение"></a>
## Введение

Проект *gitsync* представляет собой:

1. Библиотеку `gitsync` (`src/core`) - которая реализует основные классы для синхронизации хранилища 1С с git
2. Приложение `gitsync` (`src/cmd`) - консольное приложение на основе библиотеки [`cli`](https://github/khorevaa/cli)

[Документация и описание публичного API библиотеки](docs/README.md)

<a id="markdown-установка" name="установка"></a>
## Установка

<a id="markdown-через-пакетный-менеджер-opm" name="через-пакетный-менеджер-opm"></a>
### Через пакетный менеджер opm

1. Установить командой `opm install gitsync`

<a id="markdown-вручную" name="вручную"></a>
### Вручную
> Запасной споcоб, например, когда на сервере нет доступа к Интернет
1. Скачать файл `gitsync*.ospx` из раздела [releases](https://github.com/khorevaa/gitsync/releases)
2. Установить командой: `opm install -f <ПутьКФайлу>`

<a id="markdown-Требования" name="Требования"></a>
## Требования

* утилита `ring` и `` - для работы с 1С старше версии > 8.3.11

<a id="markdown-особенности" name="особенности"></a>
## Особенности


<a id="markdown-отличия-от-gitsync-версий-2x" name="отличия-от-gitsync-версий-2x"></a>
### Отличия от `gitsync` версий 2.x

* Полностью другая строка вызова приложения, а именно используется стандарт POSIX.
* Работа с хранилищем конфигурации реализована через библиотеку [`v8storage`](https://github.com/khorevaa/v8storage)
* Реализована поддержка работы с хранилищем по протоколу `http` и `tcp`  
* Функциональность работы через `tool1CD` - перенесена в предустановленный плагин `tool1CD`
* Вместо двух команд `sync` и `export` оставлена только одна команда `sync`, которая работает как команда `export` в предыдущих версиях, при этом функциональность синхронизации с удаленным репозиторием (команды `git pull` и `git push` ) перенесена в отдельный плагин `sync-remote`
* Прекращена поддержка выгрузки конфигурации в исходники в формате `plain`
* Прекращена поддержка использования файла `renames.txt` и переименования длинных файлов
* Расширен функционал за счет использования механизма подписок на события
* Пока не поддерживается синхронизация с несколькими хранилищами одновременно. (команда `all`)

<a id="markdown-описание-функциональности" name="описание-функциональности"></a>
### Описание функциональности

> Раздел документации в разработке

<!-- TODO: Сделать описание функциональности -->

<a id="markdown-использование-приложения-gitsync" name="использование-приложения-gitsync"></a>
## Использование приложения `gitsync`

<a id="markdown-подготовка" name="подготовка"></a>
### Подготовка

<a id="markdown-подготовка-нового-репозитория" name="подготовка-нового-репозитория"></a>
#### Подготовка нового репозитория (локального)

> Данный шаг можно пропустить, если у Вас уже есть локальный репозиторий git

**a. Если у Вас уже есть удаленный репозиторий** (ранее выполнялась синхронизация с сервером git) - используйте команду `clone`

Синтаксис команды: `gitsync clone [ОПЦИИ] PATH URL [WORKDIR]`    

Пример использования:

`gitsync clone --storage-user Администратор --storage-pwd Секрет <путь_к_хранилищу_1С> <адрес_удаленного_репозитория> <рабочий_каталог>(необязательный)`

Команда создаст локальный репозиторий в указанном каталоге путем копирования удаленного.

Справка по команде: `gitsync clone --help`

Больше примеров: `gitsync usage clone`

**b. Если у Вас нет удаленного репозитория** - используйте команду `init`
    
Синтаксис команды: `gitsync init [ОПЦИИ] PATH [WORKDIR]`

Пример использования:

* `gitsync init --storage-user Администратор --storage-pwd Секрет C:/Хранилище_1С/ C:/GIT/src`

    Команда создаст новый репозиторий (каталог) `.git` в каталоге `C:/GIT/src`, и наполнит его служебными файлами `VERSION` и `AUTHORS`.  
    На данном этапе хранилище 1С по пути `C:/Хранилище_1С/` используется для наполнения файла `AUTHORS`. Выгрузка хранилища 1С (синхронизация с репозиторием .git ) не выполняется.

* `gitsync init --storage-user Администратор --storage-pwd Секрет http:/www.storages.1c.com/repository.1ccr/ИмяХранилища C:/GIT/src`

    Вариант для подключения к хранилищу по протоколу `http`

Справка по команде: `gitsync init --help`

Больше примеров: `gitsync usage init`

<a id="markdown-установка-соответствия-пользователей" name="установка-соответствия-пользователей"></a>
#### Установка соответствия пользователей

> Данный шаг можно пропустить, если у Вас уже установлено соответствие пользователей хранилища 1С и git

Для настройки соответствия между пользователями хранилища 1С и git-сервера предназначен файл `AUTHORS`.

Файл заполняется в формате `ini`.

Пример файла:

```ini
Администратор=Пользователь1 <admin-user@mail.com>
Вася Иванов=Другой Пользователь <user-user@mail.com>
```

слева указано имя пользователя хранилища 1С
справа - представление имени пользователя репозитория git и его e-mail

С помощью e-mail выполняется связка пользователя с публичными репозиториями (например, Github или Bitbucket)

<a id="markdown-установка-начальной-версии-из-хранилища-1с-для-синхронизации" name="установка-начальной-версии-из-хранилища-1с-для-синхронизации"></a>
#### Установка номера начальной версии хранилища 1С для синхронизации

> Данный шаг можно пропустить, если у Вас уже установлен номер версии в файле `VERSION`

При выгрузке изменений хранилища 1С в каталог проекта (в рабочий каталог), gitsync ориентируется на номер последней выгруженной версии, указанный в файле `VERSION`.
Номер версии в файле надо указать если Вы не хотите выгружать в git все версии хранилища 1С.

Файл заполняется в формате `xml`.

Пример файла, в котором указано, что выгружено 10 версий:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<VERSION>10</VERSION>
```

Файл можно отредактировать вручную или использовать команду `set-version`.  
Пример использования команды:

`gitsync set-version <номер_версии> <рабочий_каталог>(необязательный)`

Справка по команде: `gitsync set-version --help`

Для удобства использования команда `set-version` имеет короткое название `sv`.

Больше примеров: `gitsync usage set-version`

<a id="markdown-синхронизация" name="синхронизация"></a>
### Синхронизация

Команда `sync` (синоним s) - выполняет синхронизацию хранилища 1С с git-репозиторием

> Подробную справку по опциям и аргументам см. `gitsync sync --help`. Важно: описание опций команды sync при использовании плагина выводится только после активации этого плагина.

<a id="markdown-справка-по-использованию-команды" name="справка-по-использованию-команды"></a>
#### Справка по использованию команды

```
Команда: sync, s
 Выполняет синхронизацию хранилища 1С с git-репозиторием

Строка запуска: gitsync sync [ОПЦИИ] PATH [WORKDIR]

Аргументы:
  PATH          Путь к хранилищу конфигурации 1С. (env $GITSYNC_STORAGE_PATH)
  WORKDIR       Каталог исходников внутри локальной копии git-репозитория. (env $GITSYNC_WORKDIR)

Опции:
  -u, --storage-user    пользователь хранилища конфигурации (env $GITSYNC_STORAGE_USER) (по умолчанию Администратор)
  -p, --storage-pwd     пароль пользователя хранилища конфигурации (env $GITSYNC_STORAGE_PASSWORD, $GITSYNC_STORAGE_PWD)

```

<a id="markdown-глобальные-переменные-окружения" name="глобальные-переменные-окружения"></a>
#### Глобальные переменные окружения
| Имя                 | Описание                                               |
|---------------------|--------------------------------------------------------|
| `GITSYNC_V8VERSION` | маска версии платформы (8.3, 8.3.5, 8.3.6.2299 и т.п.) |
| `GITSYNC_V8_PATH`   | путь к исполняемому файлу платформы 1С (Например, /opt/1C/v8.3/x86_64/1cv8) |
| `GITSYNC_VERBOSE`   | вывод отладочной информации в процессе выполнения      |
| `GITSYNC_TEMP`      | путь к каталогу временных файлов                       |
| `GITSYNC_EMAIL`     | домен почты для пользователей git                      |

<a id="markdown-переменные-окружения-команды" name="переменные-окружения-команды"></a>
#### Переменные окружения команды

| Имя                        | Описание                                   |
|----------------------------|--------------------------------------------|
| `GITSYNC_WORKDIR`          | рабочий каталог для команды                |
| `GITSYNC_STORAGE_PATH`     | путь к хранилищу конфигурации 1С.          |
| `GITSYNC_STORAGE_USER`     | пользователь хранилища конфигурации        |
| `GITSYNC_STORAGE_PASSWORD` | пароль пользователя хранилища конфигурации |

<a id="markdown-значения-по-умолчанию" name="значения-по-умолчанию"></a>
#### Значения по умолчанию

|                    |                              |
|--------------------|------------------------------|
| WORKDIR            | текущая рабочая директория   |
| -u, --storage-user | пользователь `Администратор` |

<a id="markdown-примеры-использования" name="примеры-использования"></a>
#### Примеры использования

* Примитивный вариант

    `gitsync sync C:/Хранилище_1С/ C:/GIT/src`

    Команда выполнит выгрузку версий хранилища 1С из `C:/Хранилище_1С/` в репозиторий git в каталоге `C:/GIT/src`. Пример учебный, на практике обычно требуется указать также имя пользователя хранилища и пароль.

* Вариант вызова команды в текущем рабочем каталоге

    > переменная окружения **`GITSYNC_WORKDIR`** не должна быть задана

    ```sh
    cd C:/work_dir/
    gitsync sync C:/Хранилище_1С/
    ```
    Команда выполнит выгрузку версий хранилища 1С из `C:/Хранилище_1С/` в репозиторий git в каталоге `C:/work_dir`

* Вариант с указанием пользователя хранилища и пароля

    ```sh
    gitsync sync --storage-user Admin --storage-pwd Secret C:/Хранилище_1С/ C:/work_dir/
    ```
    Имя пользователя = Admin, пароль = Secret.
    
* Использование синонимов (короткая версия предыдущего примера)

    ```sh
    gitsync s -u Admin -p Secret C:/Хранилище_1С/ C:/work_dir/
    # возможны варианты
    # gitsync s -uAdmin -pSecret C:/Хранилище_1С/ C:/work_dir/
    # gitsync s -u=Admin -p=Secret C:/Хранилище_1С/ C:/work_dir/
    ```

* Указание исполняемого файла нужной версии платформы

    ```sh
    gitsync --v8-path /opt/1C/v8.3/x86_64/1cv8 s -uAdmin -p=Secret C:/Хранилище_1С/ C:/work_dir/
    ```
    Команда синхронизации будет выполнена с использованием исполняемого файла платформы `/opt/1C/v8.3/x86_64/1cv8` (приведен синтаксис для linux; вариант для Windows см. ниже).

* Вызов команды без указания параметров, с использованием переменных окружения

    linux:
    ```sh
    export GITSYNC_WORKDIR=./work_dir/
    export GITSYNC_STORAGE_PATH=./Хранилище_1С/

    export GITSYNC_STORAGE_USER=Admin
    export GITSYNC_STORAGE_PASSWORD=Secret
    export GITSYNC_V8VERSION=8.3.7
    # Указание конкретного исполняемого файла платформы 1С. Путь надо обернуть в кавычки если он содержит пробелы.
    #export GITSYNC_V8_PATH=/opt/1C/v8.3/x86_64/1cv8
    export GITSYNC_VERBOSE=true #Можно использовать Да/Ложь/Нет/Истина
    export GITSYNC_TEMP=./temp/sync
    gitsync s
    ```
    windows:
    ```cmd
    set GITSYNC_WORKDIR=./work_dir/
    set GITSYNC_STORAGE_PATH=./Хранилище_1С/

    set GITSYNC_STORAGE_USER=Admin
    set GITSYNC_STORAGE_PASSWORD=Secret
    set GITSYNC_V8VERSION=8.3.7
    # Указание конкретного исполняемого файла платформы 1С. Путь надо обернуть в кавычки если он содержит пробелы.
    #set GITSYNC_V8_PATH="C:\Program Files (x86)\1cv8\8.3.12.1567\bin\1cv8.exe"
    set GITSYNC_VERBOSE=true #Можно использовать Да/Ложь/Нет/Истина
    set GITSYNC_TEMP=./temp/sync

    gitsync s
    ```
<a id="markdown-настройка-плагинов-синхронизации" name="настройка-плагинов-синхронизации"></a>

#### Настройка плагинов синхронизации

> Данный пункт можно пропустить, если Вам не требуется дополнительная функциональность синхронизации

Для расширения функциональности синхронизации предлагается механизм *плагинов*.
Данный механизм реализован через подписки на события синхронизации, с возможностью переопределения стандартной обработки.

Для обеспечения управления плагинами реализована подкоманда `plugins`, а так же ряд вложенных команд:

1. `init` - Инициализация предустановленных плагинов (установка из поставляемого пакета)
1. `list` - Вывод списка плагинов
1. `enable` - Активизация установленных плагинов
1. `disable` - Деактивизация установленных плагинов
1. `install` - Установка новых плагинов
1. `clear` - Удаление установленных плагинов
1. `help` - Вывод справки по выбранным плагинам

Пример использования:

* `gitsync plugins enable limit` - будет активирован плагин `limit`
* `gitsync plugins enable -a` - будут активированы все предустановленные плагины
* `gitsync plugins list` - будет выведен список всех *активированных* плагинов
* `gitsync plugins list -a` - будет выведен список всех *установленных* плагинов 

Справка по команде: `gitsync plugins --help`

Для удобства использования команда `plugins` имеет короткое название `p`.

Больше примеров: `gitsync usage plugins`

> Для хранения установленных плагинов и списка активных плагинов используется каталог `локальных данных приложения` - для Windows это C:\Users\UserName\AppData\Local\gitsync\plugins

Список предустановленных плагинов:
> Для инициализации предустановленных плагинов необходимо выполнить команду `gitsync plugins init`. Описание используемых плагинами опций см. в справке к команде sync.

1. `increment` - включает режим инкрементальной выгрузки конфигурации в исходники.  
  Выгружается не вся конфигурация, а только те объекты, версия которых отличается от версии, имеющейся в каталоге. См. [DumpConfigToFiles](https://its.1c.ru/db/v8319doc#bookmark:adm:TI000000493:dumpconfigtofiles), опция update.
2. `sync-remote` -  добавляет опции команды  `sync` для синхронизации с удаленным репозиторием git (команды `git pull` и `git push`)
3. `limit` - позволяет ограничить количество выгружаемых версий за один запуск, а так же указать минимальную и/или максимальную версию хранилища для выгрузки
4. `check-authors` - блокирует выгрузку версии, если автор версии хранилища отсутствует в файле `AUTHORS`
5. `check-comments` - добавляет опции команды  `sync` для проверки наличия комментария у версии хранилища, а также для проверки заполнения комментария
6. `smart-tags` - устанавливает тег равный версии конфигурации при смене версии конфигурации (не путать с версией хранилища). А также добавляет опции команды  `sync` для автоматической установки метки git (команда `git tag`) равной версии хранилища (в формате "v.номер").
7. `unpackForm` - выполняет распаковку обычных форм на исходники. Добавляет опции команды  `sync` для переименования объектов обычных форм.
8. `tool1CD` - заменяет использование штатных механизмов 1С на приложение `tool1CD` при выгрузке
9. `disable-support` - снимает конфигурацию с поддержки перед выгрузкой в исходники
10. `edtExport` - добавляет возможность выгрузки в формате EDT. Для работы плагина необходимо установить EDT.

<a id="markdown-использование-библиотеки-gitsync" name="использование-библиотеки-gitsync"></a>
## Использование библиотеки `gitsync`

> Раздел документации в разработке

<!-- TODO: Сделать описание функциональности -->

<a id="markdown-доработка-и-разработка-плагинов" name="доработка-и-разработка-плагинов"></a>
## Доработка и разработка плагинов

* [Как создать свой плагин](./create-new-plugin.md)
* Доработка предустановленных плагинов производится в отдельном репозитории [gitsync-plugins](https://github.com/khorevaa/gitsync-plugins)

<a id="markdown-механизм-подписок-на-события" name="механизм-подписок-на-события"></a>
## Механизм подписок на события 

> Раздел документации в разработке

Проект `gitsync` поддерживает ряд подписок на события


<!-- TODO: Сделать описание функциональности -->

<a id="markdown-сборка-проекта" name="сборка-проекта"></a>
## Сборка проекта

Сборка производится в 2-х режимах:

1. Сборка обычного пакета (без зависимостей)

    `opm build .`

    В этом варианте в сборку не добавляются предустановленные пакеты. Их надо будет устанавливать отдельно.

2. Сборка пакета с зависимостями

    `opm build -mf ./build_packagedef .`

    В сборку будут добавлены пакеты из репозиториев:

    * `opm` - из ветки develop
    * `gitsync-pre-plugins` - из ветки develop

<a id="markdown-доработка" name="доработка"></a>
## Доработка

Доработка проводится по git-flow. Жду ваших PR.

<a id="markdown-лицензия" name="лицензия"></a>
## Лицензия

Смотри файл [`LICENSE`](./LICENSE).

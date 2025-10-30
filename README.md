🚀 Быстрый запуск Apache Airflow с PostgreSQL (Docker)

📌 Описание

Репозиторий предоставляет готовое решение для быстрого развертывания Apache Airflow с PostgreSQL через Docker и Docker Compose. Идеально подходит для:
- тестирования DAG'ов,
- проверки работы сенсоров и триггеров,
- экспериментов с зависимостями и плагинами и  прочему.
___
✅ Функции

⚡ Быстрый старт: всё готово к запуску в 3 команды.<br>
🐳 Docker + Docker Compose: нет необходимости устанавливать Airflow локально.<br>
🧪 PostgreSQL: встроенный реляционный движок для хранения метаданных.<br>
🛠 Гибкая настройка: можно изменить конфигурации в docker-compose.yml.
____
🚀 Запуск

Если запуск на машине с WIndows, то убедитесь, что у вас установлено приложение Docker.

1. Клонируйте репозиторий:

```
git clone https://github.com/DinoWithPython/personal-airflow-docker.git
cd personal-airflow-docker
```
2. Запустите контейнеры:
```
docker-compose up -d  # в этом случае контейнеры запустятся в фоновом режиме, логи не видны в терминале
или

docker-compose up

# Следующая команда нужна После изменений в Dockerfile или requirements.txt
docker-compose up --build
```
<b>airflow-webserver:</b> Веб-интерфейс Airflow (http://localhost:8080).<br>
<b>airflow-scheduler:</b> Планировщик задач.<br>
<b>postgres:</b> База данных PostgreSQL.

3. Дождитесь инициализации.

Airflow будет доступен по адресу:<br>
http://localhost:8080<br>
Логин/пароль администратора:<br>
 admin/admin

PostgreSQL:
```
Хост: localhost
Порт: 5432
База: airflow
Пользователь: airflow
Пароль: airflow
```
Дополнительные настройки для постгрес не производились, поскольку проект больше предназначен для тестирования airflow и  взаимодейтсвия с базой не подразумевается.
____
```
📁 Структура проекта
├── docker-compose.yml        # Основной файл конфигурации
├── Dockerfile                # Кастомный образ Airflow (если нужна модификация)
├── requirements.txt          # Дополнительные зависимости Python
├── logs                      # Папка, в которой будут записываться логи airflow
├── plugins                   # Папка для плагинов, если нужно
└── dags/                     # Примеры DAG'ов для тестирования
    └── example_dag.py
```
___
🔧 Настройка

<b>Изменение параметров</b>
```
Airflow:
В контейнере airflow-webserver, в разделе command создаётся admin пользователь в docker-compose.yml.
Порт: измените ports в разделе airflow.
```
```
PostgreSQL:
Хост/порт/база: измените переменные в контейнере postgres POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB в docker-compose.yml.
```
<b>Добавление новых DAG'ов</b>

Создайте .py файл в папке dags/.

<i>Пример:</i>
```
python
from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from datetime import datetime

dag = DAG('test_dag', description='Тестовый DAG', start_date=datetime(2023, 1, 1))

task1 = DummyOperator(task_id='task1', dag=dag)
task2 = DummyOperator(task_id='task2', dag=dag)

task1 >> task2
```
Так же в директории уже лежит три файла для теста модуля pendulum и времени по utc.
___
🚫 Остановка
```
docker compose down
или
docker-compose down -v
```
-v удалит также тома данных (если нужно очистить всё).
___
📚 Полезные ссылки<br>
[Официальная документация Airflow](https://airflow.apache.org/docs/)<br>
[Docker Compose Reference](https://docs.docker.com/reference/cli/docker/compose/)<br>
___
📌 Примечания

Инициализация базы данных: При первом запуске контейнер `airflow-webserver` автоматически создает базу данных и пользователя `admin/admin`.

Healthcheck для PostgreSQL: Контейнер `postgres` ожидает, пока база данных станет доступной, перед запуском Airflow.
Монтирование папок: DAG'и и логи хранятся локально (`./dags` и `./logs`).

Дополнительные зависимости: Все пакеты из `requirements.txt` устанавливаются при сборке образа Airflow.

Используется версия `Airflow 2.5.0`, на `PostgreSql 13` и `python 3.9.*`.

В докер-файле так же сразу обновляется `pip`. 

Если решите удалить папку `./logs`, то это может привести к неожиданным последствиям.
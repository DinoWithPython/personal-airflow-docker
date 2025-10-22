# Dockerfile
# Определенная версия airflow и питона. Полезно для разных проектов и разных версия ПО. 
FROM apache/airflow:2.5.0-python3.9

USER root

# Обновление системы и установка необходимых инструментов
RUN apt-get update && \
    apt-get install -y build-essential python-dev libpq-dev && \
    rm -rf /var/lib/apt/lists/* # Очистка списка пакетов

# Возвращаемся к стандартному пользователю Airflow
USER airflow

# Добавляем файл зависимостей в образ, чтобы потом из него произвести установку.
COPY requirements.txt .

# Установка наших дополнительных пакетов и обновление pip
RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Команда запуска (например, webserver)
CMD ["webserver"]
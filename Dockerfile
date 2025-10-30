# Dockerfile
# Определенная версия airflow и питона. Полезно для разных проектов и разных версия ПО. 
FROM apache/airflow:2.5.0-python3.9

# Устанавливаем переменные окружения (лучше задавать через docker-compose.env в проде)
ENV AIRFLOW_HOME=/opt/airflow

# Обновление системы и установка необходимых инструментов
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        python3-dev \
        libpq-dev \
        gcc \
        curl \
        wget \
        ca-certificates \
        tzdata \
    && \
    rm -rf /var/lib/apt/lists/* # Очистка списка пакетов

# Добавляем файл зависимостей в образ, чтобы потом из него произвести установку.
COPY requirements.txt ${AIRFLOW_HOME}/requirements.txt

# Установка наших дополнительных пакетов и обновление pip
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r ${AIRFLOW_HOME}/requirements.txt && \
    # Очищаем кеш pip
    find /opt/airflow/.local -name '*.whl' -delete && \
    find /opt/airflow/.local -name '*.dist-info' -delete

# Создаём директории для DAGs/logs/plugins (если нужны)
RUN mkdir -p ${AIRFLOW_HOME}/{dags,logs,plugins}

# Возвращаемся к стандартному пользователю Airflow
USER airflow

# Рабочий каталог
WORKDIR ${AIRFLOW_HOME}

# Команда запуска (например, webserver)
CMD ["webserver"]
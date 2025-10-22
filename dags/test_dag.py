from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import timedelta, datetime

# Дата на 1 день назад, чтобы DAG запустился сразу
start_date = datetime.now() - timedelta(days=1)

default_args = {
    'owner': 'airflow',
    'start_date': start_date,  # ✅ Вчера - запустится сразу
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id='simple',
    default_args=default_args,
    schedule_interval='35 14 * * *',
    catchup=False,
    tags=['example']
) as dag:
    
    print_message_task = BashOperator(
        task_id='print_message',
        bash_command='echo "Hello from simple_test!"',
    )
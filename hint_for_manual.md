### 1. Установка PostgreSQL 15 и настройка базы данных и пользователя

#### Установка PostgreSQL 15

1. **Добавление репозитория PostgreSQL:**

   ```bash
   sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
   wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
   sudo apt-get update
   ```

2. **Установка PostgreSQL 15:**

   ```bash
   sudo apt-get install postgresql-15
   ```

#### Создание базы данных и пользователя

1. **Подключение к PostgreSQL и создание пользователя и базы данных:**

   ```bash
   sudo -u postgres psql
   CREATE USER airflow WITH PASSWORD '1234';
   CREATE DATABASE airflow OWNER airflow;
   GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow;
   \q
   ```

2. **Настройка PostgreSQL для удаленного доступа:**

   ```bash
   sudo nano /etc/postgresql/15/main/postgresql.conf
   ```

   Изменить строку:

   ```conf
   listen_addresses = '*'
   ```

   Затем отредактировать файл:

   ```bash
   sudo nano /etc/postgresql/15/main/pg_hba.conf
   ```

   Добавить строку:

   ```conf
   host    all             all             <IP_air01>/32               md5
   ```

   Перезапустить PostgreSQL:

   ```bash
   sudo systemctl restart postgresql
   ```

### 2. Установка и настройка PG-Strom

1. **Установка необходимых зависимостей:**

   ```bash
   sudo apt-get install build-essential git postgresql-server-dev-15
   ```

2. **Установка heterodb-extra:**

   ```bash
   wget https://heterodb.github.io/swdc/deb/heterodb-extra_5.4-1_amd64.deb
   sudo dpkg -i heterodb-extra_5.4-1_amd64.deb
   ```

3. **Сборка и установка PG-Strom:**

   ```bash
   git clone https://github.com/heterodb/pg-strom.git
   cd pg-strom/src
   make PG_CONFIG=/usr/lib/postgresql/15/bin/pg_config -j 8
   sudo make PG_CONFIG=/usr/lib/postgresql/15/bin/pg_config install
   ```

4. **Настройка PostgreSQL для загрузки PG-Strom:**

   Отредактировать файл `/etc/postgresql/15/main/postgresql.conf` и добавить `pg_strom` в `shared_preload_libraries`:

   ```conf
   shared_preload_libraries = 'pg_strom'
   ```

   Перезапустить PostgreSQL:

   ```bash
   sudo systemctl restart postgresql
   ```

### 3. Установка и настройка Apache Airflow

1. **Установка необходимых зависимостей на сервере Airflow:**

   ```bash
   sudo apt-get update
   sudo apt-get install build-essential python3-pip python3-venv
   ```

2. **Установка Airflow и необходимых пакетов:**

   ```bash
   python3 -m pip install --upgrade pip
   pip install wheel
   pip install psycopg2-binary
   pip install apache-airflow
   pip install apache-airflow-providers-postgres
   ```

3. **Инициализация Airflow:**

   ```bash
   airflow db init
   ```

4. **Настройка подключения к PostgreSQL:**

   Отредактировать файл `airflow.cfg` (обычно находится в `~/airflow/`):

   ```ini
   [database]
   sql_alchemy_conn = postgresql+psycopg2://airflow:1234@<IP_db01>/airflow
   ```

5. **Создание пользователя Airflow:**

   ```bash
   airflow users create --username admin --firstname Admin --lastname User --role Admin --email admin@example.com
   ```

6. **Запуск Airflow:**

   ```bash
   airflow webserver --port 8080 &
   airflow scheduler &
   ```

7. **Добавление подключения к PostgreSQL в Airflow:**

   ```bash
   airflow connections add postgres --conn-type postgres --conn-host <IP_db01> --conn-schema airflow --conn-login airflow --conn-password 1234 --conn-port 5432
   ```

### 4. Развертывание тестового DAG в Airflow

1. **Создание DAG для проверки PG-Strom и доступности базы данных:**

   ```python
   from airflow import DAG
   from airflow.providers.postgres.operators.postgres import PostgresOperator
   from airflow.utils.dates import days_ago
   from datetime import timedelta

   default_args = {
       'owner': 'airflow',
       'depends_on_past': False,
       'email_on_failure': False,
       'email_on_retry': False,
       'retries': 1,
       'retry_delay': timedelta(minutes=5),
   }

   dag = DAG(
       'pg_strom_check_dag',
       default_args=default_args,
       description='DAG to check pg_strom installation and database availability',
       schedule_interval=timedelta(days=1),
       start_date=days_ago(1),
       catchup=False,
   )

   check_pg_strom_query = """
   SELECT extname
   FROM pg_extension
   WHERE extname = 'pg_strom';
   """

   check_db_query = """
   SELECT 1;
   """

   check_pg_strom = PostgresOperator(
       task_id='check_pg_strom',
       postgres_conn_id='postgres',
       sql=check_pg_strom_query,
       dag=dag,
   )

   check_db = PostgresOperator(
       task_id='check_db',
       postgres_conn_id='postgres',
       sql=check_db_query,
       dag=dag,
   )

   check_db >> check_pg_strom
   ```

2. **Проверка DAG:**

   Перейти в веб-интерфейс Airflow ( `http://your_server:8080`) и убедиться, что DAG `pg_strom_check_dag` появился и работает.
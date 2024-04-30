import psycopg2
from psycopg2 import sql
import csv

# Import necessary data from 'config.py' to connect to our database
from config import name, user, password, host, port
from config import pizza_types_path, pizzas_path, orders_path, order_details_path

# Let's write a function to get data from csv files and insert in a DB
def load_from_csv(csv_filename, table_name, conn):
    try:
        cursor = conn.cursor()
        with open(csv_filename, 'r', newline='', encoding='utf-8') as csvfile:
            csvreader = csv.reader(csvfile)
            next(csvreader)
            for row in csvreader:
                insert_query = sql.SQL('INSERT INTO {} VALUES (%s)').format(sql.Identifier(table_name))
                cursor.execute(insert_query, row)
            conn.commit()
        print(f'Data from {csv_filename} loaded into {table_name} successfully!')
    except Exception as e:
        print(f'Error loading data from {csv_filename} into {table_name}: {e}')
        conn.rollback()

if __name__ == "__main__":
    try:
        conn = psycopg2.connect(
            dbname=name,
            user=user,
            password=password,
            host=host,
            port=port
        )

        load_from_csv(pizzas_path, 'pizzas', conn)
        load_from_csv(pizza_types_path, 'pizza_types', conn)
        load_from_csv(orders_path, 'orders', conn)
        load_from_csv(order_details_path, 'order_details', conn)

        conn.close()
    except Exception as e:
        print(f'Error: {e}')

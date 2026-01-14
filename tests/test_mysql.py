import mysql.connector

def test_mysql():
    try:
        print('Connecting to MySQL...')
        connection = mysql.connector.connect(
            host='localhost',
            user='user',
            password='password',
            database='simulated_db',
            port=3306
        )

        if connection.is_connected():
            print('Connected to MySQL database')
            cursor = connection.cursor(dictionary=True)
            
            print('\nFetching users from ''users'' table:')
            cursor.execute('SELECT * FROM users')
            rows = cursor.fetchall()
            
            for row in rows:
                print(row)
                
            cursor.close()
            connection.close()
            print('\nMySQL Test Passed!')
            
    except Exception as e:
        print(f'Error connecting to MySQL: {e}')

if __name__ == '__main__':
    test_mysql()


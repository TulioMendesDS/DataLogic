from pymongo import MongoClient
import mysql.connector

#Função de conexão com mongoDB. Criação do client,da DataBase e da Collection.
def conectar_mongodb():
    connection_string = "mongodb://root:rootpw@localhost:27017/?authSource=admin"
    client = MongoClient(connection_string)
    db_connection = client["DB_AirBnb"]
    collection = db_connection.get_collection("Collection_AirBnb")
    return collection

def importar_desnormalizar_mysql():
    # Valores com as configurações necesssárias de conexão com o MySQL
    config_mysql = {
        'user': 'root',
        'password': 'root',
        'host': 'localhost',
        'port': 3306,
        'database': 'datalogic'
    }

    # Estabelecer conexão
    
    connection_mysql = mysql.connector.connect(**config_mysql)
    cursor_mysql = connection_mysql.cursor()

    # Query para selecionar os dados já normalizados do modelo relacional
    query = """
        SELECT rental_ad_id, name, room_type, host_id, host_name, neighbourhood, neighbourhood_group, price, minimum_nights, calculated_host_listings_count, availability_365, latitude, longitude, number_of_reviews, last_review, reviews_per_month
        FROM rental_ad
        JOIN host ON fk_host_id = host_id
        JOIN address ON fk_rental_ad_id = rental_ad_id
        JOIN description ON description.fk_rental_ad_id = rental_ad.rental_ad_id
        JOIN geolocation ON geolocation.fk_rental_ad_id = rental_ad.rental_ad_id
        JOIN review ON review.fk_rental_ad_id = rental_ad.rental_ad_id;
    """

    # Executar a query no MySQL e 
    cursor_mysql.execute(query)

    # Coleção para armazenar os dados de variedades do airbnb
    # Conxão feita antes do looping
    collection_criada_airbnb = conectar_mongodb()

    # Loop através das linhas retornadas pelo cursor da query do MySQL
    for row in cursor_mysql.fetchall():
        
        # Convertendo o valor da coluna "last_review" de DATE para string formatada
        def date_string(): 
            if row[14] is not None:
                return row[14].strftime('%Y-%m-%d')
            else:
                return row[14]

        # Criando documento para inserção no MongoDB.
        # Em cada repetição, os é assumido os valores da nova linha
        documento = {
            "rental_ad_id":row[0],
            "name":row[1],
            "room_type":row[2],
            "host_id":row[3],
            "host_name":row[4],
            "neighbourhood":row[5],
            "neighbourhood_group":row[6],
            "price":row[7],
            "minimum_nights":row[8],
            "calculated_host_listings_count":row[9],
            "availability_365":row[10],
            "latitude":row[11],
            "longitude":row[12],
            "number_of_reviews":row[13],
            "last_review":date_string(),
            "reviews_per_month":row[15]
        }
        
        # Já conectado ao banco, em cada repetição será inserindo o documento na coleção
        collection_criada_airbnb.insert_one(documento)

    # Fechar conexão com o MySQL
    cursor_mysql.close()
    connection_mysql.close()

# Conectar ao MongoDB
#db = conectar_mongodb()

importar_desnormalizar_mysql()



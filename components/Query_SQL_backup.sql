# Sequência das ações:
# 1ªETAPA[(Airbnb.csv)Keagle] --> 
# 2ªETAPA[(*Stage* --> Mod. Log. e Relacional )MYSQL] --> 
# 3ªETAPA[(Collection_airbnb)Servidor_MONGO_DB] 

# NESTE PONTO, ESTAMOS NA ETAPA CHAMADA "STAGE", QUE PERMITIRÁ A CONSTRULÇÃO DO "MOD. LOG. E RELACIONAL"

show tables;

#Para Montagem do "DICIONARIO DE DADOS" com Nome Coluna, Tipo Dado, Nullable, Descrição do Campo(Este tem no Keaggle)
describe airbnb_stage;

#Imprimindo a tebela
select * from airbnb_stage;

#total de dados em nosso banco:
select count(*)from airbnb_stage;

################################### N U L O S ###############################################

#CONTAGEM DE NULO POR ATRIBUTO: (name, host_name,last_review, reviews_per_month - Possuem nulos!)
SELECT COUNT(*) FROM airbnb_stage WHERE id IS NULL;
SELECT COUNT(*) FROM airbnb_stage WHERE name IS NULL; 				   #tem 16 nulos!
SELECT COUNT(*) FROM airbnb_stage WHERE host_id IS NULL;
SELECT COUNT(*) FROM airbnb_stage WHERE host_name IS NULL;             #tem 21 nulos!
SELECT COUNT(*) FROM airbnb_stage WHERE neighbourhood IS NULL;
SELECT COUNT(*) FROM airbnb_stage WHERE neighbourhood_group IS NULL;
SELECT COUNT(*) FROM airbnb_stage WHERE latitude IS NULL;
SELECT COUNT(*) FROM airbnb_stage WHERE longitude IS NULL;
SELECT COUNT(*) FROM airbnb_stage WHERE room_type IS NULL;
SELECT COUNT(*) FROM airbnb_stage WHERE price IS NULL;
SELECT COUNT(*) FROM airbnb_stage WHERE minimum_nights IS NULL;
SELECT COUNT(*) FROM airbnb_stage WHERE number_of_reviews IS NULL;
SELECT COUNT(*) FROM airbnb_stage WHERE last_review IS NULL;             #TEM 10052 NULOS!!
SELECT COUNT(*) FROM airbnb_stage WHERE reviews_per_month IS NULL;       #TEM 10052 NULOS!!
SELECT COUNT(*) FROM airbnb_stage WHERE calculated_host_listings_count IS NULL;
SELECT COUNT(*) FROM airbnb_stage WHERE availability_365 IS NULL;


#Puxar as linhas COMPLETAS com todas as colunas onde o atributo X foi apresentado como nulo:
SELECT * FROM airbnb_stage WHERE name IS NULL;                    #TEM 16 NULOS!
SELECT * FROM airbnb_stage WHERE host_name IS NULL; 			  #TEM 21 NULOS!
SELECT * FROM airbnb_stage WHERE last_review IS NULL;             #TEM 10052 NULOS!!
SELECT * FROM airbnb_stage WHERE reviews_per_month IS NULL;       #TEM 10052 NULOS!!

################## F I M    D O S   N U L O S ########################################################################################

###################  M A X I M O    D E    C A R A C T E R E S   ###############################################
# Além de saber as colunas que contém valores nulo para saber que NAO é "NOTNULL", pode-se
# levantar o número máximo de caracteres em campos VARCHAR

# Poderia ser o "AVG" no lugar de "MAX", a depender da situação.

SELECT MAX(LENGTH(name)) AS numero_de_caracteres_Nome
FROM airbnb_stage;
SELECT MAX(LENGTH(host_name)) AS numero_de_caracteres_Bairro
FROM airbnb_stage;
SELECT MAX(LENGTH(neighbourhood)) AS numero_de_caracteres_Bairro
FROM airbnb_stage;
SELECT MAX(LENGTH(neighbourhood_group)) AS numero_de_caracteres_Bairro
FROM airbnb_stage;
SELECT MAX(LENGTH(rlocalizacao_geolocalizacao_geooom_type)) AS numero_de_caracteres_Bairro
FROM airbnb_stage;

################################### F I M    D E    M A X I M O    D E    C A R A C T E R E S  ######################################

###################################  C R I A Ç Ã O    D A S     T A B E L A S  ###############################################

#-------------> TABELA "host" <----------------#
CREATE TABLE IF NOT EXISTS `datalogic`.`host` (
  `host_id` INT NOT NULL,
  `host_name` VARCHAR(42) NULL,
  PRIMARY KEY (`host_id`))
DEFAULT CHARACTER SET = utf8mb4;

#-------------> TABELA "rental_ad" <----------------#

CREATE TABLE IF NOT EXISTS `rental_ad` (
  `rental_ad_id` INT NOT NULL,
  `name` VARCHAR(215),
  `room_type` VARCHAR(18) NOT NULL,
  `fk_host_id` INT NOT NULL,
  PRIMARY KEY (`rental_ad_id`),
  CONSTRAINT `fk_host_rental_ad`
    FOREIGN KEY (`fk_host_id`)
    REFERENCES `host` (`host_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
DEFAULT CHARACTER SET = utf8mb4;

#-------------> TABELA "address" <----------------#

CREATE TABLE IF NOT EXISTS `datalogic`.`address` (
  `address_id` INT NOT NULL AUTO_INCREMENT,
  `neighbourhood_group` VARCHAR(16) NOT NULL,
  `neighbourhood` VARCHAR(31) NOT NULL,
  `fk_rental_ad_id` INT NOT NULL,
  PRIMARY KEY (`address_id`),
  CONSTRAINT `fk_rental_ad_address`
    FOREIGN KEY (`fk_rental_ad_id`)
    REFERENCES `datalogic`.`rental_ad` (`rental_ad_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
DEFAULT CHARACTER SET = utf8mb4;

#-------------> TABELA "review" <----------------#

CREATE TABLE IF NOT EXISTS `datalogic`.`review` (
  `reviews_id` INT NOT NULL AUTO_INCREMENT,
  `number_of_reviews` INT NOT NULL,
  `last_review` DATE NULL,
  `reviews_per_month` FLOAT NULL,
  `fk_rental_ad_id` INT NOT NULL,
  PRIMARY KEY (`reviews_id`),
  CONSTRAINT `fk_rental_review`
    FOREIGN KEY (`fk_rental_ad_id`)
    REFERENCES `datalogic`.`rental_ad` (`rental_ad_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
DEFAULT CHARACTER SET = utf8mb4; 


#-------------> TABELA "description" <----------------#

CREATE TABLE IF NOT EXISTS `datalogic`.`description` (
  `description_id` INT NOT NULL AUTO_INCREMENT,
  `price` FLOAT NOT NULL,
  `minimum_nights` INT NOT NULL,
  `calculated_host_listings_count` INT NOT NULL,
  `availability_365` INT NOT NULL,
  `fk_rental_ad_id` INT NOT NULL,
  PRIMARY KEY (`description_id`),
  CONSTRAINT `fk_rental_ad_description`
    FOREIGN KEY (`fk_rental_ad_id`)
    REFERENCES `datalogic`.`rental_ad` (`rental_ad_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
DEFAULT CHARACTER SET = utf8mb4;
#-------------> TABELA "geolocation" <----------------#

CREATE TABLE IF NOT EXISTS `datalogic`.`geolocation` (
  `geolocation_id` INT NOT NULL AUTO_INCREMENT,
  `latitude` FLOAT NOT NULL,
  `longitude` FLOAT NOT NULL,
  `fk_rental_ad_id` INT NOT NULL,
  PRIMARY KEY (`geolocation_id`),
  CONSTRAINT `fk_rental_ad_geolocation`
    FOREIGN KEY (`fk_rental_ad_id`)
    REFERENCES `datalogic`.`rental_ad` (`rental_ad_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
DEFAULT CHARACTER SET = utf8mb4;

################################### F I M    D A S    C R I A Ç Õ E S ###############################################




###################################  I N S E R Ç Ã O    DA   N O R M A L I Z A Ç Ã O  ###############################################
#-------------> TABELA "host" <----------------#

#Relizando a inserção dos dados da tabela airbnb_stage para a tabela "host"

INSERT INTO host (host_id, host_name)
SELECT DISTINCT host_id, host_name
FROM airbnb_stage;

#Output da inserção
select * from host;

# conferindo quantos nomes se repetem
SELECT host_name, COUNT(host_name) AS repeticoes
FROM host
GROUP BY host_name;

# Confirmando que os nomes repetidos sao pessoas com id únicos
SELECT host_id, COUNT(host_id) AS repeticoes
FROM host
GROUP BY host_id
HAVING  COUNT(host_id) <> 1;

#-------------> TABELA "rental_ad" <----------------#

#Relizando a inserção dos dados da tabela airbnb_stage para a tabela "rental_ad"

INSERT INTO rental_ad (rental_ad_id, name, fk_host_id,room_type)
SELECT id, name, host_id, room_type
FROM airbnb_stage;

# Output da inserção
select * from rental_ad;

#Confirmando número total de linhas inseridas
select count(*) from rental_ad;

#Realizando teste de SELECT entre duas tabelas relacionadas.
SELECT rental_ad_id, name, room_type, fk_host_id, host_id, host_name
FROM rental_ad
JOIN host ON fk_host_id = host_id;

#-------------> TABELA "address" <----------------#

#Relizando a inserção dos dados da tabela airbnb_stage para a tabela "address"

INSERT INTO address (neighbourhood, neighbourhood_group, fk_rental_ad_id)
SELECT neighbourhood, neighbourhood_group, id
FROM airbnb_stage;

# Output da inserção
select * from address;

#Confirmando número total de linhas inseridas
select count(*) from address;

#Realizando teste de SELECT entre duas tabelas relacionadas.
SELECT rental_ad_id, name, room_type, fk_host_id, host_id, host_name, neighbourhood, neighbourhood_group
FROM rental_ad
JOIN host ON fk_host_id = host_id
JOIN address ON fk_rental_ad_id = rental_ad_id;

#VERIFICAR COM PROFESSOR JUSTIFICATIVA PARA RESULTADO DESTE SELECT
#SELECT rental_ad_id, name, room_type, fk_host_id, host_id, host_name, neighbourhood, neighbourhood_group
#FROM host
#JOIN rental_ad ON fk_host_id = rental_ad_id
#JOIN address ON fk_rental_ad_id = rental_ad_id;

#-------------> TABELA "description" <----------------#

#Relizando a inserção dos dados da tabela airbnb_stage para a tabela "description"

INSERT INTO description (price, minimum_nights, calculated_host_listings_count, availability_365, fk_rental_ad_id)
SELECT price, minimum_nights, calculated_host_listings_count, availability_365, id
FROM airbnb_stage;

# Output da inserção
select * from description;

#Confirmando número total de linhas inseridas
select count(*) from description;

#Realizando teste de SELECT entre duas tabelas relacionadas.
SELECT rental_ad_id, name, room_type, fk_host_id, host_id, host_name, neighbourhood, neighbourhood_group, price, minimum_nights, calculated_host_listings_count, availability_365
FROM rental_ad
JOIN host ON fk_host_id = host_id
JOIN address ON fk_rental_ad_id = rental_ad_id
JOIN description ON description.fk_rental_ad_id = rental_ad.rental_ad_id;

#-------------> TABELA "geolocation" <----------------#

#Relizando a inserção dos dados da tabela airbnb_stage para a tabela "geolocation"

INSERT INTO geolocation (latitude, longitude, fk_rental_ad_id)
SELECT latitude, longitude, id
FROM airbnb_stage;

# Output da inserção
select * from geolocation;

#Confirmando número total de linhas inseridas
select count(*) from geolocation;

#Realizando teste de SELECT entre duas tabelas relacionadas.
SELECT rental_ad_id, name, room_type, fk_host_id, host_id, host_name, neighbourhood, neighbourhood_group, price, minimum_nights, calculated_host_listings_count, availability_365, longitude, latitude
FROM rental_ad
JOIN host ON fk_host_id = host_id
JOIN address ON fk_rental_ad_id = rental_ad_id
JOIN description ON description.fk_rental_ad_id = rental_ad.rental_ad_id
JOIN geolocation ON geolocation.fk_rental_ad_id = rental_ad.rental_ad_id;

#-------------> TABELA "review" <----------------#

#Relizando a inserção dos dados da tabela airbnb_stage para a tabela "review"

INSERT INTO review ( number_of_reviews, last_review, reviews_per_month, fk_rental_ad_id)
SELECT  number_of_reviews, last_review, reviews_per_month, id
FROM airbnb_stage;

# Output da inserção
select * from review;

#Confirmando número total de linhas inseridas
select count(*) from review;

#Realizando teste de SELECT entre duas tabelas relacionadas.
SELECT rental_ad_id, name, room_type, host_id, host_name, neighbourhood, neighbourhood_group, price, minimum_nights, calculated_host_listings_count, availability_365, latitude, longitude, number_of_reviews, last_review, reviews_per_month
FROM rental_ad
JOIN host ON fk_host_id = host_id
JOIN address ON fk_rental_ad_id = rental_ad_id 
JOIN description ON description.fk_rental_ad_id = rental_ad.rental_ad_id
JOIN geolocation ON geolocation.fk_rental_ad_id = rental_ad.rental_ad_id
JOIN review ON review.fk_rental_ad_id = rental_ad.rental_ad_id;

################################### F I M     D A    N O R M A L I Z A Ç Ã O ###############################################





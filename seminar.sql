CREATE DATABASE seminar5;
USE seminar5;

CREATE TABLE Cars (
id INT AUTO_INCREMENT PRIMARY KEY,
name_auto VARCHAR(40) NULL,
cost INT NULL);

INSERT INTO Cars (name_auto, cost)
VALUES
('Audi', 52642),
('Mercedes', 57127),
('Skoda', 9000),
('Volvo', 29000),
('Bentley', 350000),
('Citroen', 21000),
('Hummer', 41400),
('Maserati Ghibli III', 35000),
('Aston Martin DBS III', 300000),
('Volkswagen', 21600);

# 1. Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов 
# CREATE VIEW CheapCars AS SELECT Name FROM Cars WHERE Cost<25000;

CREATE VIEW Cars1 AS
SELECT * FROM Cars
WHERE cost < 25000;

# 2. Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 
# долларов (используя оператор ALTER VIEW) ALTER VIEW CheapCars AS SELECT Name FROM CarsWHERE Cost<30000;

ALTER VIEW Cars1 AS
SELECT * FROM Cars
WHERE cost < 30000;

# 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди” 
# (аналогично) Вывести название и цену для всех анализов, которые продавались 5 февраля 2020 
# и всю следующую неделю. Есть таблица анализов Analysis: an_id — ID анализа; 
# an_name — название анализа; an_cost — себестоимость анализа; an_price — розничная цена анализа; 
# an_group — группа анализов. Есть таблица групп анализов Groups: gr_id — ID группы; 
# gr_name — название группы; gr_temp — температурный режим хранения. 
# Есть таблица заказов Orders: ord_id — ID заказа; ord_datetime — дата и время заказа; 
# ord_an — ID анализа.

CREATE OR REPLACE VIEW Cars1 AS
SELECT * FROM Cars
WHERE name_auto IN ('Skoda', 'Audi');

CREATE TABLE IF NOT EXISTS Groupses(
	gr_id INT AUTO_INCREMENT PRIMARY KEY,
    gr_name VARCHAR(90) NOT NULL,
    gr_temp FLOAT);
    
CREATE TABLE IF NOT EXISTS Analysis (
	an_id INT AUTO_INCREMENT PRIMARY KEY,
    an_name VARCHAR(90) NOT NULL,
    an_cost DECIMAL (20,2),
    an_price DECIMAL (20,2) CHECK (an_price > 0),
    an_group INT,
    FOREIGN KEY (an_group) REFERENCES Groupses(gr_id) ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS Orders(
	ord_id INT AUTO_INCREMENT PRIMARY KEY,
    ord_datetime TIMESTAMP,
    ord_an INT,
    FOREIGN KEY (ord_an) REFERENCES Analysis(an_id) ON DELETE CASCADE);


INSERT INTO Groupses (gr_name, gr_temp) VALUES
('Группа анализов №1', -18.5),
('Группа анализов №2', -15),
('Группа анализов №3', -1.5);

INSERT INTO Analysis (an_name, an_cost, an_price, an_group) VALUES
('Анализ №1', 1000.00, 3300.00, 1),
('Анализ №2', 3000.00, 6000.00, 1),
('Анализ №3', 1500.00, 4500.00, 2),
('Анализ №4', 1500.00, 4000.00, 3),
('Анализ №5', 5000.00, 13000.00, 3);

INSERT INTO Orders (ord_datetime, ord_an) VALUES
('2020-01-30 09:00:00', 1),
('2020-02-06 14:00:00', 2),
('2020-02-06 13:30:00', 3),
('2020-02-07 15:30:00', 4),
('2020-02-09 12:00:00', 5),
('2020-02-05 14:30:00', 3),
('2020-02-08 12:30:00', 2),
('2020-02-14 11:00:00', 1);

WITH date_ord AS
(SELECT * FROM Orders
WHERE ord_datetime REGEXP '2020-02-([0][5-9]|[1][0-2])')
SELECT an_name 'Название анализа', an_price 'Стоимость анализа', ord_datetime 'Дата проведения'
FROM Analysis
JOIN date_ord
ON an_id = ord_an
ORDER BY ord_datetime;

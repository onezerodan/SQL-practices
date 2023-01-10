USE master
GO

IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'KN303_Pechurin'
)
ALTER DATABASE [KN303_Pechurin] set single_user with rollback immediate
GO

IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'KN303_Pechurin'
)
DROP DATABASE [KN303_Pechurin]
GO

DROP Function IF EXISTS checkIfRegionExist


CREATE DATABASE [KN303_Pechurin]
GO


USE [KN303_Pechurin]
GO


IF EXISTS(
  SELECT *
    FROM sys.schemas
   WHERE name = N'Pechurin'
) 
 DROP SCHEMA Pechurin
GO

CREATE SCHEMA Pechurin 
GO

CREATE TABLE [KN303_Pechurin].Pechurin.Authors
(
	Code_author INTEGER NOT NULL,
	Name_author NVARCHAR(30) NOT NULL,
    Birthday Date NOT NULL,
	CONSTRAINT PK_Code_author PRIMARY KEY (Code_author) 
)
GO

CREATE TABLE [KN303_Pechurin].Pechurin.Publishing_house
(
    Code_publish INTEGER NOT NULL,
    Publish NVARCHAR(20) NOT NULL,
    City NVARCHAR(20) NOT NULL,

    CONSTRAINT PK_Code_publish PRIMARY KEY (Code_publish) 
)
GO

CREATE TABLE [KN303_Pechurin].Pechurin.Books
(
    Code_book INTEGER NOT NULL,
    Title_book NVARCHAR(20) NOT NULL,
    Code_author INTEGER NOT NULL,
    Pages INTEGER NOT NULL,
    Code_publish INTEGER NOT NULL,

    CONSTRAINT PK_Code_book PRIMARY KEY (Code_book),

    CONSTRAINT FK_Code_author FOREIGN KEY (Code_author) 
	REFERENCES [KN303_Pechurin].Pechurin.Authors(Code_author) ON DELETE CASCADE,

    CONSTRAINT FK_Code_publish FOREIGN KEY (Code_publish) 
	REFERENCES [KN303_Pechurin].Pechurin.Publishing_house(Code_publish)
)
GO

CREATE TABLE [KN303_Pechurin].Pechurin.Deliveries
(
    Code_delivery INTEGER NOT NULL,
    Name_delivery NVARCHAR(30) NOT NULL,
    Name_Company NVARCHAR(50) NOT NULL,
    Address NVARCHAR(20) NOT NULL,
    Phone NUMERIC NOT NULL,
    INN NVARCHAR(20) NOT NULL,

    CONSTRAINT PK_Code_delivery PRIMARY KEY (Code_delivery) 
)
GO


CREATE TABLE [KN303_Pechurin].Pechurin.Purchases
(
    Code_book INTEGER NOT NULL,
    Date_order DATE NOT NULL,
    Code_delivery INTEGER NOT NULL,
    Type_purchase BIT NOT NULL,
    Cost DECIMAL(20,2) NOT NULL,
    Amount INTEGER NOT NULL,
    Code_purchase INTEGER NOT NULL,

    CONSTRAINT FK_Code_book FOREIGN KEY (Code_book) 
	REFERENCES [KN303_Pechurin].Pechurin.Books(Code_book) ON DELETE CASCADE,

    CONSTRAINT FK_Code_delivery FOREIGN KEY (Code_delivery) 
	REFERENCES [KN303_Pechurin].Pechurin.Deliveries(Code_delivery)
)
GO 



INSERT INTO [KN303_Pechurin].[Pechurin].Publishing_house (Code_publish, Publish, City)
VALUES 
(1,	N'publish1',	N'city1'),
(2,	N'publish2',	N'Москва'),
(3,	N'publish3',	N'city3'),
(4,	N'Питер-Софт',	N'Нижний Новгород'),
(5,	N'publish5',	N'city5'),
(6,	N'Альфа',	N'Москва'),
(7,	N'publish7',	N'Новосибирск'),
(8,	N'publish8',	N'Москва'),
(9,	N'Наука',	N'Москва'),
(10,	N'publish10',	N'city10'),
(11,	N'publish11',	N'city11'),
(12,	N'publish12',	N'Москва'),
(13,	N'Мир',	N'Москва'),
(14,	N'Питер',	N'Санкт-Петербург'),
(15,	N'publish15',	N'city15')
GO

INSERT INTO [KN303_Pechurin].[Pechurin].Deliveries (Code_delivery, Name_delivery, Name_Company, Address, Phone, INN)
VALUES
(1,	N'dilvery1',	N'company1',	N'adress1',	256678,	N'19354851'),
(2,	N'dilvery2',	N'company2',	N'adress2',	256679,	N'13498045'),
(3,	N'dilvery3',	N'ОАО "Книги"',	N'adress3',	256680,	N'8601020863'),
(4,	N'dilvery4',	N'ОАО Луч',	N'adress4',	256681,	N'7709028658'),
(5,	N'dilvery5',	N'company5',	N'adress5',	256682,	N'14401362'),
(6,	N'dilvery6',	N'ОАО «Каменск-Уральская типография»',	N'adress6',	256683,	N'6612045778'),
(7,	N'dilvery7',	N'ОАО Книготорг',	N'adress7',	256684,	N'917024242'),
(8,	N'dilvery8',	N'ЗАО Квантор',	N'adress8',	256685,	N'7725704102'),
(9,	N'dilvery9',	N'company9',	N'adress9',	256686,	N'16251647'),
(10,	N'dilvery10',	N'ОАО «Полиграфическое объединение «Север»',	N'adress10',	256687,	N'6680004508'),
(11,	N'dilvery11',	N'Комбинат Волгоградский',	N'adress11',	256688,	N'3446015546'),
(12,	N'dilvery12',	N'Торговый Дом Волжский',	N'adress12',	256689,	N'6313001606'),
(13,	N'dilvery13',	N'company13',	N'adress13',	256690,	N'15316511'),
(14,	N'dilvery14',	N'ЗАО Оптторг',	N'adress14',	256691,	N'6670129307'),
(15,	N'dilvery15',	N'company15',	N'adress15',	256692,	N'18175323')
GO

INSERT INTO [KN303_Pechurin].[Pechurin].[Authors] (Code_author, Name_author, Birthday)
VALUES
(1,	N'authorName1',	CONVERT(DATE, '01-01-1840', 105)),
(2,	N'authorName2',	CONVERT(DATE, '1-1-1976', 105)),
(3,	N'authorName3',	CONVERT(DATE, '02-06-1857', 105)),
(4,	N'authorName4',	CONVERT(DATE, '3-2-1854', 105)),
(5,	N'Акунин Борис', CONVERT(DATE, '05-09-1956', 105)),
(6,	N'authorName6',	CONVERT(DATE, '22-09-1866' , 105)),
(7,	N'Кассиль Лев Абрамович', CONVERT(DATE, '6-11-1905', 105)),
(8,	N'Куприн Александр Иванович', CONVERT(DATE, '26-08-1870', 105)),
(9,	N'Вишневский Владимир Петрович', CONVERT(DATE, '8-07-1953', 105)),
(10, N'Иванова Лидия Михайловна', CONVERT(DATE, '3-7-1936', 105)),
(11, N'Иванов Анатолий Степанович',	CONVERT(DATE, '5-5-1828', 105)),
(12, N'Иванов Алексей Викторович', CONVERT(DATE, '11-06-1969', 105)),
(13, N'Асиман Андре', CONVERT(DATE, '1-02-1851', 105)),
(14, N'Ширвиндт Михаил', CONVERT(DATE, '8-09-1858', 105)),
(15, N'Голден Артур', CONVERT(DATE, '12-06-1756', 105)),
(16, N'Толстой Л.Н.', CONVERT(DATE, '28-08-1828', 105)),
(17, N'Достоевский Ф.М.', CONVERT(DATE, '30-10-1821', 105)),
(18, N'Пушкин А.С.', CONVERT(DATE, '26-05-1799', 105))
GO

INSERT INTO KN303_Pechurin.Pechurin.Books (Code_book, Title_book, Pages, Code_author, Code_publish)
VALUES
(1, N'bookname1',	308,	11,	4),
(2, N'Труды',	107	,11,	1),
(3, N'bookname3',	342	,12,	10),
(4, N'Мемуары гейши'	,384,	13,	15),
(5, N'bookname5',	371,	3,	11),
(6, N'bookname6',	374	,5,	13),
(7, N'Из Египта. Мемуары',	250	,3,	13),
(8, N'bookname8',	339	,2,	1),
(9, N'bookname9'	,384,	10,	6),
(10, N'bookname10',	324	,5,	6),
(11, N'bookname11'	,353,	1	,6),
(12, N'Мемуары двоечника',	287	,13	,14),
(13, N'Труды Университета'	,389,	11,	7),
(14, N'bookname14',	337	,2,	11),
(15, N'bookname15',	388	,7	,7),
(16, N'bookname16',	362	,13,	4),
(17, N'bookname17',	379,	8,	5),
(18, N'bookname18',	238	,15,	4),
(19, N'bookname19',	337	,12	,11),
(20, N'bookname20',	326	,11,	2),
(21,  N'bookname21',	364	,13	,9),
(22,  N'bookname22',	347	,15,	3),
(23,  N'bookname23'	,301,	4	,9),
(24,  N'bookname24',	398,	9,	7),
(25,  N'bookname25'	,361,	4,	2),
(26,  N'bookname26'	,303,	14,	1),
(27,  N'bookname27'	,380,	3	,4),
(28,  N'bookname28'	,320,	5,	13),
(29,  N'bookname29'	,344,	14,	13),
(30,  N'bookname30'	,364,	15,	10),
(31,  N'Отрочество',	80,	16,	4),
(32,  N'Казаки'	,208,	16,	4),
(33,  N'Игрок'	,224,	17,	4),
(34,  N'Сказки'	,144,	18	,4)
GO

INSERT INTO [KN303_Pechurin].[Pechurin].Purchases (Code_purchase, Code_book, Date_order, Code_delivery, Type_purchase, Cost, Amount) 
VALUES
(1, 21, CONVERT(DATE, '1-1-2018', 105), 9, 0, 174.0, 7),
(2, 24, CONVERT(DATE, '2-1-2018', 105), 4, 0, 137.0, 13),
(3, 5, CONVERT(DATE, '3-1-2018', 105), 11, 1, 117.0, 10),
(4, 12, CONVERT(DATE, '4-1-2003', 105), 8, 1, 164.0, 2),
(5, 5, CONVERT(DATE, '12-3-2003', 105), 7, 0, 185.0, 1),
(6, 16, CONVERT(DATE, '13-1-2003', 105), 10, 1, 145.0, 6),
(7, 19, CONVERT(DATE, '7-1-2018', 105), 8, 0, 120.0, 19),
(8, 15, CONVERT(DATE, '14-5-2003', 105), 5, 1, 149.0, 0),
(9, 22, CONVERT(DATE, '15-5-2003', 105), 4, 0, 188.0, 19),
(10, 11, CONVERT(DATE, '10-6-2003', 105), 4, 1, 169.0, 19),
(11, 21, CONVERT(DATE, '11-1-2002', 105), 10, 1, 128.0, 10),
(12, 8, CONVERT(DATE, '12-1-2018', 105), 8, 0, 172.0, 10),
(13, 3, CONVERT(DATE, '13-1-2018', 105), 5, 0, 187.0, 1),
(14, 10, CONVERT(DATE, '14-1-2002', 105), 2, 1, 128.0, 1),
(15, 17, CONVERT(DATE, '15-1-2018', 105), 2, 0, 139.0, 17),
(16, 10, CONVERT(DATE, '16-1-2018', 105), 11, 0, 176.0, 1),
(17, 1, CONVERT(DATE, '17-1-2018', 105), 7, 1, 201.0, 3),
(18, 1, CONVERT(DATE, '18-1-2018', 105), 6, 1, 178.0, 5),
(19, 24, CONVERT(DATE, '19-1-2018', 105), 11, 0, 132.0, 18),
(20, 7, CONVERT(DATE, '20-3-2002', 105), 11, 1, 153.0, 3),
(21, 3, CONVERT(DATE, '21-1-2018', 105), 9, 1, 146.0, 20),
(22, 2, CONVERT(DATE, '22-5-2002', 105), 1, 0, 118.0, 12),
(23, 25, CONVERT(DATE, '23-1-2018', 105), 6, 0, 132.0, 14),
(24, 26, CONVERT(DATE, '24-1-2018', 105), 7, 1, 150.0, 18),
(25, 20, CONVERT(DATE, '25-1-2018', 105), 12, 0, 150.0, 6),
(26, 23, CONVERT(DATE, '26-1-2018', 105), 8, 1, 103.0, 7),
(27, 22, CONVERT(DATE, '27-1-2018', 105), 14, 1, 134.0, 5),
(28, 28, CONVERT(DATE, '28-1-2018', 105), 4, 0, 186.0, 22),
(29, 5, CONVERT(DATE, '29-1-2018', 105), 11, 0, 164.0, 2),
(30, 27, CONVERT(DATE, '30-1-2018', 105), 12, 0, 110.0, 23),
(31, 19, CONVERT(DATE, '31-1-2018', 105), 13, 0, 110.0, 12),
(32, 27, CONVERT(DATE, '1-2-2018', 105), 2, 1, 127.0, 3),
(33, 16, CONVERT(DATE, '2-2-2018', 105), 5, 0, 170.0, 19),
(34, 12, CONVERT(DATE, '3-2-2018', 105), 5, 1, 148.0, 22),
(35, 24, CONVERT(DATE, '4-2-2018', 105), 7, 0, 145.0, 4),
(36, 24, CONVERT(DATE, '5-2-2018', 105), 11, 0, 190.0, 21),
(37, 4, CONVERT(DATE, '6-2-2018', 105), 11, 1, 122.0, 1),
(38, 4, CONVERT(DATE, '7-2-2018', 105), 3, 0, 113.0, 0),
(39, 21, CONVERT(DATE, '8-2-2018', 105), 11, 1, 156.0, 0),
(40, 14, CONVERT(DATE, '9-2-2018', 105), 14, 0, 186.0, 3),
(41, 19, CONVERT(DATE, '10-2-2018', 105), 11, 0, 111.0, 15),
(42, 27, CONVERT(DATE, '11-2-2018', 105), 10, 1, 161.0, 24),
(43, 5, CONVERT(DATE, '12-2-2018', 105), 1, 1, 137.0, 16),
(44, 26, CONVERT(DATE, '13-2-2018', 105), 5, 1, 180.0, 12),
(45, 9, CONVERT(DATE, '14-2-2018', 105), 12, 0, 198.0, 16),
(46, 7, CONVERT(DATE, '15-2-2018', 105), 7, 1, 163.0, 21),
(47, 8, CONVERT(DATE, '16-2-2018', 105), 1, 0, 105.0, 17),
(48, 28, CONVERT(DATE, '17-2-2018', 105), 11, 1, 157.0, 1),
(49, 22, CONVERT(DATE, '18-2-2018', 105), 10, 0, 192.0, 9),
(50, 25, CONVERT(DATE, '19-2-2018', 105), 10, 0, 125.0, 6),
(51, 30, CONVERT(DATE, '20-2-2018', 105), 4, 1, 190.0, 11),
(52, 5, CONVERT(DATE, '21-2-2018', 105), 1, 0, 178.0, 16),
(53, 11, CONVERT(DATE, '22-2-2018', 105), 11, 0, 149.0, 6),
(54, 24, CONVERT(DATE, '23-2-2018', 105), 15, 0, 123.0, 13),
(55, 13, CONVERT(DATE, '24-2-2018', 105), 4, 1, 140.0, 5),
(56, 1, CONVERT(DATE, '25-2-2018', 105), 2, 0, 180.0, 20),
(57, 19, CONVERT(DATE, '26-2-2018', 105), 6, 0, 197.0, 24),
(58, 10, CONVERT(DATE, '27-2-2018', 105), 13, 0, 160.0, 22),
(59, 21, CONVERT(DATE, '28-2-2018', 105), 2, 1, 180.0, 16),
(60, 9, CONVERT(DATE, '1-3-2018', 105), 1, 1, 119.0, 5),
(61, 31, CONVERT(DATE, '1-1-2018', 105), 3, 1, 51.0, 5),
(62, 32, CONVERT(DATE, '1-2-2013', 105), 3, 1, 70.0, 5),
(63, 33, CONVERT(DATE, '21-11-2020', 105), 4, 1, 191.0, 5),
(64, 34, CONVERT(DATE, '22-11-2020', 105), 4, 1, 185.0, 6),
(65, 34, CONVERT(DATE, '23-11-2020', 105), 4, 0, 185.0, 110),
(66, 9, CONVERT(DATE, '24-11-2020', 105), 2, 1, 400.0, 5),
(67, 32, CONVERT(DATE, '03-11-2018', 105), 1, 0, 69.0, 20),
(68, 23, CONVERT(DATE, '02-09-2018', 105), 8, 0, 100.0, 20),
(69, 21, CONVERT(DATE, '02-07-2018', 105), 9, 0, 150.0, 20)
GO

-- 1
SELECT Name_delivery, INN, Phone, Address, Code_delivery FROM [KN303_Pechurin].[Pechurin].Deliveries
GO

-- 2
SELECT Name_Company, Phone, INN FROM [KN303_Pechurin].[Pechurin].Deliveries
WHERE Name_Company LIKE N'ОАО%'
GROUP BY Name_Company, Phone, INN
GO

-- 3
SELECT Name_author FROM [KN303_Pechurin].Pechurin.Authors
WHERE Birthday BETWEEN '1840/01/01' AND '1860/06/01'
GO

-- 4 
SELECT Books.Title_book FROM [KN303_Pechurin].[Pechurin].Books 
INNER JOIN KN303_Pechurin.Pechurin.Publishing_house 
ON Books.Code_publish = Publishing_house.Code_publish
WHERE Publishing_house.Publish IN (N'Питер-Софт', N'Альфа', N'Наука')
GO

-- 5
SELECT Code_delivery AS 'Код поставщика', 
Date_order AS 'Дата заказа', 
Books.Title_book AS 'Название книги'
FROM KN303_Pechurin.Pechurin.Purchases
INNER JOIN KN303_Pechurin.Pechurin.Books 
ON Purchases.Code_book = Books.Code_book
WHERE Purchases.Amount > 100 OR Purchases.Cost BETWEEN 200 AND 500
GO

-- 6
SELECT Deliveries.Name_Company AS "Поставщик" FROM KN303_Pechurin.Pechurin.Purchases
INNER JOIN KN303_Pechurin.Pechurin.Books
ON Purchases.Code_book = Books.Code_book
INNER JOIN KN303_Pechurin.Pechurin.Publishing_house
ON Books.Code_publish = Publishing_house.Code_publish
INNER JOIN KN303_Pechurin.Pechurin.Deliveries
ON Purchases.Code_delivery = Deliveries.Code_delivery
WHERE Publishing_house.Publish = N'Питер'
GO

-- 7
SELECT SUM(Purchases.Cost) AS 'Сумма поставок' FROM KN303_Pechurin.Pechurin.Purchases
INNER JOIN KN303_Pechurin.Pechurin.Deliveries
ON Purchases.Code_delivery = Deliveries.Code_delivery
WHERE Deliveries.Name_Company = N'ЗАО Оптторг'
GO

-- 8
SELECT Books.Title_book AS 'Название книги', SUM(Purchases.Amount * Purchases.Cost) as Itogo
FROM KN303_Pechurin.Pechurin.Purchases
INNER JOIN KN303_Pechurin.Pechurin.Books
ON Purchases.Code_book = Books.Code_book
WHERE Date_order BETWEEN '2002/01/01' AND '2002/06/01'
GROUP BY Title_book, Purchases.Amount
GO

-- 9 
CREATE FUNCTION booksAmountLowerThen(@amount INTEGER)
RETURNS TABLE

RETURN
SELECT Books.Title_book FROM KN303_Pechurin.Pechurin.Purchases 
INNER JOIN KN303_Pechurin.Pechurin.Books
ON Purchases.Code_book = Books.Code_book
GROUP BY Books.Title_book
HAVING SUM(Amount) < @amount
GO

SELECT * FROM booksAmountLowerThen(10)

-- 10
DECLARE Temp2 CURSOR STATIC FOR
SELECT Name_Company from KN303_Pechurin.Pechurin.Deliveries
DECLARE @name_company NVARCHAR(50)
OPEN Temp2
FETCH FIRST FROM Temp2 INTO @name_company
WHILE @@FETCH_STATUS=0
BEGIN
PRINT @name_company
FETCH NEXT FROM Temp2 INTO @name_company
END
CLOSE Temp2

DEALLOCATE Temp2
GO

-- 11
SELECT Publishing_house.Publish AS 'Издательство' 
FROM KN303_Pechurin.Pechurin.Purchases
INNER JOIN KN303_Pechurin.Pechurin.Books
ON Purchases.Code_book = Books.Code_book
INNER JOIN KN303_Pechurin.Pechurin.Publishing_house
ON Books.Code_publish = Publishing_house.Code_publish
WHERE Type_purchase = 0
GO

-- 12
CREATE PROCEDURE increaseCost
AS 
BEGIN

DECLARE @latestDate DATE
DECLARE @monthAgoDate DATE
SET @latestDate = (SELECT TOP 1 Date_order FROM KN303_Pechurin.Pechurin.Purchases ORDER BY Date_order DESC)
SET @monthAgoDate = (DATEADD(MONTH, -1, @latestDate))


UPDATE KN303_Pechurin.Pechurin.Purchases
SET Cost = Cost + ((Cost * 20) / 100)
WHERE Date_order BETWEEN @monthAgoDate AND @latestDate

END
GO

EXEC increaseCost

SELECT * FROM KN303_Pechurin.Pechurin.Purchases
GO

-- 13
DELETE FROM KN303_Pechurin.Pechurin.Authors
WHERE Name_author NOT LIKE '%[^a-z0-9 .]%'
GO

SELECT * FROM KN303_Pechurin.Pechurin.Authors

-- 14
DELETE FROM KN303_Pechurin.Pechurin.Books
WHERE Code_publish = 4
GO

SELECT * FROM KN303_Pechurin.Pechurin.Publishing_house
GO

SELECT * FROM KN303_Pechurin.Pechurin.Books
GO

CREATE TRIGGER DeletePublish
        ON [KN303_Pechurin].Pechurin.Books
        AFTER DELETE
AS
BEGIN
    IF EXISTS(SELECT * FROM 
                (SELECT Books.Code_book, Publishing_house.Code_publish  FROM KN303_Pechurin.Pechurin.Books 
                RIGHT JOIN KN303_Pechurin.Pechurin.Publishing_house 
                ON Books.Code_publish = Publishing_house.Code_publish) t WHERE t.Code_book IS NULL  )

                DELETE FROM KN303_Pechurin.Pechurin.Publishing_house 
                WHERE Code_publish IN (SELECT t.Code_publish FROM 
                (SELECT Books.Code_book, Publishing_house.Code_publish  FROM KN303_Pechurin.Pechurin.Books 
                RIGHT JOIN KN303_Pechurin.Pechurin.Publishing_house 
                ON Books.Code_publish = Publishing_house.Code_publish) t WHERE t.Code_book IS NULL )
END
GO

-- 15
CREATE PROCEDURE info(@bookName NVARCHAR(30))
AS 
BEGIN

DECLARE @Publish NVARCHAR(30)
SET @Publish = (SELECT Publishing_house.Publish FROM KN303_Pechurin.Pechurin.Books INNER JOIN KN303_Pechurin.Pechurin.Publishing_house ON Books.Code_publish = Publishing_house.Code_publish WHERE Books.Title_book = @bookName)


DECLARE @Delivery NVARCHAR(100)
SELECT @Delivery = COALESCE(@Delivery + ', ', '') + Deliveries.Name_Company FROM KN303_Pechurin.Pechurin.Purchases 
                INNER JOIN KN303_Pechurin.Pechurin.Books ON Purchases.Code_book = Books.Code_book
                INNER JOIN KN303_Pechurin.Pechurin.Deliveries ON Purchases.Code_delivery = Deliveries.Code_delivery
                WHERE Books.Title_book = @bookName

DECLARE @SummaryCost DECIMAL(20,2)
SET @SummaryCost = (SELECT SUM (Purchases.Cost * Purchases.Amount) FROM KN303_Pechurin.Pechurin.Purchases 
                    INNER JOIN KN303_Pechurin.Pechurin.Books ON Purchases.Code_book = Books.Code_book 
                    WHERE Books.Title_book = @bookName)
DECLARE @SummaryAmount INTEGER
SET @SummaryAmount = (SELECT SUM (Purchases.Amount) FROM KN303_Pechurin.Pechurin.Purchases 
                    INNER JOIN KN303_Pechurin.Pechurin.Books ON Purchases.Code_book = Books.Code_book 
                    WHERE Books.Title_book = @bookName)

DECLARE @StartDate DATE
SET @StartDate = (SELECT TOP 1 Purchases.Date_order FROM KN303_Pechurin.Pechurin.Purchases 
                    INNER JOIN KN303_Pechurin.Pechurin.Books 
                    ON Purchases.Code_book = Books.Code_book
                    WHERE Books.Title_book = @bookName
                    ORDER BY Purchases.Date_order ASC)
DECLARE @EndDate DATE
SET @EndDate = (SELECT TOP 1 Purchases.Date_order FROM KN303_Pechurin.Pechurin.Purchases 
                    INNER JOIN KN303_Pechurin.Pechurin.Books 
                    ON Purchases.Code_book = Books.Code_book
                    WHERE Books.Title_book = @bookName
                    ORDER BY Purchases.Date_order DESC)
DECLARE @AvgCostForMOnth DECIMAL(20,2)
DECLARE @AmountForMonth INTEGER
DECLARE @SummaryForMonth DECIMAL(20,2)


PRINT N'Название: ' + @bookName
PRINT N'Издательство: ' + CAST(@Publish AS NVARCHAR(30))
PRINT N'Поставщики: ' + CAST(@Delivery AS NVARCHAR(30))
PRINT N'Общая стоимость: ' + CAST(@SummaryCost AS NVARCHAR(30))
PRINT N'Всего продано: ' + CAST(@SummaryAmount AS NVARCHAR(30))
PRINT N'Итоги по месяцам: '
WHILE (@StartDate <= @EndDate) 
    BEGIN

    SET @AvgCostForMOnth = (SELECT AVG (Purchases.Cost) FROM KN303_Pechurin.Pechurin.Purchases 
                    INNER JOIN KN303_Pechurin.Pechurin.Books ON Purchases.Code_book = Books.Code_book 
                    WHERE Books.Title_book = @bookName
                    AND Purchases.Date_order BETWEEN @StartDate AND (DATEADD(MONTH, +1, @StartDate)))
    
    SET @AmountForMonth = (SELECT SUM (Purchases.Amount) FROM KN303_Pechurin.Pechurin.Purchases 
                    INNER JOIN KN303_Pechurin.Pechurin.Books ON Purchases.Code_book = Books.Code_book 
                    WHERE Books.Title_book = @bookName
                    AND Purchases.Date_order BETWEEN @StartDate AND (DATEADD(MONTH, +1, @StartDate)))

    SET @SummaryForMonth = (SELECT SUM (Purchases.Cost * Purchases.Amount) FROM KN303_Pechurin.Pechurin.Purchases 
                    INNER JOIN KN303_Pechurin.Pechurin.Books ON Purchases.Code_book = Books.Code_book 
                    WHERE Books.Title_book = @bookName
                    AND Purchases.Date_order BETWEEN @StartDate AND (DATEADD(MONTH, +1, @StartDate)))
    
    IF  (@AvgCostForMOnth IS NOT NULL AND @AmountForMonth IS NOT NULL AND @SummaryForMonth IS NOT NULL)
    BEGIN
        PRINT N'    ' + CAST(FORMAT(@StartDate, 'MMM, yyyy', 'ru-RU') AS NVARCHAR(30))
        PRINT N'        Средняя стоимость: ' + CAST(@AvgCostForMOnth AS NVARCHAR(30))
        PRINT N'        Продано: ' + CAST(@AmountForMonth AS NVARCHAR(30))
        PRINT N'        Выручка: ' + CAST(@SummaryForMonth AS NVARCHAR(30))
    END
    

    SET @StartDate = (DATEADD(MONTH, +1, @StartDate))

END



END
GO

EXEC info N'Отрочество'

SELECT * FROM KN303_Pechurin.Pechurin.Purchases  INNER JOIN KN303_Pechurin.Pechurin.Books ON Purchases.Code_book = Books.Code_book 
                    WHERE Books.Title_book = N'Казаки'
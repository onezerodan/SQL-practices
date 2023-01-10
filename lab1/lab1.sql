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



CREATE TABLE [KN303_Pechurin].Pechurin.store
(
	Id_s tinyint NOT NULL, 
	Name varchar(15) NOT NULL, 
	Street nvarchar(20) NOT NULL, 
	HouseNumber varchar(10) NOT NULL,
    CONSTRAINT PK_Id PRIMARY KEY (Id_s) 
)
GO

CREATE TABLE [KN303_Pechurin].Pechurin.product_group
(
	Id_g tinyint NOT NULL,
	Name varchar(50) NOT NULL,
	CONSTRAINT PK_Id_g PRIMARY KEY (Id_g)
)
GO

CREATE TABLE [KN303_Pechurin].Pechurin.product
(
	Id_p smallint NOT NULL,
	Name varchar(100) NOT NULL,
	Unit varchar(10) NOT NULL,
	Id_g tinyint NOT NULL,
	CONSTRAINT PK_Id_p PRIMARY KEY (Id_p),
	CONSTRAINT FK_Id_g FOREIGN KEY (Id_g) 
	REFERENCES [KN303_Pechurin].Pechurin.product_group(Id_g)
)
GO

CREATE TABLE [KN303_Pechurin].Pechurin.storage
(
	Id_s tinyint NOT NULL,
	CONSTRAINT FK_Id_s FOREIGN KEY (Id_s) 
	REFERENCES [KN303_Pechurin].Pechurin.store(Id_s),

	Id_p smallint NOT NULL,
	CONSTRAINT FK_Id_p FOREIGN KEY (Id_p) 
	REFERENCES [KN303_Pechurin].Pechurin.product(Id_p),

	Amount decimal(10,3) NOT NULL,
	Price decimal(9,2) NOT NULL,
	Time smalldatetime NOT NULL,
	State smallint NOT NULL,
)
GO

INSERT INTO [KN303_Pechurin].Pechurin.store
 (Id_s, Name, Street, HouseNumber)
 VALUES 
 (1, 'Perekrestok', 'Lenina', '100'),
 (2, 'Lenta', 'Malysheva', '11'),
 (3, 'Bristol', 'Amundsena', '34')
GO

INSERT INTO [KN303_Pechurin].Pechurin.product_group
(Id_g, Name)
VALUES
(1, 'Molochnye'),
(2, 'Konditerskie'),
(3, 'Alkogol')
GO

INSERT INTO [KN303_Pechurin].Pechurin.product
(Id_p, Name, Unit, Id_g)
VALUES
(1, 'Moloko', 'bottle', 1),
(2, 'Cheese', 'shtuka', 1),
(3, 'Slivki', 'bottle', 1),
(4, 'Kefir', 'bottle', 1),

(5, 'Tort', 'shtuka', 2),
(6, 'Bulka', 'shtuka', 2),
(7, 'Bublik', 'shtuka', 2),
(8, 'Ekler', 'shtuka', 2),

(9, 'Kapitan Morgan', 'bottle', 3),
(10, 'Jagermeister', 'bottle', 3),
(11, 'Vodka', 'bottle', 3),
(12, 'Pivo', 'bottle', 3)

GO



INSERT INTO [KN303_Pechurin].Pechurin.storage
 (Id_s, Id_p, Amount, Price, Time, State)
 VALUES 
 --1--
 (1, 1, 10, 80,'2022-05-08 12:35:29', 1),
 (2, 1, 4, 87,'2022-06-08 11:35:29', 1),
 (3, 1, 15, 76,'2022-07-08 16:35:29', 1),
 --2--
 (1, 2, 3, 34,'2022-08-08 18:35:29', 1),
 (2, 2, 12, 36,'2022-09-08 12:35:29', 1),
 (3, 2, 22, 40,'2022-10-08 14:35:29', 1),
 --3--
 (1, 3, 32, 333,'2022-11-08 15:35:29', 1),
 (2, 3, 34, 350,'2022-12-08 17:35:29', 1),
 (3, 3, 75, 345,'2022-01-08 12:35:29', 1),
 --4--
 (1, 4, 23, 123,'2022-02-08 16:35:29', 1),
 (2, 4, 65, 132,'2022-03-08 12:35:29', 1),
 (3, 4, 53, 122,'2022-04-08 17:35:29', 1),
 --5--
 (1, 5, 87, 444,'2022-05-08 18:35:29', 1),
 (2, 5, 54, 454,'2022-06-08 19:35:29', 1),
 (3, 5, 84, 455,'2022-07-08 20:35:29', 1),
 --6--
 (1, 6, 66, 652,'2022-08-08 21:35:29', 1),
 (2, 6, 77, 650,'2022-09-08 22:35:29', 1),
 (3, 6, 88, 700,'2022-10-08 23:35:29', 1),
 --7--
 (1, 7, 34, 49,'2022-11-08 12:36:29', 1),
 (2, 7, 76, 56,'2022-12-08 12:37:29', 1),
 (3, 7, 34, 66,'2022-01-08 12:32:29', 1),
 --8--
 (1, 8, 87, 345,'2022-02-08 13:36:29', 1),
 (2, 8, 43, 354,'2022-03-08 14:38:29', 1),
 (3, 8, 82, 350,'2022-04-08 15:32:29', 1),
 --9--
 (1, 9, 98, 1876,'2022-02-08 16:36:29', 1),
 (2, 9, 99, 1870,'2022-03-08 17:38:29', 1),
 (3, 9, 100,1800,'2022-04-08 18:32:29', 1),
 --10--
 (1, 10, 44, 33,'2022-02-08 19:36:29', 1),
 (2, 10, 56, 26,'2022-03-08 20:38:29', 1),
 (3, 10, 11, 29,'2022-04-08 21:32:29', 1),
 --11--
 (1, 11, 45, 888,'2022-02-08 22:36:29', 1),
 (2, 11, 67, 777,'2022-03-08 23:38:29', 1),
 (3, 11, 34, 877,'2022-04-08 10:32:29', 1),
 --12--
 (1, 12, 10, 55,'2022-02-08 09:36:29', 1),
 (2, 12, 11, 60,'2022-03-08 08:38:29', 1),
 (3, 12, 8, 78,'2022-04-08 07:32:29', 1)

GO

SELECT * From [KN303_Pechurin].Pechurin.product
GO

SELECT * From [KN303_Pechurin].Pechurin.storage
GO

;



-- Количество определенного товара во всех магазинах на определенную дату.
select store.Name as 'Магазин'
	, product.Name as 'Название товара'
	,sum(storage.Amount* storage.State) as 'Количество товара' ,
	FORMAT(storage.Time, 'D', 'ru-RU') as 'Дата'

	from 
		[KN303_Pechurin].Pechurin.storage inner join 
		[KN303_Pechurin].Pechurin.product on [KN303_Pechurin].Pechurin.product.id_p = [KN303_Pechurin].Pechurin.storage.id_p
		inner join [KN303_Pechurin].Pechurin.store on [KN303_Pechurin].Pechurin.store.id_s =[KN303_Pechurin].Pechurin.storage.id_s
		--where storage.time = '2022-08-08 21:35:29'
	group by product.Name, store.Name, storage.Time
GO

-- Количество определенного товара в каждом магазине.
select store.Name as 'Магазин'
	, product.Name as 'Название товара'
	,sum(storage.Amount* storage.State) as 'Количество товара' ,
	product.Unit as 'Единицы измерения'
	from 
		[KN303_Pechurin].Pechurin.storage inner join 
		[KN303_Pechurin].Pechurin.product on [KN303_Pechurin].Pechurin.product.id_p = [KN303_Pechurin].Pechurin.storage.id_p
		inner join [KN303_Pechurin].Pechurin.store on [KN303_Pechurin].Pechurin.store.id_s =[KN303_Pechurin].Pechurin.storage.id_s
		
		where product.Name = 'Moloko'
	group by product.Name, store.Name, product.Unit
GO

-- Максимальная, минимальная и средняя цена для определенного продукта
select
	product.Name as 'Название товара'
	,max(storage.Price) as 'максимальная цена'
	,min(storage.Price) as 'минимальная цена'
	,cast(ROUND(avg(storage.Price),2) as numeric(36,2)) as 'средняя цена'
	from 
		[KN303_Pechurin].Pechurin.storage inner join 
		[KN303_Pechurin].Pechurin.product on [KN303_Pechurin].Pechurin.product.id_p = [KN303_Pechurin].Pechurin.storage.id_p
	where product.Name = 'Moloko'
	group by product.Name
GO

-- Магазин, в котором цена на определенный продукт минимальная

SELECT TOP 1 storage.Price as 'Цена',
product.Name as 'Продукт',
	store.Name as 'Магазин'
	FROM 
	[KN303_Pechurin].Pechurin.storage inner join 
		[KN303_Pechurin].Pechurin.product on [KN303_Pechurin].Pechurin.product.id_p = [KN303_Pechurin].Pechurin.storage.id_p INNER JOIN
		[KN303_Pechurin].Pechurin.store on [KN303_Pechurin].Pechurin.store.Id_s = [KN303_Pechurin].Pechurin.storage.Id_s
	where product.Name = 'Moloko'  
	group by product.Name, storage.Price, store.Name
	order by storage.Price ASC
	go

	-- Магазин, в котором цена на определенный продукт максимальная
SELECT TOP 1 storage.Price as 'Цена',
product.Name as 'Продукт',
	store.Name as 'Магазин'
	FROM 
	[KN303_Pechurin].Pechurin.storage inner join 
		[KN303_Pechurin].Pechurin.product on [KN303_Pechurin].Pechurin.product.id_p = [KN303_Pechurin].Pechurin.storage.id_p INNER JOIN
		[KN303_Pechurin].Pechurin.store on [KN303_Pechurin].Pechurin.store.Id_s = [KN303_Pechurin].Pechurin.storage.Id_s
	where product.Name = 'Moloko'  
	group by product.Name, storage.Price, store.Name
	order by storage.Price DESC
	go
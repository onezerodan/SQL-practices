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

CREATE TABLE [KN303_Pechurin].Pechurin.regions
(
	name nvarchar(30) NOT NULL,
	code int NOT NULL,
	CONSTRAINT PK_code PRIMARY KEY (code) 
)
GO

INSERT INTO [KN303_Pechurin].Pechurin.regions (name, code) 
VALUES 
(N'Свердловская область', 66),
(N'Челябинская область', 74),
(N'Ростовская область', 61),
(N'Магаданская область', 49),
(N'Алтайский край', 22)


CREATE TABLE [KN303_Pechurin].Pechurin.codes
(
	code int,
	alternateCode int,
	CONSTRAINT FK_code FOREIGN KEY (code) 
	REFERENCES [KN303_Pechurin].Pechurin.regions(code)
)
GO

INSERT INTO [KN303_Pechurin].Pechurin.codes (code, alternateCode) 
VALUES 
(66, 66),
(66, 96),
(66, 196),

(74, 74),
(74, 174),
(74, 774),

(61, 61),
(61, 161),
(61, 761),

(49, 49),

(22, 22),
(22, 122)
GO



CREATE TABLE [KN303_Pechurin].Pechurin.posts
(
	name nvarchar(30) NOT NULL,
	id tinyint NOT NULL,
	CONSTRAINT PK_post_id PRIMARY KEY (id) 
)
GO

INSERT INTO [KN303_Pechurin].Pechurin.posts (name, id)
VALUES
(N'Северный пост', 1),
(N'Южный пост', 2),
(N'Западный пост', 3),
(N'Восточный пост', 4)
GO

CREATE FUNCTION fn_Region_Exists (@code INT)
RETURNS int AS
BEGIN
	IF EXISTS (SELECT * FROM [KN303_Pechurin].Pechurin.codes WHERE alternateCode = @code)
	BEGIN
		RETURN 1
	END
	ELSE
	BEGIN
		return 0
	END
	RETURN 0
END;
GO

CREATE FUNCTION fn_Post_Exists (@id INT)
RETURNS int AS
BEGIN
	IF EXISTS (SELECT * FROM [KN303_Pechurin].Pechurin.posts WHERE id = @id)
	BEGIN
		RETURN 1
	END
	ELSE
	BEGIN
		return 0
	END
	RETURN 0
END;
GO







CREATE TABLE [KN303_Pechurin].Pechurin.cars
(
	id integer IDENTITY(1,1) PRIMARY KEY,
	firstLetter nvarchar(1),
	digits varchar(3),
	secondLetter varchar(1),
	thirdLetter VARCHAR(1),
	region int,
	direction nvarchar(10),
	movingTime SMALLDATETIME,
	post_id tinyint,

	CONSTRAINT first_letter_check 
	CHECK (firstLetter in (N'А', N'В', N'Е', N'К', N'М', N'Н', N'О', N'Р', N'С', N'Т', N'У', N'Х', 
							'A', 'B', 'E', 'K', 'M', 'H', 'O', 'P', 'C', 'T', 'Y', 'X')),
	CONSTRAINT second_letter_check 
	CHECK (secondLetter in (N'А', N'В', N'Е', N'К', N'М', N'Н', N'О', N'Р', N'С', N'Т', N'У', N'Х', 
							'A', 'B', 'E', 'K', 'M', 'H', 'O', 'P', 'C', 'T', 'Y', 'X')),

	CONSTRAINT third_letter_check 
	CHECK (thirdLetter in (N'А', N'В', N'Е', N'К', N'М', N'Н', N'О', N'Р', N'С', N'Т', N'У', N'Х', 
							'A', 'B', 'E', 'K', 'M', 'H', 'O', 'P', 'C', 'T', 'Y', 'X')),
						
	CONSTRAINT digits_check
	CHECK (digits not like '%[^0-9]%'),

	--CONSTRAINT region_check
	--CHECK (dbo.fn_Region_Exists(region) = 1),

	--CONSTRAINT post_check
	--CHECK (dbo.fn_Post_Exists(post_id) = 1),

	--CONSTRAINT direction_double_check
	--CHECK (dbo.fn_Direction_Check(direction, movingTime, firstLetter, digits, secondLetter, thirdLetter, region) = 1),

	CONSTRAINT direction_check
	CHECK (direction in (N'из города', N'в город'))
	

)
GO



CREATE TRIGGER SetRegister
        ON [KN303_Pechurin].Pechurin.cars
        AFTER INSERT
AS
BEGIN

    UPDATE  [KN303_Pechurin].Pechurin.cars
    SET     firstLetter = UPPER(firstLetter),
			secondLetter = UPPER(secondLetter),
			thirdLetter = UPPER(thirdLetter),
			direction = UPPER(direction)
			

    WHERE   id IN (SELECT id FROM cars)

END
GO

CREATE TRIGGER DirectionTrigger ON [KN303_Pechurin].Pechurin.cars
AFTER INSERT  
AS  
IF (ROWCOUNT_BIG() = 0)
RETURN;
IF  ((SELECT TOP 1 direction FROM [KN303_Pechurin].[Pechurin].cars
		WHERE 
			cars.region = region AND
			cars.firstLetter = firstLetter AND
			cars.secondLetter = secondLetter AND
			cars.digits = digits AND
			cars.thirdLetter = thirdLetter AND cars.movingTime != (SELECT movingTime FROM inserted)
		ORDER BY cars.movingTime DESC ) = (SELECT direction FROM inserted)
          )  
BEGIN  

RAISERROR ('Вы не можете въехать/выехать два раза подряд.', 16, 1);  
ROLLBACK TRANSACTION;  

RETURN   
END
ELSE
BEGIN
	RETURN
END
GO  

CREATE TRIGGER TimeDiffTrigger ON [KN303_Pechurin].Pechurin.cars
AFTER INSERT  
AS  
IF (ROWCOUNT_BIG() = 0)
RETURN;
DECLARE @firstTime SMALLDATETIME
DECLARE @secondTime SMALLDATETIME
set @firstTime	= (SELECT TOP 1 movingTime FROM [KN303_Pechurin].[Pechurin].cars
		WHERE 
			cars.region = region AND
			cars.firstLetter = firstLetter AND
			cars.secondLetter = secondLetter AND
			cars.digits = digits AND
			cars.thirdLetter = thirdLetter AND cars.movingTime != (SELECT movingTime FROM inserted)
		ORDER BY cars.movingTime DESC )
set @secondTime = (SELECT movingTime from inserted)

IF  (datediff(minute, @firstTime, @secondTime) < 5)  
BEGIN  

RAISERROR ('Временной интервал должен быть более 5 минут', 16, 1);  
ROLLBACK TRANSACTION;  

RETURN   
END
ELSE
BEGIN
	RETURN
END
GO  



CREATE VIEW CarsView AS
SELECT firstLetter + '' + 
		digits + '' + 
		secondLetter + '' +
		thirdLetter  AS "Номер",

		regions.name AS "Регион",

		direction AS "Направление",

		FORMAT([movingTime], 'HH:mm')  as "Время ",
		
		posts.name as "Пост"

FROM [KN303_Pechurin].Pechurin.cars INNER JOIN [KN303_Pechurin].Pechurin.codes 
ON [KN303_Pechurin].Pechurin.cars.region = [KN303_Pechurin].Pechurin.codes.alternateCode
INNER JOIN [KN303_Pechurin].Pechurin.regions on regions.code = alternateCode
INNER JOIN [KN303_Pechurin].[Pechurin].posts on posts.id = post_id
GO

CREATE VIEW TransitCarsView AS
SELECT DISTINCT firstLetter + '' + 
		digits + '' + 
		secondLetter + '' +
		thirdLetter  AS "Номер",

		regions.name AS "Регион"
		
FROM [KN303_Pechurin].Pechurin.cars INNER JOIN [KN303_Pechurin].Pechurin.codes 
ON [KN303_Pechurin].Pechurin.cars.region = [KN303_Pechurin].Pechurin.codes.alternateCode
INNER JOIN [KN303_Pechurin].Pechurin.regions on regions.code = alternateCode
INNER JOIN [KN303_Pechurin].[Pechurin].posts on posts.id = post_id
WHERE ((SELECT TOP 1 direction FROM [KN303_Pechurin].Pechurin.cars ORDER BY movingTime ASC) = N'В ГОРОД' AND 
		(SELECT TOP 1 direction FROM [KN303_Pechurin].Pechurin.cars ORDER BY movingTime DESC) = N'ИЗ ГОРОДА' AND
		(SELECT TOP 1 post_id FROM [KN303_Pechurin].Pechurin.cars ORDER BY movingTime ASC) != 
		(SELECT TOP 1 post_id FROM [KN303_Pechurin].Pechurin.cars ORDER BY movingTime DESC) AND
		regions.code != 66)

GO

CREATE VIEW NonresidentCarsView AS
SELECT firstLetter + '' + 
		digits + '' + 
		secondLetter + '' +
		thirdLetter  AS "Номер",

		regions.name AS "Регион"

FROM [KN303_Pechurin].Pechurin.cars INNER JOIN [KN303_Pechurin].Pechurin.codes 
ON [KN303_Pechurin].Pechurin.cars.region = [KN303_Pechurin].Pechurin.codes.alternateCode
INNER JOIN [KN303_Pechurin].Pechurin.regions on regions.code = alternateCode
INNER JOIN [KN303_Pechurin].[Pechurin].posts on posts.id = post_id
WHERE ((SELECT TOP 1 direction FROM [KN303_Pechurin].Pechurin.cars ORDER BY movingTime ASC) = N'В ГОРОД' AND 
		(SELECT TOP 1 direction FROM [KN303_Pechurin].Pechurin.cars ORDER BY movingTime DESC) = N'ИЗ ГОРОДА' AND
		(SELECT TOP 1 post_id FROM [KN303_Pechurin].Pechurin.cars ORDER BY movingTime ASC) =
		(SELECT TOP 1 post_id FROM [KN303_Pechurin].Pechurin.cars ORDER BY movingTime DESC))
GO

CREATE VIEW LocalCarsView AS
SELECT firstLetter + '' + 
		digits + '' + 
		secondLetter + '' +
		thirdLetter  AS "Номер",

		regions.name AS "Регион"

FROM [KN303_Pechurin].Pechurin.cars INNER JOIN [KN303_Pechurin].Pechurin.codes 
ON [KN303_Pechurin].Pechurin.cars.region = [KN303_Pechurin].Pechurin.codes.alternateCode
INNER JOIN [KN303_Pechurin].Pechurin.regions on regions.code = alternateCode
INNER JOIN [KN303_Pechurin].[Pechurin].posts on posts.id = post_id
WHERE ((SELECT TOP 1 direction FROM [KN303_Pechurin].Pechurin.cars ORDER BY movingTime ASC) = N'ИЗ ГОРОДА' AND 
		(SELECT TOP 1 direction FROM [KN303_Pechurin].Pechurin.cars ORDER BY movingTime DESC) = N'В ГОРОД' AND 
		regions.code = 66)
GO

CREATE VIEW OtherCarsView AS
SELECT CarsView.Номер,
		CarsView.Регион
FROM CarsView
LEFT JOIN TransitCarsView ON TransitCarsView.Номер = CarsView.Номер
LEFT JOIN NonresidentCarsView on NonresidentCarsView.Номер = CarsView.Номер
LEFT JOIN LocalCarsView on LocalCarsView.Номер = CarsView.Номер
WHERE (TransitCarsView.Номер IS NULL AND
		NonresidentCarsView.Номер IS NULL AND
		LocalCarsView.Номер IS NULL)
GO


/*
INSERT INTO [KN303_Pechurin].Pechurin.cars (firstLetter, digits, secondLetter, thirdLetter, region, direction, movingTime, post_id) 
VALUES 
(N'p','012', N'a', N'a', 22, N'из города', '12:45', 1)
GO
*/
DELETE FROM [KN303_Pechurin].Pechurin.cars
GO
INSERT INTO [KN303_Pechurin].Pechurin.cars (firstLetter, digits, secondLetter, thirdLetter, region, direction, movingTime, post_id) 
VALUES 
(N'а','012', N'а', N'а', 66, N'в город', '12:51', 1)
GO


INSERT INTO [KN303_Pechurin].Pechurin.cars (secondLetter) 
VALUES 
(N'а')
GO


INSERT INTO [KN303_Pechurin].Pechurin.cars (firstLetter, digits, secondLetter, thirdLetter, region, direction, movingTime, post_id) 
VALUES 
(N'p','012', N'a', N'a', 66, N'из ГОРОДа', '12:57', 4)
GO


IF N'а' in (N'А', N'В', N'Е', N'К', N'М', N'Н', N'О', N'Р', N'С', N'Т', N'У', N'Х', 
							'A', 'B', 'E', 'K', 'M', 'H', 'O', 'P', 'C', 'T', 'Y', 'X')
PRINT 'true'
GO


SELECT * from CarsView
GO

SELECT * from TransitCarsView
GO

SELECT * FROM NonresidentCarsView
GO

SELECT * FROM LocalCarsView
GO

SELECT * FROM OtherCarsView
GO


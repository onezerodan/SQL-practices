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

DROP PROCEDURE IF EXISTS addCurrencyToAccount
GO

DROP PROCEDURE IF EXISTS spendMoney
GO

DROP PROCEDURE IF EXISTS convertMoney
GO

DROP PROCEDURE IF EXISTS showBalanceInOneCurrency
GO

CREATE SCHEMA Pechurin 
GO

CREATE TABLE [KN303_Pechurin].Pechurin.exchange_rate
(
	src varchar(4) NOT NULL,
	dst varchar(4) NOT NULL,
	rate decimal(20,4) NOT NULL
)
GO

CREATE TABLE [KN303_Pechurin].Pechurin.account
(
	id TINYINT,
	currency varchar(4) NOT NULL,
	amount decimal(20,4) NOT NULL,
)
GO
--��������� ����� �����
INSERT INTO [KN303_Pechurin].Pechurin.exchange_rate
 (src, dst, rate)
 VALUES 
 --RUB--
 ('RUB', 'RUB', 1.0),
 ('RUB', 'GBP', 0.0143),
 ('RUB', 'TRY', 0.303),
 ('RUB', 'CNY', 0.118),

 --GBP--
 ('GBP', 'RUB', 69.96),
 ('GBP', 'GBP', 1.0),
 ('GBP', 'TRY', 21.19),
 ('GBP', 'CNY', 8.25),
 
 --TRY--
 ('TRY', 'RUB', 3.3),
 ('TRY', 'GBP', 0.0472),
 ('TRY', 'TRY', 1.0),
 ('TRY', 'CNY', 0.389),

 --CNY--
 ('CNY', 'RUB', 8.48),
 ('CNY', 'GBP', 0.121),
 ('CNY', 'TRY', 2.57),
 ('CNY', 'CNY', 1.0)
GO

INSERT INTO [KN303_Pechurin].Pechurin.account
	(id, currency, amount)
	VALUES
	(1, 'RUB', 34),
	(2, 'GBP', 101),
	(3, 'TRY', 300),
	(4, 'CNY', 1)
GO

--1)
--������� ��� ������ ������� �� ������������ ��������
CREATE FUNCTION show_balance ()
RETURNS TABLE AS
RETURN
	SELECT currency as 'Валюта',
		amount as 'Количество'
	FROM [KN303_Pechurin].Pechurin.account 
	GROUP BY currency, amount;
GO


--2)
CREATE PROCEDURE addCurrencyToAccount (@cur_name varchar(4), @cur_amount decimal(20,4))
AS
BEGIN

IF NOT EXISTS (SELECT * FROM [KN303_Pechurin].Pechurin.account 
                   WHERE currency = @cur_name)
   BEGIN
       INSERT INTO [KN303_Pechurin].Pechurin.account (currency, amount)
       VALUES (@cur_name, @cur_amount)
   END

ELSE
BEGIN
UPDATE [KN303_Pechurin].Pechurin.account
	SET amount = amount + @cur_amount
	WHERE currency = @cur_name
END

END
GO


EXEC addCurrencyToAccount 'RUB', 300.0
SELECT * FROM show_balance();
GO


--3)
CREATE PROCEDURE spendMoney (@cur_name varchar(4), @cur_amount decimal(20,4))
AS
BEGIN

DECLARE @current_balance decimal(20,4)
SET @current_balance = (SELECT amount FROM [KN303_Pechurin].Pechurin.account WHERE currency = @cur_name)

IF @current_balance < @cur_amount
BEGIN
	 PRINT 'Средств недостаточно.'
END

ELSE 
BEGIN 
	UPDATE [KN303_Pechurin].Pechurin.account
	SET amount = amount - @cur_amount
	WHERE currency = @cur_name
END

SET @current_balance = (SELECT amount FROM [KN303_Pechurin].Pechurin.account WHERE currency = @cur_name) 
IF @current_balance = 0
BEGIN
DELETE FROM [KN303_Pechurin].Pechurin.account WHERE currency = @cur_name
END

END
GO

EXEC spendMoney 'RUB', 14
SELECT * FROM show_balance();
GO

--4)
CREATE PROCEDURE convertMoney (@src_name varchar(4), @dst_name varchar(4), @cur_amount decimal(20,4))
AS 
BEGIN
DECLARE @current_src_balance DECIMAL(20,4)
DECLARE @current_rate DECIMAL(20,4)
SET @current_src_balance = (SELECT amount FROM [KN303_Pechurin].Pechurin.account WHERE currency = @src_name)
SET @current_rate = (SELECT rate FROM [KN303_Pechurin].Pechurin.exchange_rate WHERE src = @src_name AND dst = @dst_name)


IF @current_src_balance < @cur_amount
BEGIN
	 PRINT 'Средств недостаточно.'
END

ELSE 
BEGIN 
	UPDATE [KN303_Pechurin].Pechurin.account
	SET amount = amount - @cur_amount
	WHERE currency = @src_name

	UPDATE [KN303_Pechurin].[Pechurin].account
	SET amount = amount + @cur_amount * @current_rate
	WHERE currency = @dst_name
END

SET @current_src_balance = (SELECT amount FROM [KN303_Pechurin].Pechurin.account WHERE currency = @src_name) 
IF @current_src_balance = 0
BEGIN
DELETE FROM [KN303_Pechurin].Pechurin.account WHERE currency = @src_name
END

END
GO

EXEC convertMoney 'RUB', 'GBP', 10
SELECT * FROM show_balance();
GO

--5)
CREATE PROCEDURE showBalanceInOneCurrency(@cur_name varchar(4))
AS 
BEGIN

DECLARE @totalSum DECIMAL(20,4)
SET @totalSum = 0


declare @idRow INT
select @idRow = min(id) from [KN303_Pechurin].Pechurin.account
declare @current_amount DECIMAL(20,4)


while @idRow is not null
begin
	set @current_amount = (SELECT amount FROM [KN303_Pechurin].Pechurin.account WHERE id = @idRow)
    SET @totalSum = @totalSum + 
					@current_amount * 
					(SELECT rate from [KN303_Pechurin].Pechurin.exchange_rate WHERE src = 
						(SELECT currency FROM [KN303_Pechurin].Pechurin.account WHERE amount = @current_amount AND id = @idRow) AND 
						dst = @cur_name)
    select @idRow = min(id) from [KN303_Pechurin].Pechurin.account where id > @idRow
end

PRINT 'Баланс карты: ' + CAST(@totalSum AS VARCHAR) + @cur_name

END
GO

EXEC showBalanceInOneCurrency 'RUB'
GO
SELECT * FROM show_balance();
GO



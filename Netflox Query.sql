--Soal 1
--Tampilkan Name yang merupakan gabungan First Name dan Last Name, CustAddress dengan format
--"Address, City" diurutkan dari customer dengan umur tertua (CONCAT, ORDER BY)
SELECT CONCAT(FirstName,' ', LastName) AS [Name], CONCAT([Address], ',' , City) AS CustAddress
FROM MsCustomer
ORDER BY DOB ASC
GO

--Soal 2
--Tampilkan Staff yang merupakan gabungan dari tiga digit terakhir StaffID dan LastName dengan
--format "ID - Last Name", Email, Gender dari staff yang Salarynya lebih dari 1,6 juta (RIGHT,
--CONCAT)
SELECT CONCAT(RIGHT(StaffID, 3), ' - ', LastName) AS Staff, Email, Gender
FROM MsStaff
WHERE Salary > 1600000
GO

--Soal 3
--Create View 'vw_Q3OrderList’ yang menampilkan Order ID, Customer Name, Order Date, Rental
--Duration dimana customer melakukan rental dari Juli hingga September 2021 dengan format Order
--Date dd-mm-yyyy (CREATE VIEW, CONVERT, DATEPART, BETWEEN, YEAR)

CREATE VIEW vw_Q3OrderList AS
SELECT tro.OrderID, CONCAT( mc.FirstName, ' ', mc.LastName) AS [Customer Name], CONVERT(VARCHAR(20), tro.OrderDate, 105) AS [Order Date], tod.RentalDuration
FROM TrOrder tro
JOIN MsCustomer mc ON tro.CustomerID = mc.CustomerID
JOIN TrOrderDetail tod ON tro.OrderID = tod.OrderID
WHERE DATEPART(YEAR, tro.OrderDate) = 2021 AND (DATEPART(MONTH, tro.OrderDate) BETWEEN 6 AND 9)
GO

SELECT * FROM vw_Q3OrderList

DROP VIEW vw_Q3OrderList
GO


--Soal 4
--Tampilkan Title Film yang terdiri dari 2 kata atau lebih, kemudian ganti kata kedua dan seterusnya
--dengan Genre dan tampilkan kolom Film Details yang berisi (Tahun Rilis : Director) untuk film yang
--dirilis di Region Europe (REPLACE, SUBSTRING, CHARINDEX, LEN, JOIN, CONVERT, YEAR, LIKE)
SELECT REPLACE(Title, SUBSTRING(Title, CHARINDEX(' ', Title)+1, LEN(Title)-CHARINDEX(' ', Title)), GenreName) AS Title, 
CONCAT(SUBSTRING(CONVERT(VARCHAR(20), YEAR(ReleaseDate)), 1, 4), ' : ', Director) AS [Film Details]

FROM MsFilms mf
JOIN MsGenre mg ON mf.GenreID = mg.GenreID
JOIN MsRegion mr ON mf.RegionID = mr.RegionID
WHERE Title LIKE '% %' AND RegionName = 'Europe'
GO


--Soal 5
--Tampilkan Customer Name dengan di depan kata Mr untuk gender M dan Ms untuk gender
--perempuan, Order Date dengan format dd-mm-yyyy, dan judul film yang dirental untuk transaksi yang
--menggunakan metode pembayaran E-Wallet (CASE WHEN, CONVERT, JOIN)
SELECT  
CASE
	WHEN Gender like 'M' THEN CONCAT('Mr. ', FirstName, ' ', LastName) 
	WHEN Gender like 'F' THEN CONCAT('Ms. ', FirstName, ' ', LastName) 
END AS [Customer Name], CONVERT(VARCHAR(20), tro.OrderDate, 105) AS [Order Date], Title
FROM TrOrder tro
JOIN MsCustomer mc ON tro.CustomerID = mc.CustomerID
JOIN MsPayment mp ON tro.PaymentMethodID = mp.PaymentMethodID
JOIN TrOrderDetail tod ON tro.OrderID = tod.OrderID
JOIN MsFilms mf ON tod.FilmID = mf.FilmID
WHERE PaymentMethodName LIKE 'E-Wallet'
GO


--Soal 6 
--Tampilkan kelompok Gender dari Staff, kemudian hitung jumlah salary dari masing-masing kelompok
--Gender (CASE WHEN, CAST, SUM, GROUP BY)
SELECT
CASE 
	WHEN Gender = 'F' THEN 'Female Staff'
	WHEN Gender = 'M' THEN  'Male Staff'
END AS Gender, 'Rp. ' + CAST(SUM(Salary) AS VARCHAR) + ',-' AS [Total Salary]
FROM MsStaff
GROUP BY Gender
GO


--Soal 7
--Tampilkan Title Film di awali dengan 2 huruf pertama dari namaRegion, Synopsis 
--di awali kata terakhir dari Director, dan Release Date dimana Film tersebut bergenre 
--Horror (LEFT, REVERSE,SUBSTRING,CHARINDEX)
SELECT CONCAT(LEFT(RegionName, 2), ' ', Title) AS Title, 
CONCAT(REVERSE(SUBSTRING(REVERSE(Director), 1 , CHARINDEX(' ', REVERSE(DIRECTOR)))), ' ', Synopsis), ReleaseDate
FROM MsFilms mf
JOIN MsRegion mr ON mf.RegionID = mr.RegionID
WHERE GenreID LIKE 'MG002'
GO


--Soal 8
--Tampilkan Customer Name dengan huruf kecil semua, dan hitung berapa kali customer melakukan order, 
--dan jumlah total film yang diorder lalu urutkan customer dari yang paling sedikit melakukan order rental film 
--dimana transaksi di lakukan di Februari 2021 -Desember 2021 (LOWER, COUNT, DISTINCT, MONTH, BETWEEN, YEAR, GROUP BY, ORDER BY)
SELECT LOWER(CONCAT(mc.FirstName, ' ', mc.LastName)) AS [Customer Name], 
COUNT(DISTINCT(tro.OrderID)) AS [Order Count], COUNT(tod.FilmID) AS [Film Count]
FROM TrOrder tro
JOIN MsCustomer mc ON tro.CustomerID = mc.CustomerID
JOIN TrOrderDetail tod ON tro.OrderID = tod.OrderID
WHERE YEAR(OrderDate) = 2021 AND MONTH(OrderDate) BETWEEN '2' AND '12' 
GROUP BY FirstName, LastName
ORDER BY [Film Count] ASC
GO


--Soal 9
--Tampilkan Customer Name,Jam Order dengan diakhiri dengan AM dan PM 
--dan Total Rental Duration dimana ordernya dilayani oleh staff dengan nama akhir Sitorus atau Haryanti (CONVERT, CAST, SUM, IN)
SELECT CONCAT(mc.FirstName, ' ', mc.LastName) AS [Customer Name], 
CONVERT(VARCHAR, CAST(OrderDate AS TIME), 0) AS [Customer Order Time], SUM(RentalDuration) AS [Total Rental Duration] 
FROM TrOrder tro
JOIN MsCustomer mc On tro.CustomerID = mc.CustomerID
JOIN MsStaff ms On tro.StaffID = ms.StaffID
JOIN TrOrderDetail tod On tro.OrderID = tod.OrderID
WHERE ms.LastName IN ('Sitorus', 'Haryanti')
GROUP BY mc.FirstName, mc.LastName, tro.OrderDate
GO


--Soal 10
--Tampilkan Customer Name, Customer Gender denganreturn Male dan Female, 
--total order yang dilakukan customer, dan hitung rata rata durasi rental customer dimana Film tersebut diproduksi di 
--Region Asia, Africa dan America dan Staff yang melayani transaksi memiliki nama belakang Nuraini (CASE WHEN, COUNT,AVG, IN)
SELECT  CONCAT(mc.FirstName, ' ', mc.LastName) AS [Customer Name], 
CASE 
	WHEN mc.Gender = 'F' THEN 'Female'
	WHEN mc.Gender = 'M' THEN 'Male'
END AS [Customer Gender], COUNT(DISTINCT(tro.OrderID)) AS [Total Order Count], AVG(tod.RentalDuration) AS [Average Rental Duration]
FROM TrOrder tro
JOIN MsCustomer mc ON tro.CustomerID = mc.CustomerID
JOIN TrOrderDetail tod  ON tro.OrderID = tod.OrderID
JOIN MsFilms mf ON tod.FilmID = mf.FilmID
JOIN MsRegion mr ON mf.RegionID = mr.RegionID
JOIN MsStaff ms ON tro.StaffID = ms.StaffID
WHERE ms.LastName LIKE ('Nuraini') AND RegionName IN ('Asia', 'Africa', 'America')
GROUP BY mc.Gender, mc.FirstName, mc.LastName
GO


--Soal 11
--Buatlah Stored Procedure "GetTopFiveFilms" untuk menampilkan Title, Synopsis, dan 
--durasi peminjamandari lima Film yang pernah dirental Customer dengan durasi rental terlama. 
--Jika durasi rental sama, diurutkan dari Title secara abjad.
CREATE PROCEDURE GetTopFiveFilms AS
SELECT TOP (5) Title, Synopsis, RentalDuration
FROM TrOrder tro
JOIN TrOrderDetail tod ON tro.OrderID = tod.OrderID
JOIN MsFilms mf ON tod.FilmID = mf.FilmID
ORDER BY RentalDuration DESC, Title ASC
GO

EXECUTE GetTopFiveFilms 
GO

DROP PROCEDURE GetTopFiveFilms 
GO


--Soal 12
--Buatlah Stored Procedure "GetYearTotalFilm" untuk menampilkan tahun 
--beserta jumlah film berbeda yang diorder di tahun tersebut, diurutkan dari tahun terlama.
CREATE PROCEDURE GetYearTotalFilm AS
SELECT YEAR(OrderDate) AS FilmYear, COUNT(*) AS CountData
FROM TrOrder 
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate) ASC
GO

EXECUTE GetYearTotalFilm 
GO

DROP PROCEDURE GetYearTotalFilm 
GO


--Soal 13
--Buatlah Stored Procedure "GetOrderByCustomer <CustomerId>" untuk menampilkan data order dengan parameter CustomerId 
--dengan output OrderId, OrderDate, CustomerName = (FirstName + LastName), Film Title, Rental Duration GetOrderById 'MC001'
CREATE PROCEDURE GetOrderByCustomer
@CustomerID VARCHAR(10) AS
SELECT tro.OrderID , OrderDate, CONCAT(FirstName, ' ', LastName) AS CustomerName, Title, RentalDuration
FROM TrOrder tro
JOIN MsCustomer mc ON tro.CustomerID = mc.CustomerID
JOIN TrOrderDetail tod ON tro.OrderID = tod.OrderID
JOIN MsFilms mf ON tod.FilmID = mf.FilmID
WHERE mc.CustomerID = @CustomerID
GO

EXECUTE GetOrderByCustomer 'MC001' 
GO

DROP PROCEDURE GetOrderByCustomer 
GO


--Soal 14
--Buatlah Stored Procedure "GetFilm <RegionName,GenreName?>" untuk menampilkan data film sudah di order 
--dengan parameter Region Name (Wajib) dan Genre Name (Optional) dan 
--jika parameter Genre Name kosong akan menampilkan semua Genre 
--dengan output Film Title, Genre Name, Release Date, Synopsis, dan Director.
--GetFilm ‘Asia’,’Horror’
--GetFilm‘Asia’,’’
CREATE PROCEDURE GetFilm 
@RegionName VARCHAR(100), @GenreName VARCHAR(100) = NULL AS

BEGIN

IF(@GenreName = NULL OR LEN(@GenreName) <1)
	SELECT Title, GenreName, ReleaseDate, Synopsis, Director
	FROM MsFilms mf
	JOIN MsGenre mg ON mf.GenreID = mg.GenreID
	JOIN MsRegion mr on mf.RegionID = mr.RegionID
	WHERE RegionName = @RegionName
	ORDER BY ReleaseDate DESC

ELSE IF (LEN(@GenreName) >= 1)
	SELECT Title, GenreName, ReleaseDate, Synopsis, Director
	FROM MsFilms mf
	JOIN MsGenre mg ON mf.GenreID = mg.GenreID
	JOIN MsRegion mr on mf.RegionID = mr.RegionID
	WHERE RegionName = @RegionName AND GenreName = @GenreName
	ORDER BY ReleaseDate DESC

END

EXECUTE  GetFilm 'Asia', 'Horror' 
GO
EXECUTE GetFilm 'Asia', '' 
GO

DROP PROCEDURE GetFilm 
GO


--Soal 15
--Buatlah Stored Procedure "GetOrderByCode <OrderId | OrderDetailId>" untuk menampilkan data order 
--dengan parameter OrderId atau OrderDetailId dengan output OrderId, OrderDate, Film Title, Release Detail 
--yang terdiri dari (tahun rilis :Director), dan durasi rental. 
--Gunakan dynamic query (optional)GetOrderByCode 'TO002'GetOrderByCode 'OD004'
CREATE PROCEDURE GetOrderByCode
@Input VARCHAR (10)
AS
DECLARE @sql VARCHAR (1000)

SET @sql = 'SELECT tod.OrderID, OrderDate, mf.Title, CONCAT(YEAR(ReleaseDate), '' : '', Director) AS [Release Detail], RentalDuration
FROM TrOrder tro
JOIN TrOrderDetail tod ON tro.OrderID = tod.OrderID
JOIN MsFilms mf ON tod.FilmID = mf.FilmID'

IF(LEFT(@Input, 2) = 'TO')
	SET @sql = @sql + ' WHERE tro.OrderId = ''' + @Input + ''''
ELSE IF(LEFT(@Input, 2) = 'OD')
	SET @sql = @sql + ' WHERE tod.OrderDetailId = ''' + @Input + ''''

EXEC(@sql)

GO



EXECUTE GetOrderByCode 'TO002'
GO
EXECUTE GetOrderByCode 'OD004' 
GO

DROP PROCEDURE GetOrderByCode 
GO


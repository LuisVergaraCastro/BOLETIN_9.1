--Boletin 9.1
--Escribe las siguientes consultas sobre la base de datos NorthWind.
USE Northwind
--1.Nombre de los proveedores y n�mero de productos que nos vende cada uno
SELECT * FROM Suppliers
SELECT S.CompanyName, COUNT(P.ProductID) AS [N� DE PRODUCTOS] FROM Suppliers AS S INNER JOIN Products AS P ON S.SupplierID = P.SupplierID GROUP BY S.CompanyName
--2.Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
SELECT * FROM Employees
SELECT CONCAT(FirstName, ' ',LastName) AS [NOMBRE COMPLETO], HomePhone FROM Employees WHERE City LIKE 'New York' OR City LIKE 'Seattle' OR City LIKE 'Vermont' OR City LIKE 'Columbia' OR City LIKE 'Los Angeles' OR City LIKE 'Redmond' OR City LIKE 'Atlanta'  
--3.N�mero de productos de cada categor�a y nombre de la categor�a.
SELECT C.CategoryName, COUNT(P.ProductID) AS [N� PRODUCTOS] FROM Categories AS C INNER JOIN Products AS P ON C.CategoryID = P.CategoryID GROUP BY C.CategoryName
--4.Nombre de la compa��a de todos los clientes que hayan comprado queso de cabrales o tofu.
SELECT * FROM Customers
SELECT DISTINCT C.CompanyName 
FROM Customers AS C INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
					INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
					INNER JOIN Products AS P ON OD.ProductID = P.ProductID
WHERE P.ProductName IN ('queso cabrales', 'tofu')
--5.Empleados (ID, nombre, apellidos y tel�fono) que han vendido algo a Bon app' o Meter Franken.
SELECT * FROM Employees
SELECT * FROM Orders
SELECT E.EmployeeID, E.FirstName, E.LastName, E.HomePhone FROM Employees AS E INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID WHERE ShipName IN ('Bon app''','Meter Franken')
--6.Empleados (ID, nombre, apellidos, mes y d�a de su cumplea�os) que no han vendido nunca nada a ning�n cliente de Portugal. *
SELECT E.EmployeeID, E.FirstName, E.LastName, MONTH(BirthDate) AS MONTH, DAY(BirthDate) AS DAY_OF_BIRTH 
FROM Employees AS E 
WHERE EmployeeID NOT IN (SELECT DISTINCT E.EmployeeID
							FROM Employees AS E
							RIGHT JOIN Orders AS O
							ON E.EmployeeID = O.EmployeeID
							RIGHT JOIN Customers AS C
							ON O.CustomerID = C.CustomerID
							WHERE C.Country LIKE 'Portugal')
--7.Total de ventas en US$ de productos de cada categor�a (nombre de la categor�a).
SELECT C.CategoryName, SUM(OD.UnitPrice * OD.Quantity) AS [TOTAL DE VENTAS EN US$]
FROM Categories AS C INNER JOIN Products AS P ON C.CategoryID = P.CategoryID
					 INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
GROUP BY C.CategoryName
--8.Total de ventas en US$ de cada empleado cada a�o (nombre, apellidos, direcci�n).
SELECT E.FirstName, E.LastName, E.Address, SUM(OD.UnitPrice * OD.Quantity)AS [TOTAL DE VENTAS EN US$], YEAR(O.OrderDate) AS YEAR  FROM Employees AS E INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID GROUP BY E.FirstName, E.LastName, E.Address, YEAR(O.OrderDate)
--9.Ventas de cada producto en el a�o 97. Nombre del producto y unidades.
SELECT * FROM Products
SELECT P.ProductID, P.ProductName, P.QuantityPerUnit, SUM(OD.UnitPrice * OD.Quantity)AS [VENTAS], YEAR(O.OrderDate) AS YEAR
FROM Orders AS O INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
				 INNER JOIN Products AS P ON OD.ProductID = P.ProductID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY  P.ProductID, P.ProductName, P.QuantityPerUnit, YEAR(O.OrderDate)
--10.Cu�l es el producto del que hemos vendido m�s unidades en cada pa�s. *
CREATE OR ALTER TABLE [VENTAS POR PAIS] AS
SELECT P.ProductName, C.City
FROM Products AS P INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
				   INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
				   INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
GROUP BY P.ProductName, C.City

SELECT [VentasTotales] AS Maximo
--En esta consulta utilizar� la vista anterior para elegir el m�ximo de ventas por pais 
Select [Ventas totales] as Maximo,
		VA.ProductName,
		--Como en 'Max' solo est� una vez cada pais
		--Esto nos asegurar� el funcionamiento correcto de la consulta
		Max.Country
		--Aqu� llamo a la vista creada anteriormente 
from [Ventas por pais] as VA
--Relaciono la vista de ventas por cada pais consigo misma,
--pero en el segundo caso solo cojo el m�ximo y el pa�s
--ya que si no habr�a varios paises o productos repetidos
inner Join (
Select max ([ventas totales]) as Maximo
		,Country
from [Ventas por pais]
group by Country) as Max
On VA.[ventas totales] = Max.Maximo and VA.Country = Max.Country
Order By Country
--11.Empleados (nombre y apellidos) que trabajan a las �rdenes de Andrew Fuller.
Select E.FirstName, E.LastName
From Employees as E INNER JOIN Employees as EM ON E.ReportsTo = EM.EmployeeID
WHERE EM.FirstName = 'Andrew' AND EM.LastName = 'Fuller'
--12.N�mero de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.
SELECT EM.FirstName, EM.LastName, COUNT(E.EmployeeID) AS employees
FROM Employees AS E INNER JOIN Employees AS EM ON E.ReportsTo = EM.EmployeeID
GROUP BY EM.FirstName, EM.LastName
--* Se necesitan subconsultas
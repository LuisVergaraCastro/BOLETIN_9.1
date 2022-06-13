--Boletin 9.1
--Escribe las siguientes consultas sobre la base de datos NorthWind.
USE Northwind
--1.Nombre de los proveedores y número de productos que nos vende cada uno
SELECT * FROM Suppliers
SELECT S.CompanyName, COUNT(P.ProductID) AS [Nº DE PRODUCTOS] FROM Suppliers AS S INNER JOIN Products AS P ON S.SupplierID = P.SupplierID GROUP BY S.CompanyName
--2.Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
SELECT * FROM Employees
SELECT CONCAT(FirstName, ' ',LastName) AS [NOMBRE COMPLETO], HomePhone FROM Employees WHERE City LIKE 'New York' OR City LIKE 'Seattle' OR City LIKE 'Vermont' OR City LIKE 'Columbia' OR City LIKE 'Los Angeles' OR City LIKE 'Redmond' OR City LIKE 'Atlanta'  
--3.Número de productos de cada categoría y nombre de la categoría.
SELECT C.CategoryName, COUNT(P.ProductID) AS [Nº PRODUCTOS] FROM Categories AS C INNER JOIN Products AS P ON C.CategoryID = P.CategoryID GROUP BY C.CategoryName
--4.Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.
SELECT * FROM Customers
SELECT DISTINCT C.CompanyName 
FROM Customers AS C INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
					INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
					INNER JOIN Products AS P ON OD.ProductID = P.ProductID
WHERE P.ProductName IN ('queso cabrales', 'tofu')
--5.Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.
SELECT * FROM Employees
SELECT * FROM Orders
SELECT E.EmployeeID, E.FirstName, E.LastName, E.HomePhone FROM Employees AS E INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID WHERE ShipName IN ('Bon app''','Meter Franken')
--6.Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada a ningún cliente de Portugal. *
SELECT E.EmployeeID, E.FirstName, E.LastName, MONTH(BirthDate) AS MONTH, DAY(BirthDate) AS DAY_OF_BIRTH 
FROM Employees AS E 
WHERE EmployeeID NOT IN (SELECT DISTINCT E.EmployeeID
							FROM Employees AS E
							RIGHT JOIN Orders AS O
							ON E.EmployeeID = O.EmployeeID
							RIGHT JOIN Customers AS C
							ON O.CustomerID = C.CustomerID
							WHERE C.Country LIKE 'Portugal')
--7.Total de ventas en US$ de productos de cada categoría (nombre de la categoría).

--8.Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).

--9.Ventas de cada producto en el año 97. Nombre del producto y unidades.

--10.Cuál es el producto del que hemos vendido más unidades en cada país. *

--11.Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.

--12.Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.

--* Se necesitan subconsultas
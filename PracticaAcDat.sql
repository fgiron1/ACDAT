
-- Almacenes
CREATE DATABASE AlmacenesLeo
GO
USE AlmacenesLeo
GO
-- Almacenes que contienen los envíos
CREATE TABLE Almacenes (
    ID Int NOT NULL CONSTRAINT PK_Almacenes Primary Key
    ,Denominacion NVarChar (30) Not NULL
    ,Direccion NVarChar (50) Not NULL
    ,Capacidad BigInt Not NULL
)
GO
-- Distancias a las que se encuentran los almacenes
CREATE TABLE Distancias (
    IDAlmacen1 Int NOT NULL
    ,IDAlmacen2 Int NOT NULL
    ,Distancia Int NOT NULL
    ,CONSTRAINT PK_Distancias Primary Key (IDAlmacen1, IDAlmacen2)
    ,CONSTRAINT FK_DistanciaAlmacen1 Foreign KEy (IDAlmacen1) REFERENCES Almacenes (ID)
	,CONSTRAINT FK_DistanciaAlmacen2 Foreign Key (IDAlmacen2) REFERENCES Almacenes (ID)
	,CONSTRAINT CKDistintosyNoRepes CHECK (IDAlmacen1 < IDAlmacen2)
)
-- Lotes de contenedores que se reciben y han de ser almacenados
CREATE TABLE Envios (
    ID BigInt NOT NULL CONSTRAINT PK_Envios Primary Key
    ,NumeroContenedores Int Not NULL DEFAULT 1
    ,FechaCreacion DATE NOT NULL
    ,FechaAsignacion DATE NULL
    ,AlmacenPreferido Int NOT NULL
)
GO
-- Envíos que ya han sido asignados a algún almacén
CREATE TABLE Asignaciones (
	IDEnvio BigInt NOT NULL CONSTRAINT PK_Asignaciones Primary Key
	,IDAlmacen Int NOT NULL
	,CONSTRAINT FK_AsignacionEnvio Foreign Key (IDEnvio) REFERENCES Envios (ID)
	,CONSTRAINT FK_AsignacionAlmacen Foreign Key (IDAlmacen) REFERENCES Almacenes (ID)
)
GO
-- Esta vista contiene las distancias entre cualquier pareja de almacenes en un sentido y en el inverso
Create View DistanciasTotales AS 
Select IDAlmacen1 AS ADA1, IDAlmacen2 AS IDA2 , Distancia FROM Distancias AS D1
UNION
Select IDAlmacen2 AS ADA1, IDAlmacen1 AS IDA2 , Distancia FROM Distancias AS D2

GO
INSERT INTO Almacenes (ID,Denominacion,Direccion,Capacidad)
     VALUES (1,'Nave de Manuela','C/Hierro, 27 Sevilla',400)
	 ,(2,'PaquePluf','C/Econom�a, 30 Sevilla',250)
	 ,(10,'PaquePluf','C/Serranito, 22 Huelva',450)
	 ,(20,'Storing','C/Torremolinos, 41 M�laga',1500)
	 ,(30,'PaquetEnteres','C/Caballa, 75 C�diz',500)
GO
INSERT INTO Distancias (IDAlmacen1,IDAlmacen2,Distancia)
     VALUES (1,2,7)
	 ,(1,10,100)
	 ,(1,20,250)
	 ,(1,30,140)
	 ,(2,10,105)
	 ,(2,20,256)
	 ,(2,30,143)
	 ,(10,20,340)
	 ,(10,30,235)
	 ,(20,30,196)
SET dateformat 'ymd'
GO

INSERT INTO Envios (ID,NumeroContenedores,FechaCreacion,FechaAsignacion,AlmacenPreferido)
     VALUES	(0,16,'20181102','20181106',1)
		,(1,17,'20180502','20181106',1)
		,(2,25,'20180624','20181106',1)
		,(3,117,'20180602','20181106',1)
		,(4,11,'20180507','20181106',1)
		,(5,130,'20180924',NULL,1)
		,(6,46,'20181012',NULL,1)
		,(7,18,'20180714',NULL,1)
		,(8,20,'20180921',NULL,1)
		,(9,34,'20180602',NULL,1)
		,(10,16,'20181102',NULL,1)
		,(11,50,'20180502',NULL,2)
		,(12,25,'20180624',NULL,2)
		,(13,59,'20180802',NULL,2)
		,(14,22,'20180507',NULL,1)
		,(15,31,'20180924',NULL,1)
		,(16,143,'20181012','20181106',2)
		,(17,86,'20180714','20181106',1)
		,(18,120,'20180921',NULL,1)
		,(19,91,'20180602',NULL,1)
		,(20,86,'20181102','20181106',10)
		,(21,150,'20180502',NULL,10)
		,(22,205,'20180624',NULL,10)
		,(23,57,'20180602',NULL,10)
		,(24,41,'20180507','20181106',10)
		,(25,130,'20180924',NULL,20)
		,(26,146,'20181012',NULL,20)
		,(27,18,'20180714',NULL,20)
		,(28,220,'20180921','20181106',20)
		,(29,34,'20180602',NULL,20)
		,(30,16,'20181102',NULL,10)
		,(31,17,'20180502','20181106',30)
		,(32,25,'20180624',NULL,30)
		,(33,17,'20180602','20181106',30)
		,(34,91,'20180507',NULL,20)
		,(35,30,'20180924',NULL,20)
		,(36,246,'20181012','20181106',20)
		,(37,148,'20180714',NULL,30)
		,(38,204,'20180921','20181106',30)
		,(39,74,'20180602',NULL,20)
GO

INSERT INTO Asignaciones (IDEnvio,IDAlmacen)
     VALUES (0,1),(1,1),(2,1),(3,1),(4,10),(16,2),(17,2)
	 ,(20,10),(24,10),(28,20),(31,30),(33,30),(36,20),(38,30)
GO


-- Comprobar la capacidad libre de cada almac�n

SELECT A.ID, A.Capacidad, Sum(E.NumeroContenedores) AS Ocupado, A.Capacidad - Sum(E.NumeroContenedores) AS disponible From Almacenes AS A 
	Inner Join Asignaciones As Ag ON A.ID = Ag.IDAlmacen
	Inner Join Envios AS E ON Ag.IDEnvio = E.ID
	Group By A.ID, A.Capacidad


CREATE LOGIN prueba
WITH PASSWORD = '123';  
GO  

CREATE USER prueba FOR LOGIN prueba;  
GO  

ALTER ROLE db_datareader ADD MEMBER prueba; 
ALTER ROLE db_datawriter ADD MEMBER prueba; 
ALTER ROLE db_owner ADD MEMBER prueba; 

-- A HACER --
--El ejercicio me pide tambien que lidie con las filas que tienen ya el valor de fecha de asignación en null
-- A HACER --



-----------Funcionamiento-----------
--Este trigger es activado al insertar una nueva fila en la tabla Asignaciones.
--Se encarga de comprobar si el pedido que se pretende insertar puede ser enviado al almacen
--que tambien se quiere insertar (NO al almacén preferido del envío). De no ser así, lanza una excepción
------------------------------------

GO
CREATE TRIGGER ComprobarEspacio
ON Asignaciones
INSTEAD OF INSERT
AS
BEGIN
	
	DECLARE @IDEnvio bigint
	DECLARE @FechaAsignacion date
	DECLARE @IDAlmacen bigint

	--Almacenamos los datos necesarios
	SELECT @IDEnvio = IDEnvio,
	       @IDAlmacen = IDAlmacen
	FROM inserted

	SELECT @FechaAsignacion = FechaAsignacion
	FROM Envios
	WHERE ID = @IDEnvio

	--Comprobamos que no se haya asignado ningun almacen aun
	IF(@FechaAsignacion IS NULL)
	--Comprobamos si en el almacen preferido hay suficiente espacio para el envio
	--Sintaxis redundante, pero SQL no me deja poner la funcion sola
		IF(dbo.FNHayEspacio(@IDEnvio, @IDAlmacen) = 1)
			BEGIN
				--Se actualiza el envio como asignado
				UPDATE Envios
				SET FechaAsignacion = CURRENT_TIMESTAMP
				WHERE ID = @IDEnvio

				--Se inserta una nueva fila en la tabla asignaciones
				INSERT INTO Asignaciones(IDEnvio, IDAlmacen)
				SELECT I.IDEnvio, I.IDAlmacen
				FROM inserted I
			END
		ELSE
			RAISERROR(N'No hay suficiente espacio en el almacen', 16, 1)
				
END;
GO

----------Interfaz----------
--Prototipo: FNHayEspacio(@IDEnvio bigint, @IDAlmacen bigint)
--
--Entradas: El id de un envío (bigint) y el id de un almacén (bigint)
--
--Salidas: Un tipo bit que expresa si en el almacen pasado por parametros
--hay espacio para el envío pasado por parametros
--
--Precondiciones: Todos los id han de estar validados
--
--Postcondiciones: -
--
--Otros: -
----------------------------
GO
CREATE FUNCTION FNHayEspacio(@IDEnvio bigint, @IDAlmacen bigint)
RETURNS bit
AS
BEGIN
	
	DECLARE @NumeroContenedores int
	DECLARE @capacidadRestante int
	DECLARE @resultado bit

	--Los envios cuyo almacen de destino ya estan asignado figuran en la tabla Asignaciones
	--Es decir, si figura en la tabla Asignaciones, no debe de tener su campo FechaAsignacion a NULL
	--(Este trigger lo garantiza)

	--Calculamos la cantidad de contenedores que ocupan los envios que esten asignados a @IDAlmacen (cuyas ID figuren en Asignaciones). 
	SELECT @NumeroContenedores = SUM(NumeroContenedores)
	FROM Asignaciones
	INNER JOIN Envios ON IDEnvio = ID
	WHERE IDAlmacen = @IDAlmacen

	--Se le ha de sumar la cantidad de contenedores que incluye el pedido a almacenar
	SELECT @NumeroContenedores = @NumeroContenedores + NumeroContenedores
	FROM Envios
	WHERE ID = @IDEnvio
	
	SELECT @capacidadRestante = (Capacidad - @NumeroContenedores) FROM Almacenes
	WHERE ID = @IDAlmacen

	IF(@capacidadRestante >= 0)
		SET	@resultado = 1
	ELSE
		SET @resultado = 0

	RETURN @resultado

END
GO

------Interfaz------
--Prototipo: FNAlmacenMasCercaDisponible(@IDAlmacen bigint, @IDEnvio bigint)
--
--Entradas: El id de un almacén (bigint) y el id de un envío (bigint)
--
--Salidas: Una variable tipo tabla que contiene los almacenes que tienen
--espacio para guardar un envio de ID @IDEnvio, además de la distancia hacia ellos
--desde el almacen de ID @IDAlmacen
--
--Precondiciones: Todos los id han de estar validados
--
--Postcondiciones: La variable tipo tabla devuelta NO esta ordenada
--
--Otros: El almacen cuya ID se pasa por parametros suele ser el almacen preferido
--de un paquete, que por algun motivo necesita ser enviado a otro almacén
--------------------
GO
CREATE FUNCTION FNAlmacenMasCercaDisponible(@IDAlmacen bigint, @IDEnvio bigint)
RETURNS @almacenesDistancia TABLE
(
	IDAlmacen bigint NOT NULL,
	Distancia int NOT NULL
)
AS
BEGIN

	--Todas las distancias entre un almacen en particular a otro cualquiera
	--no estan expresadas de la forma: distancia de IDAlmacen1 a IDAlmacen2.
	--Una parte sí, pero otras son de la forma: distancia de IDAlmacen2 a IDAlmacen1.
	--Por ello, hay unas comprobaciones adicionales.
	
	--Ordenamos la subconsulta por la distancia y almacenamos el ID del almacen
	--más cercano al preferido
	INSERT INTO @almacenesDistancia
	SELECT
			--Este CASE nos permite diferenciar entre el ID del almacen pasado por parametros
			--y el id de otro almacen
			 (CASE sub1.IDAlmacen1 
					WHEN @IDAlmacen THEN sub1.IDAlmacen2
					ELSE sub1.IDAlmacen1
			 END) AS IDAlmacen,
			 sub1.Distancia
		FROM
		--Esta consulta devuelve las distancias entre los almacenes
		--que tienen espacio para almacenar un envio dado cuya id es @IDEnvio
		(SELECT IDAlmacen1, IDAlmacen2, Distancia FROM Distancias
			WHERE (IDAlmacen1 = @IDAlmacen OR
					  IDAlmacen2 = @IDAlmacen) AND
					  --Tengo que ver si las llamadas a la funcion se hacen por cada fila o solo la primera, que pasa mucho
					  (dbo.FNHayEspacio(@IDEnvio, IDAlmacen1) = 1 OR
					  dbo.FNHayEspacio(@IDEnvio, IDAlmacen2) = 1)) sub1

	RETURN

END
GO

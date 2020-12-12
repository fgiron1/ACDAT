

-- A HACER --
--El ejercicio me pide tambien que lidie con las filas que tienen ya el valor de fecha de asignación en null
-- A HACER --



-----------Funcionamiento-----------
--Este trigger es activado al insertar una nueva fila en la tabla Asignaciones.
--Se encarga de comprobar si el pedido que se pretende insertar puede ser enviado al almacen
--que tambien se quiere insertar (NO al almacén preferido del envío). De no ser así, lanza una excepción
------------------------------------

GO
CREATE OR ALTER TRIGGER ComprobarEspacio
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
CREATE OR ALTER FUNCTION FNHayEspacio(@IDEnvio bigint, @IDAlmacen bigint)
RETURNS bit
AS
BEGIN
	
	DECLARE @NumeroContenedores int
	DECLARE @capacidadRestante int
	DECLARE @resultado bit

	--Los envios cuyo almacen de destino ya estan asignado figuran en la tabla Asignaciones
	--Es decir, si figura en la tabla Asignaciones, no debe de tener su campo FechaAsignacion a NULL
	--(Este trigger lo garantiza)

	--Calculamos la cantidad de contenedores que ocupan los envios que esten asignados a @IDAlmacen (cuyas ID figuren en Asignaciones)
	SELECT @NumeroContenedores = SUM(NumeroContenedores)
	FROM Asignaciones
	INNER JOIN Envios ON IDEnvio = ID
	WHERE IDAlmacen = @IDAlmacen

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
CREATE OR ALTER FUNCTION FNAlmacenMasCercaDisponible(@IDAlmacen bigint, @IDEnvio bigint)
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
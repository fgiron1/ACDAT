package Gestoras;

import Conexion.SqlServerConexion;

import java.sql.*;
import java.util.Scanner;

public class GestoraEnvios {

    /**
     * Muestra los envios sin asignar.
     */

    public void mostrarEnviosSinAsignar(){

        ResultSet envios = null;
        SqlServerConexion gesConexion = new SqlServerConexion();
        String selectSql = "SELECT ID, NumeroContenedores, FechaCreacion, FechaAsignacion, AlmacenPreferido FROM Envios WHERE FechaAsignacion IS NULL";
        Connection conexion = null;

        try{

            conexion = gesConexion.getConexion();
            Statement statement = conexion.createStatement();
            envios = statement.executeQuery(selectSql);

            while (envios.next()){

                System.out.print("ID: "+envios.getString(1));
                System.out.print(", Numero de contenedores: "+envios.getString(2));
                System.out.print(", Fecha de creacion: "+envios.getString(3));
                System.out.print(", Almacen preferido: "+envios.getString(5));
                System.out.println();

            }

        }
        catch (SQLException e) {
            System.out.println("Error, intentelo mas tarde.");
        }finally {
            gesConexion.closeConexion(conexion);
        }

    }

    /**
     * Lee y valida el ID de un envio sin asignar. Comprueba si el ID leido existe y no esta asignado.
     * @return Devuelve el ID de un envio.
     */

    public int leerYValidarEnvioSinAsignar(){

        ResultSet envios = null;
        SqlServerConexion gesConexion = new SqlServerConexion();
        int idLeido = -1;
        boolean correcto;
        Scanner scanner = new Scanner(System.in);
        String selectSql;

        try{

            Connection conexion = gesConexion.getConexion();
            Statement statement = conexion.createStatement();

            do{

                System.out.print("Inserta el id del envio que quiere asignar: ");
                idLeido = scanner.nextInt();

                selectSql = "SELECT ID, NumeroContenedores, FechaCreacion, FechaAsignacion, AlmacenPreferido FROM Envios WHERE FechaAsignacion IS NULL AND ID = "+idLeido;
                envios = statement.executeQuery(selectSql);

                correcto = envios.next();

            }while(!correcto);

            gesConexion.closeConexion(conexion);

        }
        catch (SQLException e) {
            System.out.println("Error, intentelo mas tarde.");
        }

        return idLeido;
    }

    /**
     * Consulta al usuario su desea asignar el envio a un almacen alternativo
     * @return Devuelve un booleano con la decisión.
     */

    @Deprecated
    public boolean consultarAsignarEnvioContenedorMasCercano(){

        boolean asignar;
        Scanner scanner = new Scanner(System.in);
        char caracter;

        System.out.println("");
        System.out.println("No se pudo asignar el envio a su contenedor preferido.");

        do {

            System.out.print("¿Desea buscar un contenedor alternativo cercano al preferido? Introduzca S o N: ");
            caracter = Character.toUpperCase(scanner.next().charAt(0));

        }while (caracter != 'S' && caracter != 'N');

        asignar = caracter == 'S';

        return asignar;
    }

    /**
     * Consulta al usuario si desea asignar el envio a un almacen alternativo. El id del almacen pasado debe existir.
     * @return Devuelve un booleano con la decisión.
     */

    public boolean consultarAsignarEnvioContenedorAlternativo(int idAlmacen){

        boolean asignar;
        Scanner scanner = new Scanner(System.in);
        char caracter;
        GestoraAlmacenes gesAlmacenes = new GestoraAlmacenes();

        String nombreAlmacen = gesAlmacenes.obtenerNombreDeAlmacen(idAlmacen);

        System.out.println("");
        System.out.println("No se pudo asignar el envio a su almacen preferido.");

        do {

            System.out.println("El almacen más cercano al preferido es el almacen "+nombreAlmacen+ " ¿Desea asignar en este almacen?");
            System.out.print("Introduzca S o N: ");
            caracter = Character.toUpperCase(scanner.next().charAt(0));

        }while (caracter != 'S' && caracter != 'N');

        asignar = caracter == 'S';

        return asignar;
    }

    /**
     * Devuelve el ID del contenedor preferido del envio con el id pasado por parametro. Devuelve -1 si no existe el envio con el ID pasado.
     * @return Devuelve el ID del contenedor preferido.
     */

    public int obtenerIDContenedorPreferidoDeEnvio(int idEnvio){

        int idContenedorPreferido = -1;
        ResultSet resultado = null;
        SqlServerConexion gesConexion = new SqlServerConexion();
        String selectSql = "SELECT AlmacenPreferido FROM Envios WHERE ID = "+idEnvio;
        Connection conexion = null;

        try{

            conexion = gesConexion.getConexion();
            Statement statement = conexion.createStatement();
            resultado = statement.executeQuery(selectSql);

            while (resultado.next()){

                idContenedorPreferido = resultado.getInt(1);

            }

            gesConexion.closeConexion(conexion);

        }
        catch (SQLException e) {
            System.out.println("Error, intentelo mas tarde.");
        }finally {
            gesConexion.closeConexion(conexion);
        }

        return idContenedorPreferido;

    }

}

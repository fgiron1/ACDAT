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

        try{

            Connection conexion = gesConexion.getConexion();
            Statement statement = conexion.createStatement();
            envios = statement.executeQuery(selectSql);

            while (envios.next()){

                System.out.print("ID: "+envios.getString(1));
                System.out.print(", Numero de contenedores: "+envios.getString(2));
                System.out.print(", Fecha de creacion: "+envios.getString(3));
                System.out.print(", Almacen preferido: "+envios.getString(5));
                System.out.println();

            }

            gesConexion.closeConexion(conexion);

        }
        catch (SQLException e) {
            System.out.println("Error, intentelo mas tarde.");
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
     * Asigna un contenedor al envio del ID pasado por parametro.
     */

    public void asignarContenedor(int ID){

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

    }


    public int obtenerIDContenedorPreferidoDeEnvio(int ID){

        int idContenedorPreferido = -1;
        ResultSet resultado = null;
        SqlServerConexion gesConexion = new SqlServerConexion();
        String selectSql = "SELECT AlmacenPreferido FROM Envios WHERE ID = "+ID;

        try{

            Connection conexion = gesConexion.getConexion();
            Statement statement = conexion.createStatement();
            resultado = statement.executeQuery(selectSql);

            while (resultado.next()){

                idContenedorPreferido = resultado.getInt(1);

            }

            gesConexion.closeConexion(conexion);

        }
        catch (SQLException e) {
            System.out.println("Error, intentelo mas tarde.");
        }

        return idContenedorPreferido;

    }





}

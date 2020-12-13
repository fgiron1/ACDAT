package Gestoras;

import Conexion.SqlServerConexion;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class GestoraAsignaciones {

    /**
     * Asigna un contenedor al envio del ID pasado por parametro.
     */

    public void asignarContenedor(int idEnvio){

        SqlServerConexion gesConexion = new SqlServerConexion();
        int idAlmacenPreferido = 0, idAlmacenAlternativo;
        String insertSQL;
        Connection conexion = null;
        GestoraEnvios gesEnvios = new GestoraEnvios();
        GestoraAlmacenes gesAlmacenes = new GestoraAlmacenes();

        try{

            conexion = gesConexion.getConexion();
            Statement statement = conexion.createStatement();
            idAlmacenPreferido = gesEnvios.obtenerIDContenedorPreferidoDeEnvio(idEnvio);
            insertSQL = "INSERT INTO Asignaciones(IDEnvio, IDAlmacen) VALUES ("+idEnvio+", "+idAlmacenPreferido+")";
            statement.execute(insertSQL);
            System.out.println("Envio asignado correctamente a su almacen preferido.");

        }
        catch (SQLException e) {

            if (e.getMessage().equals("No hay suficiente espacio en el almacen")){

                idAlmacenAlternativo = gesAlmacenes.obtenerIDAlmacenMasCercano(idAlmacenPreferido, idEnvio);

                if (idAlmacenAlternativo != -1){

                    if (gesEnvios.consultarAsignarEnvioContenedorAlternativo(idAlmacenAlternativo)){

                        asignarContenedorAlternativo(idEnvio, idAlmacenAlternativo);

                    }

                }else{
                    System.out.println("En estos momentos este envio no cabe en ningún almacen.");
                }

            }else{
                System.out.println("Ocurrio un error, intentelo más tarde.");
            }

        }finally {
            gesConexion.closeConexion(conexion);
        }

    }

    /**
     * Asigna un contenedor al envio del ID pasado por parametro.
     */

    public void asignarContenedorAlternativo(int idEnvio, int idAlmacenAlternativo){

        SqlServerConexion gesConexion = new SqlServerConexion();
        String insertSQL;
        Connection conexion = null;

        try{

            conexion = gesConexion.getConexion();
            Statement statement = conexion.createStatement();
            insertSQL = "INSERT INTO Asignaciones(IDEnvio, IDAlmacen) VALUES ("+idEnvio+", "+idAlmacenAlternativo+")";
            statement.execute(insertSQL);

        }
        catch (SQLException e) {

            System.out.println("Ocurrio un error, intentelo más tarde.");

        }finally {
            gesConexion.closeConexion(conexion);
        }

    }

}

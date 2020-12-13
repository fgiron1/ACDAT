package Gestoras;

import Conexion.SqlServerConexion;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class GestoraAlmacenes {

    /**
     * Obtiene el nombre del almacen que su id es el id pasado por parametro.
     * @return Devuelve el nombre del almacen. Devuelve la cadena vacia si no existe el almacen.
     */

    public String obtenerNombreDeAlmacen(int idAlmacen){
        String nombreAlmacen = "", insertSQL;
        SqlServerConexion gesConexion = new SqlServerConexion();
        Connection conexion = null;
        ResultSet resultado;

        try{

            conexion = gesConexion.getConexion();
            Statement statement = conexion.createStatement();
            insertSQL = "SELECT Denominacion FROM Almacenes WHERE ID = " + idAlmacen;
            resultado = statement.executeQuery(insertSQL);

            while (resultado.next()){
                nombreAlmacen = resultado.getString(1);
            }

        }
        catch (SQLException e) {

            System.out.println("Ocurrio un error, intentelo más tarde.");

        }finally {
            gesConexion.closeConexion(conexion);
        }

        return nombreAlmacen;
    }

    /**
     * Devuelve el ID del contenedor más cercano al ID del almacen pasado donde quepa el envio que tiene el ID pasado. Devuelve -1 si no hay ningun almacen donde quepa.
     * @return Devuelve el ID del contenedor más cercano.
     */

    public int obtenerIDAlmacenMasCercano(int idAlmacen, int idEnvio){

        int idContenedor = -1;
        ResultSet resultado = null;
        SqlServerConexion gesConexion = new SqlServerConexion();
        String selectSql = "SELECT TOP 1 IDAlmacen FROM FNAlmacenMasCercaDisponible ("+idAlmacen+","+idEnvio+") ORDER BY Distancia ASC";
        Connection conexion = null;

        try{

            conexion = gesConexion.getConexion();
            Statement statement = conexion.createStatement();
            resultado = statement.executeQuery(selectSql);

            while (resultado.next()){

                idContenedor = resultado.getInt(1);

            }

            gesConexion.closeConexion(conexion);

        }
        catch (SQLException e) {
            System.out.println("Error, intentelo mas tarde.");
        }finally {
            gesConexion.closeConexion(conexion);
        }

        return idContenedor;

    }

}

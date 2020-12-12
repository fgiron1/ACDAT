package Conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class SqlServerConexion {

    private String direccion, baseDeDatos, usuario, contrasena, cadenaConexion;

    public SqlServerConexion(){

        cadenaConexion = "jdbc:sqlserver://localhost; database=AlmacenesLeo; user=prueba; password=123;";

    }

    public SqlServerConexion(String direccion, String baseDeDatos, String usuario, String contrasena) {
        cadenaConexion = "jdbc:sqlserver://"+direccion+"; database="+baseDeDatos+"; user="+usuario+"; password="+contrasena+";";
    }


    public Connection getConexion(){

        Connection conexion = null;

        try{

            conexion = DriverManager.getConnection(cadenaConexion);

        }
        catch (SQLException e) {
            e.printStackTrace();
        }

        return conexion;

    }


    public void closeConexion( Connection conexion){

        try{

            conexion.close();

        }
        catch (SQLException e) {
            e.printStackTrace();
        }

    }


}

import Gestoras.GestoraEnvios;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Main {

    public static void main(String[] args) {

        GestoraEnvios ges = new GestoraEnvios();
        int idLeido;

        ges.mostrarEnviosSinAsignar();

        idLeido = ges.leerYValidarEnvioSinAsignar();

    }


}

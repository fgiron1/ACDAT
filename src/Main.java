import Gestoras.GestoraAsignaciones;
import Gestoras.GestoraEnvios;

public class Main {

    public static void main(String[] args) {

        GestoraEnvios gesEnvios = new GestoraEnvios();
        GestoraAsignaciones gesAsignaciones = new GestoraAsignaciones();
        int idLeido;

        gesEnvios.mostrarEnviosSinAsignar();

        idLeido = gesEnvios.leerYValidarEnvioSinAsignar();

        gesAsignaciones.asignarContenedor(idLeido);

    }

}

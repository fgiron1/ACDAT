import Gestoras.GestoraAsignaciones;
import Gestoras.GestoraEnvios;
import com.microsoft.sqlserver.jdbc.SQLServerException;

import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        GestoraEnvios gesEnvios = new GestoraEnvios();
        GestoraAsignaciones gesAsignaciones = new GestoraAsignaciones();
        int idLeido;
        char caracter;
        Scanner scanner = new Scanner(System.in);

        System.out.println("");
        System.out.println("Bienvenido a AssignPackage");

        do {
            System.out.println();

            gesEnvios.mostrarEnviosSinAsignar();

            idLeido = gesEnvios.leerYValidarEnvioSinAsignar();

            gesAsignaciones.asignarContenedor(idLeido);


            System.out.println();

            do {

                System.out.print("¿Desea asignar más envios? Introduzca S o N: ");
                caracter = Character.toUpperCase(scanner.next().charAt(0));

            }while (caracter != 'N' && caracter != 'S');


        }while (caracter != 'N');

    }

}

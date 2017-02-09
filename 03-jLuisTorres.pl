#!/usr/bin/perl

use warnings;
use strict;
use HTML::Template;


# Recibe como argumentos 
# $_[0] : datos a procesar
# $_[1] : nombre del archivo que contiene el template
sub procesaDatos{
    # Abrimos el template
    my $template = HTML::Template->new(filename => $_[1]);

    my @loopData=(); # Creamos el arreglo para el loop sobre el template

    # Procesamos cada una de las lineas de datos
    for (@{$_[0]}) 
    {
	if (/(.*):(.*):(.*):(.*):(.*):(.*):(.*)/){ 
	    my %usuario; # Creamos un hash para los datos de cada usuario

	    $usuario{"user"}=$1;
	    $usuario{"pass"}=$2;
	    $usuario{"uid"}=$3;
	    $usuario{"gid"}=$4;
	    $usuario{"desc"}=$5;
	    $usuario{"home"}=$6;
	    $usuario{"shell"}=$7;

	    push(@loopData,\%usuario); # Agregamos el hash al arreglo loopData
	}
    }
    $template->param(usuarios => \@loopData); # Asignamos "usuarios" como variable de template
    return $template->output(); # Hacemos el loop y devolvemos la salida, es decir, el html
}


# Define los nombres de los archivos a usar, crea una copia de /etc/passwd, lee los datos
# y llama a procesaDatos para crear el html, guarda la salida en un archivo .html
sub generaHTML{
    my $fileDatos="datos.txt"; # Archivo con los datos de los usuarios
    my $fileTemplate="03-jLuisTorres.tmpl"; # Template para generar la forma
    my $fileHTML="passwd.html"; # Archivo para la salida

    # Abrimos el archivo para el html
    open FILEHTML,"> $fileHTML" or die "Error: no se puede crear al archivo html.";

    # Abrimos el archivo de passwords
    `cp /etc/passwd $fileDatos`; # Primero creamos una copia de /etc/passwd
    open FILEPASSWD,"<datos.txt" or die "Error: no se puede abrir el archivo de passwords.";
    my @datosPasswd=(<FILEPASSWD>); # Leemos la informacion y la guardamos en un arreglo
    close(FILEPASSWD); # Ya no se requiere
    `rm $fileDatos`; # Borramos la copia de passwd, ya no se requiere

    # Le pasamos los datos y el nombre del template a procesaDatos
    print FILEHTML procesaDatos(\@datosPasswd, $fileTemplate); # Guardamos la salida en $fileHTML
    print "La operacion se realizo con exito, la salida se encuentra en el archivo $fileHTML\n";

    close FILEHTML;
}


&generaHTML();



__END__

=pod

=head1 Jose Luis Torres Rodriguez - Tarea 3

=head2 DESCRIPCION

El programa hace uso de C<HTML::Template> para crear un html a partir de una plantilla. La informacion
se toma de /etc/passwd, se separan los datos de cada usuario y se muestran en una tabla.

=head2 PARAMETROS

El programa no recibe parametros.

=head2 VALORES DEVUELTOS

Genera un archivo "passwd.html" con la salida creada a partir de la plantilla. 

Para cambiar el nombre del archivo de la plantilla se debe modificar la variable C<fileTemplate> en la subrutina C<generaHTML>.

Para cambiar el nombre del archivo de salida (html) se debe modificar la variable C<fileHTML> en la subrutina C<generaHTML>.

=head2 FUNCIONES

=head3 procesaDatos

Recibe como argumento los datos a procesar, en este caso corresponden a la informacion leida del archivo C</etc/passwd> (se trabaja con una copia), ademas del nombre del archivo que contiene el template a usar.

=head3 generaHTML

Define los nombres de los archivos a usar, crea una copia de /etc/passwd, lee los datos de este y llama a C<procesaDatos> para crear el html, guarda la salida en el archivo indicado por C<fileHTML>.

=head2 EJECUCION

Para ejecutarlo es suficiente con verificar que cuenta con los permisos de ejecucion correspondientes y hacer uso de

B<C<./03-jLuisTorres.pl>>

o bien

B<C<perl 03-jLuisTorres.pl>>

=cut

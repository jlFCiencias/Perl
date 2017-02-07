#!/usr/bin/perl

use warnings;
use strict;
use 5.014;

my %urls=();
my %ips=();
my %domains=();
my %emails=();

# Verificamos si el usuario proporciona el nombre del archivo
if ($#ARGV < 0)
{
    say "ERROR: falta un argumento.\nUso: $0 <archivo-a-procesar>";
    exit(0);
}

# Intentamos abrir el archivo de entrada
open(FD, "<", $ARGV[0]) or die "ERROR: no se puede abrir el archivo de entrada\n";
# Intentamos abrir el archivo de salida
open(FRES, ">", "resumen.txt") or die "ERROR: no se puede abrir el archivo de salida\n";

# Si se pudo abrir procedemos a procesarlo
while (<FD>)
{
    chomp;
    # Revisamos primero si la linea contiene una URL, solo se consideran http, https y ftp
    if(/((ht|f)?tp[s]?:\/\/([a-zA-Z\-_0-9]+\.[a-zA-Z\-_0-9\.]+[a-zA-Z\-_0-9]*)\/?[\?]?[a-zA-Z\-_\.0-9=&\/]*)/) 
    {
	# Si existe la URL en el hash incrementamos su valor, de lo contrario la agregamos
	if (exists($urls{$&}))
	{
	    $urls{$&}++;
	}
	else
	{
	    $urls{$&}=1;
	}
	# Si existe el dominio de la URL incrementamos su valor. si no lo agregamos
	if (exists($urls{$3}))
	{
	    $domains{$3}++;
	}
	else
	{
	    $domains{$3}=1;
	}
	next;
    }
    # A continuacion verificamos si contiene un email
    if(/([a-z0-9.]+\@([a-z0-9-]+\.[a-z0-9-\.]+))/)
    {
	# Si el email ya esta registrado solamente lo incrementamos, si no lo agregamos
	if (exists($emails{$&}))
	{
	    $emails{$&}++;
	}
	else
	{
	    $emails{$&}=1;
	}
	# Si existe el dominio del email incrementamos su valor. si no lo agregamos
	if (exists($urls{$2}))
	{
	    $domains{$2}++;
	}
	else
	{
	    $domains{$2}=1;
	}
	next;
	
    }
    # Por ultimo verificamos si contiene una direccion IP
    # Validamos que el primer octeto se encuentre en [1,255] y los otros tres en [0,255]
    if(/([1-9][0-9]{0,2})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})/ &&(($1>0 && $1<=255 && $2>=0 && $2<=255 && $3>=0 && $3<=255 && $4>=0 && $4<=255 ))) 
    {
	# Si existe la IP incrementamos su valor, si no la agregamos
	if (exists($ips{$&}))
	{
	    $ips{$&}++;
	}
	else
	{
	    $ips{$&}=1;
	}

    }
}

# A continuacion mostramos los datos
print FRES "URL's\n";
for (keys %urls)
{
    print FRES "$urls{$_} veces | ", $_, "\n";
}

print FRES "Dominios\n";
for (keys %domains)
{
    print FRES "$domains{$_} veces | ", $_, "\n";
}

print FRES "IP's\n";
for (keys %ips)
{
    print FRES "$ips{$_} veces | ", $_, "\n";
}
print FRES "Email's\n";
for (keys %emails)
{
    print FRES "$emails{$_} veces | ", $_, "\n";
}

close(FD);
close(FRES);

__END__

=pod
 
=head1 Jose Luis Torres Rodriguez - Tarea 2

=head2 DESCRIPCION

El programa busca en un archivo de texto URL's, dominios, email's y direcciones IP V4.

Para las URL's solamente se consideran http, https y ftp.

Genera un resumen de los datos encontrados en un archivo de nombre resumen.txt, mostrando la frecuencia de cada uno.

El programa valida que se haya incluido el nombre del archivo a procesar y que el mismo pueda abrirse para lectura.

=head2 PARAMETROS

Recibe como parametro el nombre del archivo a procesar.

=head2 VALORES DEVUELTOS

Genera un resumen de los datos encontrados en un archivo de nombre resumen.txt.

=head2 EJECUCION

Para ejecutarlo es suficiente con verificar que cuenta con los permisos de ejecucion correspondientes y hacer uso de 

B<C<./02-jLuisTorres.pl E<lt>Archivo a procesarE<gt>>> 

o bien 

B<C<perl 01-jLuisTorres.pl E<lt>Archivo a procesarE<gt>>>
 
=cut

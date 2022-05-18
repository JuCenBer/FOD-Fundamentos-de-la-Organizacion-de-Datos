program ejercicio1;

type
	archivo = file of integer;


procedure leerEnteros(var archivo1: archivo);
var
	num: integer;
begin
	num := 0;
	write('Ingrese el numero entero: '); readln(num);
	while(num <> 30000) do begin
		write(archivo1, num);
		write('Ingrese el numero entero: '); readln(num);
	end;
end;

var
	archivo1: archivo;
	nombreArchivo: string;
BEGIN
	write('Ingrese el nombre del archivo: '); readln(nombreArchivo);
	Assign(archivo1, nombreArchivo);
	rewrite(archivo1);
	leerEnteros(archivo1);	
END.


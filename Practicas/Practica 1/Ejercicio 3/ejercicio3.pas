Program ejercicio3;

Type 
    empleado =   Record
        nroEmpleado:   integer;
        apellido:   String;
        nombre:   string;
        edad:   integer;
        dni:   integer;
    End;

    archivo = file of empleado;

Procedure leerEmpleado(var archivoEmpleados: archivo);
Var 
    emple: empleado;
Begin
    randomize;
    write('Ingrese el apellido del empleado: '); readln(emple.apellido);
    while (emple.apellido <> 'fin') do begin
        write('Ingrese el nombre del empleado: '); readln(emple.nombre);
        emple.nroEmpleado := Random(15000);
        emple.dni := Random(30000);
        emple.edad := 18 + Random(50);
        write(archivoEmpleados, emple);
        write('Ingrese el apellido del empleado: '); readln(emple.apellido);
    end;
End;

procedure procesarArchivo(var archivoEmpleados: archivo);
var
    emple: empleado;
    nombre, apellido: string;
begin
    write('Ingrese el nombre y apellido que desea buscar: '); readln(nombre); readln(apellido);
    while (not(Eof(archivoEmpleados))) do begin
        read(archivoEmpleados, emple);
        if(emple.nombre = nombre) and (emple.apellido = apellido) then begin
            WriteLn('* ', emple.nombre, ' ', emple.apellido, ': ');
            writeln('   -Nro. Empleado: ', emple.nroEmpleado);
            WriteLn('   -Edad: ', emple.edad);
            WriteLn('   -DNI: ', emple.dni);
            writeln(' ');
        end;
    end;

    seek(archivoEmpleados, 0);
    writeln('------------------------------------------------');
    writeln('------ Listado de Empleados ------');

    while(not(Eof(archivoEmpleados))) do begin
        read(archivoEmpleados, emple);
        WriteLn('* ', emple.nombre, ' ', emple.apellido, ': ');
            writeln('   -Nro. Empleado: ', emple.nroEmpleado);
            WriteLn('   -Edad: ', emple.edad);
            WriteLn('   -DNI: ', emple.dni);
        writeln(' ');
    end;

    seek(archivoEmpleados, 0);
    writeln('------------------------------------------------');
    writeln('------ Listado Proximos a Jubilarse ------');

    while(not(Eof(archivoEmpleados))) do begin
        read(archivoEmpleados, emple);
        if(emple.edad > 70) then begin
            WriteLn('* ', emple.nombre, ' ', emple.apellido, ': ');
                writeln('   -Nro. Empleado: ', emple.nroEmpleado);
                WriteLn('   -Edad: ', emple.edad);
                WriteLn('   -DNI: ', emple.dni);
            writeln(' ');
        end;
    end;
end;

Var 
    archivoEmpleados: archivo;
    nombreArchivo: string;
Begin
    write('Ingrese el nombre del archivo de los empleados:'); readln(nombreArchivo);
    Assign(archivoEmpleados, nombreArchivo);
    rewrite(archivoEmpleados);
    leerEmpleado(archivoEmpleados);
    close(archivoEmpleados);

    reset(archivoEmpleados);
    procesarArchivo(archivoEmpleados);
End.

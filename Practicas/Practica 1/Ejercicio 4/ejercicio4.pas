Program ejercicio4;

Type 
    empleado =   Record
        nroEmpleado:   integer;
        apellido:   String;
        nombre:   string;
        edad:   integer;
        dni:   integer;
    End;

    archivo = file of empleado;

    archivoTexto = file of Text;

Procedure agregarEmpleado(var archivoEmpleados: archivo);
Var 
    emple: empleado;
Begin
    randomize;
    write('Ingrese el apellido del empleado: '); readln(emple.apellido);
    if (emple.apellido <> 'fin') then begin
        write('Ingrese el nombre del empleado: '); readln(emple.nombre);
        emple.nroEmpleado := Random(15000);
        emple.dni := Random(30000);
        emple.edad := 18 + Random(50);
        seek(archivoEmpleados, FileSize(archivoEmpleados));
        write(archivoEmpleados, emple);
    end;
    seek(archivoEmpleados, 0);
End;

procedure listarPorNombreApellido(var archivoEmpleados: archivo);
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
end;

procedure listadoEmpleados(var archivoEmpleados: archivo);
var
    emple: empleado;
begin
    while(not(Eof(archivoEmpleados))) do begin
        read(archivoEmpleados, emple);
        WriteLn('* ', emple.nombre, ' ', emple.apellido, ': ');
            writeln('   -Nro. Empleado: ', emple.nroEmpleado);
            WriteLn('   -Edad: ', emple.edad);
            WriteLn('   -DNI: ', emple.dni);
        writeln(' ');
    end;
    seek(archivoEmpleados, 0);
end;

procedure listadoMayores70anos(var archivoEmpleados: archivo);
var
    emple: empleado;
begin
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
    seek(archivoEmpleados, 0);
end;

procedure modificarEdad(var archivoEmpleados: archivo);
var
    nro, edad: integer;
    emple: empleado;
begin
    write('Ingrese el nro. de empleado: '); readln(nro);
    emple.edad := -1;
    while(not eof(archivoEmpleados)) and (emple.nroEmpleado <> nro) do begin
        read(archivoEmpleados, emple);
    end;
    if(emple.nroEmpleado = nro) then begin
        WriteLn('* ', emple.nombre, ' ', emple.apellido, ': ');
                writeln('   -Nro. Empleado: ', emple.nroEmpleado);
                WriteLn('   -Edad: ', emple.edad);
                WriteLn('   -DNI: ', emple.dni);
        writeln(' ');
        write('Ingrese la nueva edad del empleado: '); readln(edad);
        emple.edad := edad;
        seek(archivoEmpleados, FilePos(archivoEmpleados) - 1);
        write(archivoEmpleados, emple);
    end;
    seek(archivoEmpleados, 0);
end;

procedure exportarArchivo(var archivoEmpleados: archivo);
var
    emple: empleado;
    empleadosTexto: text;
begin
    Assign(empleadosTexto, 'todos_empleados.txt');
    rewrite(empleadosTexto);
    while(not eof(archivoEmpleados)) do begin
        read(archivoEmpleados, emple);
        writeln(empleadosTexto,'* ',emple.nombre,' ',emple.apellido);
        writeln(empleadosTexto,'Nro. Empleado: ', emple.nroEmpleado);
        writeln(empleadosTexto,'DNI: ', emple.dni);
        WriteLn(empleadosTexto,'Edad: ', emple.edad);
        writeln(empleadosTexto,' ');
    end;
    close(empleadosTexto);
    seek(archivoEmpleados, 0);
end;

procedure exportarArchivoSinDni(var archivoEmpleados: archivo);
var
    empleadosTexto: text;
    emple: empleado;
begin
    Assign(empleadosTexto, 'faltaDNIEmpleado.txt');
    rewrite(empleadosTexto);
    while(not eof(archivoEmpleados)) do begin
        read(archivoEmpleados, emple);   
        if(emple.dni = 0) then begin
            writeln(empleadosTexto,'* ',emple.nombre,' ',emple.apellido);
            writeln(empleadosTexto,'Nro. Empleado: ', emple.nroEmpleado);
            writeln(empleadosTexto,'DNI: ', emple.dni);
            WriteLn(empleadosTexto,'Edad: ', emple.edad);
            writeln(empleadosTexto,' ');
        end;
    end; 
    close(empleadosTexto);
    seek(archivoEmpleados, 0);   
end;    

procedure menu(var archivoEmpleados: archivo);
var
    opcion: integer;
begin
    opcion := -1;
    while(opcion <> 0) do begin
        writeln('------ MENU ------');
        writeln('1. Listar empleados por nombre y apellido.');
        writeln('2. Listar todos los empleados.');
        writeln('3. Listar en pantalla los empleados mayores a 70 anos.');
        writeln('4. Anadir un nuevo empleado.');
        writeln('5. Modificar edad.');
        writeln('6. Exportar informacion de empleados a archivo de texto.');
        writeln('7. Exportar empleados que no tengan DNI cargado a archivo de texto.');
        write('INGRESE LA OPCION (Ingrese 0 para salir.): '); readln(opcion);
        if (opcion = 1) then listarPorNombreApellido(archivoEmpleados)
        else if(opcion = 2) then listadoEmpleados(archivoEmpleados)
        else if(opcion = 3) then listadoMayores70anos(archivoEmpleados)
        else if (opcion = 4) then agregarEmpleado(archivoEmpleados)
        else if (opcion = 5) then modificarEdad(archivoEmpleados)
        else if (opcion = 6) then exportarArchivo(archivoEmpleados)
        else if (opcion = 7) then exportarArchivoSinDni(archivoEmpleados);
        writeln(' ');
    end;
end;

Var 
    archivoEmpleados: archivo;
    nombreArchivo: string;
Begin
    write('Ingrese el nombre del archivo de los empleados:'); readln(nombreArchivo);
    Assign(archivoEmpleados, nombreArchivo);
    reset(archivoEmpleados);
    menu(archivoEmpleados);
End.
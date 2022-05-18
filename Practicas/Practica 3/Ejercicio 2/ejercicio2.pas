Program ejercicio2;

const
    valorAlto = 32000;

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

procedure leer(var archivoEmpleados: archivo; var registro: empleado);
begin
    if not eof(archivoEmpleados) then read(archivoEmpleados, registro)
    else registro.nroEmpleado := valorAlto;
end;

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

procedure eliminarPos(var archivoEmpleados: archivo);
var
    emple: empleado;
    pos: integer;
    nroEmpleado: integer;
begin
    write('Ingrese el nro del empleado que desea eliminar: '); readln(nroEmpleado);
    //En este procedimiento asumimos que el empleado a eliminar existe

    seek(archivoEmpleados, 0);
    leer(archivoEmpleados, emple);
    while(emple.nroEmpleado <> nroEmpleado) do begin
        leer(archivoEmpleados, emple);
    end;
    pos := FilePos(archivoEmpleados) - 1;
    seek(archivoEmpleados, FileSize(archivoEmpleados) - 1);
    read(archivoEmpleados, emple);
    seek(archivoEmpleados, pos);
    write(archivoEmpleados, emple);
    seek(archivoEmpleados, FileSize(archivoEmpleados) - 1);
    truncate(archivoEmpleados);
end;

procedure eliminarInferior1000(var archivoEmpleados: archivo);
var
    emple: empleado;
    pos: integer;
begin
    seek(archivoEmpleados, 0);
    leer(archivoEmpleados, emple);
    while(emple.nroEmpleado <> valorAlto) do begin
        if(emple.nroEmpleado < 1000) then begin
            emple.nombre := '@' + emple.nombre; 
            seek(archivoEmpleados, FilePos(archivoEmpleados) - 1);
            write(archivoEmpleados, emple);
        end;
        leer(archivoEmpleados, emple); 
    end;
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
        writeln('8. Eliminar empleado del archivo');
        writeln('9. Eliminar logicamente los empleados con numero menor a 1000');
        writeln('INGRESE LA OPCION (Ingrese 0 para salir.): '); readln(opcion);
        if (opcion = 1) then listarPorNombreApellido(archivoEmpleados)
        else if(opcion = 2) then listadoEmpleados(archivoEmpleados)
        else if(opcion = 3) then listadoMayores70anos(archivoEmpleados)
        else if (opcion = 4) then agregarEmpleado(archivoEmpleados)
        else if (opcion = 5) then modificarEdad(archivoEmpleados)
        else if (opcion = 6) then exportarArchivo(archivoEmpleados)
        else if (opcion = 7) then exportarArchivoSinDni(archivoEmpleados)
        else if (opcion = 8) then begin
            eliminarPos(archivoEmpleados);
            reset(archivoEmpleados);
        end
        else if (opcion = 9) then eliminarInferior1000(archivoEmpleados);
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
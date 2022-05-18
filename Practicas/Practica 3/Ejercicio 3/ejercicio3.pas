program ejercicio3;

type
    novela = record
        codNovela: integer;
        nombre: string;
    end;

    archivo = file of novela;

procedure crearArchivo(var archivoNovela: archivo);
var
    nove: novela;
begin
    randomize;
    nove.codNovela := 0;
    nove.nombre := 'cabecera lista';
    while(nove.codNovela <> -1) do begin
        write(archivoNovela, nove);
        write('Ingrese el NOMBRE de la novela'); readln(nove.nombre);
        write('Ingrese el CODIGO de la novela'); readln(nove.codNovela);
    end;
end;

procedure altaNovela(var archivoNovela: archivo);
var
    nove, cabecera: novela;
    pos: integer;
begin
    seek(archivoNovela, 0);
    write('Ingrese el nombre de la novela'); readln(nove.nombre);
    write('Ingrese el codigo de la novela'); readln(nove.codNovela);
    read(archivoNovela, cabecera);
    if(cabecera.codNovela < 0) then begin
        pos := cabecera.codNovela * -1;
        seek(archivoNovela, pos);
        read(archivoNovela, cabecera);
        seek(archivoNovela, pos);
        write(archivoNovela, nove);
        seek(archivoNovela, 0);
        write(archivoNovela, cabecera);
    end
    else begin
        seek(archivoNovela, FileSize(archivoNovela)) ;
        write(archivoNovela, nove);
    end;
end;

procedure modificarNovela(var archivoNovela: archivo);
var
    nove: novela;
    codNovela: integer;
begin
    write('Ingrese el codigo de la novela que desea modificar'); readln(codNovela);
    read(archivoNovela, nove);
    while((not eof(archivoNovela)) and (codNovela <> nove.codNovela)) do
        read(archivoNovela, nove);
    if (nove.codNovela = codNovela) then begin
        writeln('El registro es: ');
        writeln('Nombre: ',nove.nombre);
        writeln('Cod. Novela: ',nove.codNovela);
        Write('Ingrese el nuevo nombre de la novela: '); readln(nove.nombre);
        seek(archivoNovela, FilePos(archivoNovela) - 1);
        write(archivoNovela, nove);
    end
    else
        write('No se encontro la novela');
end;

procedure eliminarNovela(var archivoNovela: archivo);
var
    nove: novela;
    cabecera: novela;
    codNovela: integer;
    pos: Integer;
begin
    write('Ingrese el codigo de la novela que desea eliminar: '); readln(codNovela);
    read(archivoNovela, cabecera);
    read(archivoNovela, nove);
    while(not eof(archivoNovela) and (nove.codNovela <> codNovela))  do begin
        read(archivoNovela, nove);
    end;
    if(nove.codNovela = codNovela) then begin
        pos := FilePos(archivoNovela) - 1;
        codNovela := pos * -1;
        nove.codNovela := cabecera.codNovela;
        seek(archivoNovela, pos);
        write(cabecera, nove);
        seek(archivoNovela, 0);
        cabecera.codNovela := codNovela;
        write(archivoNovela, cabecera);
    end
    else
        WriteLn('No se encontro el archivo');
end;

procedure menu(var archivoNovela: archivo);
var
    opcion: integer;
    nombreArchivo: string;
begin
    opcion := -1;
    while(opcion <> 0) do begin
        writeln('1. crear el archivo y cargarlo de datos ingresados por teclado');
        writeln('2. Dar alta una novela introducida por teclado');
        writeln('3. Modificar los datos de una novela');
        writeln('4. Eliminar una novela por codigo');
        writeln('5. Listar en archivo de texto todas las novelas, incluyendo las borradas');
        write('Ingrese la opcion(0 para salir):'); readln(opcion);
        case opcion of:
            1: crearArchivo(archivoNovela);
            2: altaNovela(archivoNovela);
            3: eliminarNovela(archivoNovela);
        end;
    end;
end;


var
    archivoNovela: archivo;
begin
    Assign(archivoNovela, 'novelitas');
    Rewrite(archivoNovela);
    menu(archivoNovela);
end.
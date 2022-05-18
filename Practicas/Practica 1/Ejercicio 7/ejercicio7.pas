program ejercicio7;

type
    novela = record
        codNovela: Integer;
        nombre: string;
        genero: string;
        precio: real;
    end;

    archivo = file of novela;

procedure importarNovelas(var nombreArchivo: string);
var
    archivoNovela: archivo;
    textoNovela: text;
    nove: novela;
begin
    if(nombreArchivo = '0') then begin
        write('Ingrese el nombre del archivo binario a generar: '); readln(nombreArchivo);
    end;
    Assign(archivoNovela, nombreArchivo);
    Assign(textoNovela, 'novelas.txt');
    rewrite(archivoNovela);
    reset(textoNovela);
    while(not eof(textoNovela)) do begin
        readln(textoNovela, nove.codNovela, nove.precio, nove.genero) ;
        readln(textoNovela, nove.nombre);
        write(archivoNovela, nove);
    end;
    close(archivoNovela); close(textoNovela);
end;

procedure agregarNovela(nombreArchivo: String);
var
    archivoNovela: archivo;
    nove: novela;
begin
    randomize;
    if(nombreArchivo = '0') then writeln('AVISO: Aun no se ha generado un archivo binario.')
    else begin
        Assign(archivoNovela, nombreArchivo) ;
        reset(archivoNovela);
        write('Ingrese el nombre de la novela: '); readln(nove.nombre);
        write('Ingrese el genero de la novela: '); readln(nove.genero);
        nove.precio := Random(5000);
        nove.codNovela := Random(15000);
        seek(archivoNovela, FileSize(archivoNovela));
        write(archivoNovela, nove);
        close(archivoNovela);
    end;
end;

procedure modificarNovela(nombreArchivo: string);
var
    archivoNovela: archivo;
    nove: novela;
    codigo: Integer;
    opcion: Integer;
begin
    if(nombreArchivo = '0') then writeln('AVISO: Aun no se ha generado un archivo binario.')
    else begin
        opcion := -1;
        Assign(archivoNovela, nombreArchivo);
        reset(archivoNovela);
        write('Ingrese el codigo de la novela que desea modificar: '); readln(codigo);
        while(not eof(archivoNovela) and (nove.codNovela <> codigo)) do begin
            read(archivoNovela, nove);
        end;
        if(nove.codNovela = codigo) then begin
            while(opcion <> 0) do begin
                writeln('1. Nombre: ', nove.nombre);
                writeln('2. Genero: ', nove.genero);
                writeln('3. Precio: ', nove.precio);
                writeln(' '); write('Seleccione que desea modificar (Ingrese 0 para finalizar): '); readln(opcion);
                case opcion of
                    1: begin
                        write('Ingrese el nuevo nombre de la novela: '); readln(nove.nombre);
                    end;
                    2:begin
                        write('Ingrese el nuevo genero de la novela: '); readln(nove.genero);
                    end;
                    3:begin
                        write('Ingrese el nuevo precio de la novela: '); readln(nove.precio);
                    end;
                end;
            end;
            seek(archivoNovela, FilePos(archivoNovela) - 1);
            write(archivoNovela, nove);
        end;
        close(archivoNovela);
    end;
end;

procedure listarNovelas(nombreArchivo: string);
var
    nove: novela;
    archivoNovela: archivo;
begin
    if(nombreArchivo = '0') then writeln('AVISO: Aun no se ha generado un archivo binario.')
    else begin
        Assign(archivoNovela, nombreArchivo);
        reset(archivoNovela);
        while(not eof(archivoNovela)) do begin
            read(archivoNovela, nove);
            writeln('* ', nove.nombre);
            writeln('Genero: ', nove.genero);
            writeln('Precio: ', nove.precio);
            writeln('Codigo: ', nove.codNovela);
            writeln(' ');
        end;
        close(archivoNovela);
    end;
end;
var 
    opcion: Integer;
    nombreArchivo: string;
BEGIN
    opcion := -1;
    nombreArchivo := '0';
    while (opcion <> 0) do begin
        writeln('------ MENU ------');
        writeln('1. Importar archivo de novelas desde archivo de texto.');
        writeln('2. Agregar novela');
        writeln('3. Modificar novela existente');
        writeln('4. Listar todas las novelas.');
        write('Seleccione la opcion deseada (Ingrese 0 para salir): '); readln(opcion);
        case opcion of
            1: importarNovelas(nombreArchivo);
            2: agregarNovela(nombreArchivo);
            3: modificarNovela(nombreArchivo);
            4: listarNovelas(nombreArchivo);
            else writeln('*** FIN DEL PROGRAMA ***');
        end;
    end;
END.
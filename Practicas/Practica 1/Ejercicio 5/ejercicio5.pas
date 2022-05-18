program ejercicio5;

type
    celular = record
        codCelular: integer;
        nombre: string;
        descripcion: string;
        marca: string;
        precio: real;
        stockMinimo: Integer;
        stockDisponible: Integer;
    end;    

    archivo = file of celular;

procedure archivoTextoABinario(var nombreArchivo: string);
var
    textoCelulares: text;
    archivoCelular: archivo;
    celu: celular;
begin
    if(nombreArchivo = '0') then begin
        write('Ingrese el nombre del archivo binario que se generara: '); readln(nombreArchivo);
    end;
    Assign(archivoCelular, nombreArchivo);
    Assign(textoCelulares, 'celulares.txt');
    reset(textoCelulares);
    rewrite(archivoCelular);
    while(not eof(textoCelulares)) do begin
        readln(textoCelulares, celu.codCelular, celu.precio, celu.marca);
        readln(textoCelulares, celu.stockDisponible, celu.stockMinimo, celu.descripcion) ;
        readln(textoCelulares, celu.nombre);
        write(archivoCelular, celu);        
    end;
    close(textoCelulares);
    close(archivoCelular);
end;

procedure listarMenorMinimo(nombreArchivo: string);
var
    celu: celular;
    archivoCelular: archivo;
begin
    if(nombreArchivo = '0') then writeln('Aun no se ha creado un archivo binario de celulares.')
    else begin
        Assign(archivoCelular, nombreArchivo);
        reset(archivoCelular);
        while(not eof(archivoCelular)) do begin
            read(archivoCelular, celu) ;
            if (celu.stockDisponible < celu.stockMinimo) then begin
                writeln('* ', celu.nombre);
                writeln('Codigo: ', celu.codCelular);
                writeln('Marca:', celu.marca);
                writeln('Descripcion: ', celu.descripcion);
                writeln('Precio: ', celu.precio);
                writeln('Stock Minimo: ', celu.stockMinimo);
                writeln('Stock Disponible: ', celu.stockDisponible);
                writeln(' ');
            end;
        end;
        close(archivoCelular);
    end;
end;

procedure archivoBinarioATexto(nombreArchivo: String);
var
    archivoCelular: archivo;
    textoCelulares: text;
    celu: celular;
begin
    if(nombreArchivo = '0') then writeln('Aun no se ha creado una archivo bianrio de celulares.')
    else begin
        Assign(archivoCelular, nombreArchivo);
        Assign(textoCelulares, 'celulares.txt');
        rewrite(textoCelulares);
        reset(archivoCelular);
        while(not eof(archivoCelular)) do begin
            read(archivoCelular, celu);
            WriteLn(textoCelulares, celu.codCelular, celu.precio, celu.marca);
            writeln(textoCelulares, celu.stockMinimo, celu.stockDisponible, celu.descripcion);
            WriteLn(textoCelulares, celu.nombre);
        end;
        close(archivoCelular);
        close(textoCelulares);
    end;
end;


procedure menu();
var
    opcion: Integer;
    nombreArchivo: string;
begin
    nombreArchivo := '0';
    opcion := -1;
    while (opcion <> 0) do begin
        writeln('1. Crear archivo de registros de celulares.') ;
        writeln('2. Listar los celulares con stock menor al minimo.');
        writeln('3. Listar los celulares con descripcion proporcionada por el usuario.');
        writeln('4. Exportar archivo de celulares a archivo de texto.');
        write('Seleccione una opcion (Ingrese 0 para salir): '); readln(opcion);
        if (opcion = 1) then archivoTextoABinario(nombreArchivo)
        else if (opcion = 2) then listarMenorMinimo(nombreArchivo)
        else if (opcion = 3) then
        else if (opcion = 4) then archivoBinarioATexto(nombreArchivo);
    end;
end;


begin
    menu();    
end.
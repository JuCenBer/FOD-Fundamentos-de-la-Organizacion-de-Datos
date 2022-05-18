program ejercicio6;

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
    writeln('Archivo binario creado.');
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
    if(nombreArchivo = '0') then writeln('Aun no se ha creado una archivo binario de celulares.')
    else begin
        Assign(archivoCelular, nombreArchivo);
        Assign(textoCelulares, 'celulares.txt');
        rewrite(textoCelulares);
        reset(archivoCelular);
        while(not eof(archivoCelular)) do begin
            read(archivoCelular, celu);
            WriteLn(textoCelulares, celu.codCelular,' ', celu.precio, celu.marca);
            writeln(textoCelulares, celu.stockMinimo,' ', celu.stockDisponible, celu.descripcion);
            WriteLn(textoCelulares, celu.nombre);
        end;
        close(archivoCelular);
        close(textoCelulares);
    end;
end;

procedure agregarCelular(nombreArchivo: string);
var
    archivoCelular: archivo;
    celu: celular;
begin
    randomize;
    if(nombreArchivo = '0') then writeln('Aun no se ha creado una archivo bianrio de celulares.')
    else begin
        Assign(archivoCelular, nombreArchivo);
        reset(archivoCelular);
        write('Nombre: '); readln(celu.nombre);
        write('Marca: '); readln(celu.marca);
        write('Descripcion: '); readln(celu.descripcion);
        celu.codCelular := Random(2000);
        celu.precio := Random(1500);
        celu.stockMinimo:= Random(5);
        celu.stockDisponible := Random(15);
        seek(archivoCelular, FileSize(archivoCelular)) ;
        write(archivoCelular, celu);
        close(archivoCelular);
    end;
end;

procedure modificarStock(nombreArchivo: string);
var
    celu: celular;
    archivoCelular: archivo;
    codigo: integer;
begin
    if(nombreArchivo = '0') then writeln('Aun no se ha creado una archivo bianrio de celulares.')
    else begin
        Assign(archivoCelular, nombreArchivo);
        reset(archivoCelular);
        celu.codCelular := 0;
        write('Ingrese el codigo del celular cuyo stock quiere modificar: '); readln(codigo);
        while(not eof(archivoCelular)) and (celu.codCelular <> codigo) do begin
            read(archivoCelular, celu);
        end;
        if (celu.codCelular = codigo) then begin
            writeln('* ', celu.nombre);
            writeln('Codigo: ', celu.codCelular);
            writeln('Marca:', celu.marca);
            writeln('Descripcion: ', celu.descripcion);
            writeln('Precio: ', celu.precio);
            writeln('Stock Minimo: ', celu.stockMinimo);
            writeln('Stock Disponible: ', celu.stockDisponible);
            writeln(' ');
            write('Ingrese el nuevo stock disponible: '); readln(celu.stockDisponible);
            seek(archivoCelular, FilePos(archivoCelular) - 1);
            write(archivoCelular, celu);
        end;
        close(archivoCelular);
    end;

end;

procedure  exportarSinStock(nombreArchivo: string);
var
    celu: celular;
    archivoCelular: archivo;
    textoCelulares: text;
begin
    if(nombreArchivo = '0') then writeln('Aun no se ha creado una archivo bianrio de celulares.')
    else begin
        Assign(archivoCelular, nombreArchivo);
        Assign(textoCelulares, 'SinStock.txt');
        rewrite(textoCelulares);
        reset(archivoCelular);
        while(not eof(archivoCelular)) do begin
            read(archivoCelular, celu) ;
            if(celu.stockDisponible = 0) then begin
                WriteLn(textoCelulares, celu.codCelular,' ', celu.precio, celu.marca);
                writeln(textoCelulares, celu.stockMinimo,' ', celu.stockDisponible, celu.descripcion);
                WriteLn(textoCelulares, celu.nombre);
            end;
        end;
        close(archivoCelular); close(textoCelulares);
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
        writeln('------ MENU ------');
        writeln('1. Crear archivo de registros de celulares.') ;
        writeln('2. Listar los celulares con stock menor al minimo.');
        writeln('3. Listar los celulares con descripcion proporcionada por el usuario.');
        writeln('4. Exportar archivo de celulares a archivo de texto.');
        writeln('5. Agregar celular');
        writeln('6. Modificar stock de un celular');
        writeln('7. Exportar celulares sin stock a archivo de texto.');
        write('Seleccione una opcion (Ingrese 0 para salir): '); readln(opcion);
        if (opcion = 1) then archivoTextoABinario(nombreArchivo)
        else if (opcion = 2) then listarMenorMinimo(nombreArchivo)
        else if (opcion = 3) then 
        else if (opcion = 4) then archivoBinarioATexto(nombreArchivo)
        else if (opcion = 5) then agregarCelular(nombreArchivo)
        else if (opcion = 6) then modificarStock(nombreArchivo)
        else if (opcion = 7) then exportarSinStock(nombreArchivo); 
    end;
end;


begin
    menu();    
end.
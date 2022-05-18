program ejercicio3;


const 
    valorAlto = 32000;

type
    producto = record
        codProducto: integer;
        nombre: string;
        descripcion: string;
        stockDisponible: integer;
        stockMinimo: integer;
        precio: real;
    end;

    ventasProducto  = record
        codProducto: integer;
        cantVendida: integer;
    end;

    archivoProducto = file of producto;
    archivoVentas = file  of ventasProducto;

    archivosVentas = array [1..30] of archivoVentas;
    registrosVentas = array[1..30] of ventasProducto;

procedure leer(var archivo: archivoVentas; var rDetalle: ventasProducto);
begin
    if not eof(archivo) then read(archivo, rDetalle)
    else rDetalle.codProducto := valorAlto;
end;

procedure minimo(var detalles: archivosVentas; var rDetalles: registrosVentas; var min: ventasProducto);
var
    i: integer;
    minIndice: integer;
begin
    minIndice := -1;
    min.codProducto := valorAlto;
    for i := 1 to 30 do begin
        if(rDetalles[i].codProducto < min.codProducto) then begin
            minIndice := i;
            min := rDetalles[i];
        end;
    end;
    if(minIndice <> -1) then leer(detalles[minIndice], rDetalles[minIndice]);
end;

procedure merge(var detalles: archivosVentas; var maestro: archivoProducto);
var
    rMaestro: producto;
    rDetalles: registrosVentas;
    min: ventasProducto;
    total: integer;
    i: integer;
    codActual: integer;
begin
    for i := 1 to 30 do leer(detalles[i], rDetalles[i]);
    minimo(detalles, rDetalles, min);
    read(maestro, rMaestro);
    while(min.codProducto <> valorAlto) do begin
        codActual := min.codProducto;
        total := 0;
        while(codActual = min.codProducto) do begin
            total := total + min.cantVendida;
            minimo(detalles, rDetalles, min);
        end;
        while(rMaestro.codProducto <> codActual) do read(maestro,rMaestro);
        rMaestro.stockDisponible := rMaestro.stockDisponible - total;
        seek(maestro, FilePos(maestro) - 1);
        write(maestro, rMaestro);
        if(not eof(maestro)) then read(maestro, rMaestro);
    end;
end;

var
    maestro: archivoProducto;
    detalles: archivosVentas;
    i: integer;
begin
    for i:= 1 to 30 do begin
        Assign(detalles[i], 'detalle N'+ IntToStr(i));
        reset(detalles[i]);
    end;
    Assign(maestro, 'archivo_productos');
    rewrite(maestro);

    merge(detalles, maestro);
    for i := 1 to 30 do close(detalles[i]);
    close(maestro);
end.
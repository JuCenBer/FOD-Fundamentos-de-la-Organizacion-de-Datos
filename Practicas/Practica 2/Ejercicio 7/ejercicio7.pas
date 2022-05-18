program ejercicio7;

const 
    valorAlto = 32000;

type
    producto = record
        codProducto: Integer;
        nombre: string;
        precio: real;
        stockActual: Integer;
        stockMinimo: integer;
    end;

    venta = record
        codProducto: integer;
        cantVendida: integer;
    end;
    
    archivoDetalle = file of venta;
    archivoMaestro = file of producto;

procedure leer(var detalle: archivoDetalle; var rDetalle: venta);
begin
    if (not eof(detalle)) then read(detalle, rDetalle)
    else rDetalle.codProducto := valorAlto;
end;

procedure actualizar(var detalle: archivoDetalle; var maestro: archivoMaestro);
var
    codActual: integer;
    total: integer;
    rDetalle: venta;
    rMaestro: producto;
begin
    leer(detalle, rDetalle);
    read(maestro, rMaestro);
    while(rDetalle.codProducto <> valorAlto) do begin
        total := 0;
        codActual := rDetalle.codProducto;
        while(rDetalle.codProducto = codActual) do begin
            total := total + rDetalle.cantVendida;
            leer(detalle, rDetalle);
        end;
        while(rMaestro.codProducto <> codActual) do read(maestro, rMaestro);
        rMaestro.stockActual := rMaestro.stockActual - total;
        seek(maestro, FilePos(maestro) - 1);
        write(maestro, rMaestro);
        if not eof(maestro) then
            read(maestro, rMaestro);
    end;
end;

procedure exportarArchivoTexto(var maestro: archivoMaestro; var archivoTexto: Text);
var
    rMaestro: producto;
begin
    while not eof(maestro) do begin
        read(maestro, rMaestro);
        if(rMaestro.stockActual < rMaestro.stockMinimo) then begin
            writeln(archivoTexto,'Cod: ',rMaestro.codProducto);
            writeln(archivoTexto,'Nombre: ',rMaestro.nombre);
            writeln(archivoTexto,'Precio: ',rMaestro.precio);
            WriteLn(archivoTexto,'Stock Actual: ', rMaestro.stockActual);
            WriteLn(archivoTexto,'Stock Minimo: ', rMaestro.stockMinimo);
            WriteLn(archivoTexto,' ');
        end;
    end;
end;

var
    detalle: archivoDetalle;
    archivoTexto: Text;
    maestro: archivoMaestro;
    rDetalle: venta;
    rMaestro: producto;
BEGIN
    Assign(detalle, 'archivoDetalle');
    reset(detalle);
    Assign(maestro, 'archivoMaestro');
    reset(maestro);
    actualizar(detalle, maestro);
    close(detalle);
    Assign(archivoTexto, 'stock_minimo.txt');
    rewrite(archivoTexto);
    seek(maestro, 0);
    exportarArchivoTexto(maestro, archivoTexto);
    close(maestro);
    close(archivoTexto);
END.
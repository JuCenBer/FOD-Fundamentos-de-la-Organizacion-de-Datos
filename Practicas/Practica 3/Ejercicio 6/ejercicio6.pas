program ejercicio6;

const
    valorAlto = 32000;

type
    prenda = record
        codPrenda: integer;
        descripcion: string;
        colores: string;
        tipoPrenda: string;
        stock: integer;
        precioUnitario: real;
    end;

    archivo = file of prenda;
    archivoDetalle = file of Integer;

procedure leerCodigo(var archivoCodigos: archivoDetalle; var codPrenda: Integer);
begin
    if(not eof(archivoCodigos)) then read(archivoCodigos, codPrenda)
    else codPrenda := valorAlto;
end;

procedure leerPrenda(var archivoPrendas: archivo; var articulo: prenda);
begin
    if(not eof(archivoPrendas)) then read(archivoPrendas, articulo)
    else articulo.codPrenda := valorAlto;
end;

procedure bajaLogicaPrendas(var archivoPrendas: archivo; var archivoCodigos: archivoDetalle);
var
    articulo: prenda;
    codPrenda: integer;
begin
    leerCodigo(archivoCodigos, codPrenda);
    while(codPrenda <> valorAlto) do begin
        leerPrenda(archivoPrendas, articulo);
        while((articulo <> valorAlto) and (codPrenda <> articulo.codPrenda)) do begin
            leerPrenda(archivoPrendas, articulo);
        end;
        if(articulo.codPrenda = codPrenda) then 
            articulo.stock := articulo.stock * -1;
        seek(archivoPrendas, 0);
        leerCodigo(archivoCodigos, codPrenda);
    end;
end;

procedure compactacionPrendas(var archivoPrendas: archivo);
var
    archivoNuevo: archivo;
    articulo: prenda;
begin
    Assign(archivoNuevo,'prendasNuevo');
    rewrite(archivoNuevo);
    while(not eof(archivoPrendas)) do begin
        read(archivoPrendas, articulo) ;
        if(articulo.stock >= 0) then write(archivoNuevo, articulo);
    end;
    close(archivoNuevo);
end;

var
    archivoPrendas: archivo;
    archivoCodigos: archivoDetalle;
begin
    Assign(archivoPrendas, 'prendas');
    Assign(archivoCodigos, 'codigosPrendasObsoletas');
    reset(archivoPrendas);
    reset(archivoCodigos);
    bajaLogicaPrendas(archivoPrendas, archivoCodigos);
    compactacionPrendas(archivoPrendas);

    close(archivoPrendas);
    close(archivoCodigos);
end.
program ejercicio6;

const
    valorAlto = 32000;
    valorAltoCepa = 'ZZZ';

type    
    casosDetalle = record
        codLocalidad: Integer;
        codCepa: string;
        cantCasosActivos: Integer;
        cantCasosNuevos: integer;
        cantRecuperados: Integer;
        cantFallecidos: Integer;
    end;

    casosMaestro = record
        codLocalidad: integer;
        localidad: string;
        codCepa: Integer;
        cantCasosActivos: Integer;
        cantCasosNuevos: integer;
        cantRecuperados: Integer;
        cantFallecidos: integer;
    end;
    
    archivoMunicipio = file of casosDetalle;
    archivosMunicipio = array [1..10] of archivoMunicipio;
    registrosMunicipio = array [1..10] of casosDetalle;

    archivoMinisterio = file of casosMaestro;

procedure leer(var detalle: archivoMunicipio; var rDetalle: casosDetalle);
begin
    if (not eof(detalle)) then read(detalle, rDetalle)
    else rDetalle.codLocalidad := valorAlto;
end;

procedure minimo(var rDetalles: registrosMunicipio; var detalles: archivosMunicipio; var min: casosDetalle);
var
    minIndice: integer;
    i: integer;
begin
    minIndice := -1;
    min.codLocalidad := valorAlto;
    min.codCepa := valorAltoCepa;
    for i := 1 to 10 do begin
        if(rDetalles[i].codLocalidad < min.codLocalidad) and (rDetalles[i].codCepa < min.codCepa) then begin
            minIndice := i;
            min := rDetalles[i];
        end;
    end;
    if(minIndice <> -1) then leer(detalles[minIndice], rDetalles[minIndice]);
end;

procedure actualizar(var detalles: archivosMunicipio; var maestro: archivoMinisterio);
var
    i: integer;
    min: casosDetalle;
    rDetalles: registrosMunicipio;
    rMaestro: casosMaestro;
begin
    for i := 1 to 10 do begin
        leer(detalles[i], rDetalles[i]);
    end;
    read(maestro, rMaestro);
    minimo(rDetalles, detalles, min);
    while(min.codLocalidad <> valorAlto) do begin
        while(rMaestro.codLocalidad <> min.codLocalidad) and (rMaestro.codCepa <> min.codCepa) do read(maestro,rMaestro);
        rMaestro.cantFallecidos := rMaestro.cantFallecidos + min.cantFallecidos;
        rMaestro.cantRecuperados := rMaestro.cantRecuperados + min.cantRecuperados;
        rMaestro.cantCasosActivos := min.cantCasosActivos;
        rMaestro.cantCasosNuevos := min.cantCasosNuevos;
        seek(maestro, FilePos(maestro) - 1);
        write(maestro, rMaestro);
        minimo(rDetalles, detalles, min);

        if(not eof(maestro)) then read(maestro, rMaestro);
    end;
end;

procedure informarLocalidades(var maestro: archivoMinisterio);
var
    i: integer;
    cantAux: integer;
    codActual : integer;
    rMaestro: casosMaestro;
begin
    i := 0;
    read(maestro, rMaestro);
    while(not eof(maestro)) do begin
        codActual := rMaestro.codLocalidad;
        cantAux := 0;
        while(not eof(maestro) and (rMaestro.codLocalidad = codActual)) do begin
            cantAux := cantAux + rMaestro.cantCasosActivos;
            read(maestro, rMaestro);
        end;
        if(cantAux > 50) then i := i + 1;
    end;
    writeln('La cantidad de localidades con mas de 50 casos activos es: ', i);
end;

var
    i: integer;
    detalles: archivosMunicipio;
    maestro: archivoMinisterio;
BEGIN
    for i := 1 to 10 do begin
        Assign(detalles[i], 'archivo municipio N' );
        reset(detalles[i]);
    end;
    Assign(maestro, 'archivo maestro');
    reset(maestro);

    actualizar(detalles, maestro);
    for i := 1 to 10 do begin
        close(detalles[i]) ;
    end;
    informarLocalidades(maestro);
    close(maestro);
END.
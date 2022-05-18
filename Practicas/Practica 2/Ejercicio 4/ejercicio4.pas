program ejercicio4;

const 
    valorAlto = 32000;
    valorAltoFecha = 'ZZZ';

type
    logDetalle = record
        codUsuario: integer;
        fecha: string;
        tiempoSesion: integer;
    end;

    logMaestro = record
        codUsuario: integer;
        fecha: string;
        tiempoTotalSesionesAbiertas: integer;
    end;

    archivoMaestro = file of logMaestro;
    archivoDetalle = file of logDetalle;

    archivosDetalles = array [1..5] of archivoDetalle;
    registrosDetalles = array [1..5] of logDetalle;

procedure leer(var archivoDetalle: archivoDetalle; var rDetalle: logDetalle);
begin
    if(not eof(archivoDetalle)) then read(archivoDetalle, rDetalle)
    else rDetalle.codUsuario := valorAlto;
end;

procedure minimo(var detalles: archivosDetalles; var rDetalles: registrosDetalles; var min: logDetalle);
var
    i: integer;
    minIndice: integer;
begin
    min.codUsuario := valorAlto;
    min.fecha := valorAltoFecha;
    minIndice := -1;
    for i := 1 to 5 do begin
        if(rDetalles[i].codUsuario < min.codUsuario) and (rDetalles[i].fecha < min.fecha) then begin
            minIndice := i;
            min := rDetalles[i];
        end;
    end;
    if (minIndice <> -1) then read(detalles[minIndice], rDetalles[minIndice]);
end;

procedure merge(var detalles: archivosDetalles; var maestro: archivoMaestro);
var
    rDetalles: registrosDetalles;
    rMaestro: logMaestro;
    min: logDetalle;
    codActual: integer;
    fechaActual: string;
    i: integer;
begin
    for i:= 1 to 5 do leer(detalles[i], rDetalles[i]);
    minimo(detalles, rDetalles, min);
    while(min.codUsuario <> valorAlto) do begin
        codActual := min.codUsuario;
        fechaActual := min.fecha;
        rMaestro.tiempoTotalSesionesAbiertas := 0;
        while(min.fecha = fechaActual) and (min.codUsuario = codActual) do begin
            rMaestro.tiempoTotalSesionesAbiertas := rMaestro.tiempoTotalSesionesAbiertas + min.tiempoSesion;
            minimo(detalles, rDetalles, min);
        end;
        rMaestro.codUsuario := codActual;
        rMaestro.fecha := fechaActual;
        write(maestro, rMaestro);
    end;
end;

var
    maestro: archivoMaestro;
    detalles: archivosDetalles;
    i: integer;
begin
    for i := 1 to 5 do begin
        Assign(detalles[i], 'detalle N' + IntToStr(i));
        reset(detalles[i]);
    end;
    assign(maestro, 'maestro');
    rewrite(maestro);
    merge(detalles, maestro);
    for i := 1 to 5 do close(detalles[i]);
    close(maestro);
end.
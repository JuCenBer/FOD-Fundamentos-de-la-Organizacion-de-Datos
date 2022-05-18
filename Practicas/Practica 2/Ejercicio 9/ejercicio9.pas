program ejercicio9;

const
    valorAlto = 32000;

type
    mesa = record
        codProvincia: integer;
        codLocalidad: Integer;
        nMesa: integer;
        cantVotos: integer;
    end;

    archivoMesas = file of mesa;

procedure leer(var archivo: archivoMesas; var rMesa: mesa);
begin
    if(not eof(archivo)) then read(archivo,rMesa)
    else rMesa.codProvincia := valorAlto;
end;

procedure imprimirListado(var archivo: archivoMesas);
var
    codProvActual, codLocActual: integer;
    totVotosProv, totVotosLoc, totVotos: integer;
    rMesa: mesa;
begin
    leer(archivo, rMesa);
    totVotos := 0;
    while(rMesa.codProvincia <> valorAlto) do begin
        writeln('Cod Provinicia: ', rMesa.codProvincia);
        codProvActual := rMesa.codProvincia;
        totVotosProv := 0;
        writeln('Cod. Localidad             Total de votos');
        while(rMesa.codProvincia = codProvActual) do begin
            codLocActual := rMesa.codLocalidad;
            totVotosLoc := 0; 
            while(rMesa.codProvincia = codProvActual) and (rMesa.codLocalidad = codLocActual) do begin
                totVotosLoc := totVotosLoc + rMesa.cantVotos;
                leer(archivo, rMesa);
            end;
            writeln(codLocActual,'          ',totVotosLoc);
            totVotosProv := totVotosProv + totVotosLoc;
        end;
        writeln('Total de Votos Provincia ',codProvActual,': ',totVotosProv);
        writeln(' ');
        totVotos := totVotos + totVotosProv;
    end;
    writeln('Total General de Votos: ', totVotos);
end;

VAR
    archivo: archivoMesas;
BEGIN
    Assign(archivo,'archivoMesas');
    reset(archivo);
    imprimirListado(archivo);
    close(archivo);
END.
program ejercicio11;

const
    valorAlto = 'ZZZ';

type
    maestroProvincia = record
        nombreProvincia: string;
        cantPersonasAlfabetizadas: integer;
        totalEncuestados: integer;
    end; 

    detalleProvincia = record
        nombreProvincia: string;
        codLocalidad: Integer;
        cantAlfabetizados: Integer;
        cantEncuestados: Integer;
    end;

    archivoDetalle = file of detalleProvincia;
    archivoMaestro = file of maestroProvincia; 

procedure leer(var detalle: archivoDetalle; var rDetalle: detalleProvincia);
begin
    if(not eof(detalle)) then read(detalle,rDetalle)
    else rDetalle.nombreProvincia := valorAlto;
end;

procedure minimo(var detalle1,detalle2: archivoDetalle; var rDetalle1,rDetalle2, min: detalleProvincia);
begin
    if(rDetalle1.nombreProvincia <= rDetalle2.nombreProvincia) then begin
        if (rDetalle1.codLocalidad <= rDetalle2.codLocalidad) then begin
            min := rDetalle1;
            leer(detalle1, rDetalle1);
        end
        else begin
            min := rDetalle2;
            leer(detalle2, rDetalle2);
        end;
    end
    else begin
        min := rDetalle2;
        leer(detalle2, rDetalle2);
    end;
end;

procedure actualizarMaestro(var detalle1, detalle2: archivoDetalle; var maestro: archivoMaestro);
var
    rDetalle1: detalleProvincia;
    rDetalle2: detalleProvincia;
    min: detalleProvincia;
    rMaestro: maestroProvincia;
    provActual: string;
    totalAlfabetizados, totalEncuestados: integer;
begin
    read(maestro, rMaestro);
    minimo(detalle1,detalle2, rDetalle1, rDetalle2, min);
    while(min.nombreProvincia <> valorAlto) do begin
        provActual := min.nombreProvincia;
        totalAlfabetizados := 0;
        totalEncuestados := 0;
        while(min.nombreProvincia = provActual) do begin
            totalAlfabetizados := totalAlfabetizados + min.cantAlfabetizados;
            totalEncuestados := totalEncuestados + min.cantEncuestados;
            minimo(detalle1,detalle2, rDetalle1, rDetalle2, min);
        end;
        while(rMaestro.nombreProvincia <> provActual) do read(maestro, rMaestro);
        rMaestro.cantPersonasAlfabetizadas := totalAlfabetizados;
        rMaestro.totalEncuestados := totalEncuestados;
        seek(maestro, FilePos(maestro) - 1);
        write(maestro, rMaestro);
        if(not eof(maestro)) then read(maestro, rMaestro);
    end;
end;

VAR
    detalle1: archivoDetalle;
    detalle2: archivoDetalle;
    maestro: archivoMaestro;
BEGIN
    Assign(detalle1,'archivo agencia 1');
    Assign(detalle2,'archivo agencia 2');
    Assign(maestro,'archivo maestro');
    actualizarMaestro(detalle1, detalle2, maestro);
    close(maestro);
    close(detalle1); close(detalle2);
END.
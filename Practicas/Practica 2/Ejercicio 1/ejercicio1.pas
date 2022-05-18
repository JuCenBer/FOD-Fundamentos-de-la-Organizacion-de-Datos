program ejercicio1;

const 
    valorAlto = 32000;

type
    ingreso = record
        codEmpleado: integer;
        nombre: string;
        monto: real;
    end;
    
    archivo = file of ingreso;

procedure leerArchivo(var archivoIngreso: ingreso; var rDetalle: ingreso)
begin
    if(not eof(archivoIngreso)) then read(archivoIngreso, rDetalle)
    else rDetalle.codEmpleado := valorAlto;
end;

procedure compactarArchivo(var archivoIngreso, archivoCompactado: archivo)
var
    rDetalle: ingreso;
    rCompacto: ingreso;
    codActual: integer;
begin
    leer(archivoIngreso, rDetalle);
    {Se procesan todos los registros del detalle}
    while(rDetalle.codEmpleado <> valorAlto) do begin
        codActual := rDetalle.codEmpleado;
        rCompacto := rDetalle;
        rCompacto.monto := 0;
        {Totalizo los ingresos del mismo empleado}
        while(codActual = rDetalle.codEmpleado) do begin
            rCompacto.monto := rCompacto.monto + rDetalle.monto;
            leerArchivo(archivoIngreso, rDetalle);
        end;
        write(archivoCompactado, rCompacto);     
    end;
end;

var
    archivoIngreso: archivo;
    archivoCompactado: archivo;
begin
    Assign(archivoIngreso, 'ingresosPercibidos');
    Assign(archivoCompactado, 'ingresosPercibidosCompactados');
    reset(archivoIngreso);
    rewrite(archivoCompactado); //rewrite porque se esta creando el "maestro"
    compactarArchivo(archivoIngreso,archivoCompactado);
    close(archivoIngreso);
    close(archivoCompactado);
end.
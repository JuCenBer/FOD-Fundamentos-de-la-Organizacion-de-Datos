program ejercicio8;

const
    valorAlto = 32000;

type
    venta = record
        codCliente: integer;
        ano: integer;
        mes: integer;
        dia: integer;
        monto: real;
    end;

    archivo = file of venta;

procedure leer(var archivoVentas: archivo; var rArchivo: venta);
begin
    if(not eof(archivoVentas)) then read(archivoVentas, rArchivo)
    else rArchivo.codCliente := valorAlto;
end;

procedure procesarVentas(var archivoVentas: archivo);
var
    codActual: integer;
    anoActual: integer;
    mesActual: integer;
    montoTotalMes: real;
    montoTotalAno: real;
    montoTotal: real;
    rArchivo: venta;
begin
    leer(archivoVentas, rArchivo);
    while(rArchivo.codCliente <> valorAlto) do begin
        writeln('Cod. Cliente: ', rArchivo.codCliente);
        codActual := rArchivo.codCliente;
        montoTotal := 0;
        while(rArchivo.codCliente = codActual) do begin
            writeln('Ano: ', rArchivo.ano);
            anoActual := rArchivo.ano;
            montoTotalAno := 0;
            while(rArchivo.codCliente = codActual) and (rArchivo.ano = anoActual) do begin
                writeln('Mes: ', rArchivo.mes);
                mesActual := rArchivo.mes;
                montoTotalMes := 0;
                while(rArchivo.codCliente = codActual) and (rArchivo.ano  = anoActual) and (rArchivo.mes = mesActual) do begin
                    writeln('- ', rArchivo.monto);
                    montoTotalMes := montoTotalMes + rArchivo.monto;
                    leer(archivoVentas, rArchivo);
                end;
                writeln('Monto total del mes: ', montoTotalMes);
                montoTotalAno := montoTotalAno + montoTotalMes;
            end; 
            writeln('Monto total del ano: ', montoTotalAno);
            montoTotal := montoTotal + montoTotalAno;
        end;
        writeln('Monto total del cliente: ', montoTotal);
    end;
end;

var
    archivoVentas: archivo;
BEGIN
    Assign(archivoVentas, 'ventas');
    reset(archivoVentas);
    procesarVentas(archivoVentas);
    close(archivoVentas);
END.
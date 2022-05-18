program ejercicio10;

const
    valorAlto = 'ZZZ';

type
    empleado = record
        departamento: string;
        division: string;
        nEmpleado: integer;
        categoria: integer;
        cantHorasExtra: Integer;
    end;

    archivoEmpleados = file of empleado;
    //Ordenado por departamento > division > nEmpleado

    valorHora = array[1..15] of real;

procedure leer(var archivo: archivoEmpleados; var rEmpleado: empleado);
begin
    if(not eof(archivo)) then read(archivo, rEmpleado)
    else rEmpleado.departamento := valorAlto;
end;

procedure imprimirListado(var archivo: archivoEmpleados; arreglovalorHora: valorHora);
var
    deptoActual, divActual: string;
    totHorasDepto, totHorasDiv: Integer;
    montoDiv,montoDepto: real;
    rEmpleado: empleado;
begin
    leer(archivo,rEmpleado);
    while(rEmpleado.departamento <> valorAlto) do begin
        writeln('Departamento: ', rEmpleado.departamento);
        deptoActual := rEmpleado.departamento;
        montoDepto := 0;
        totHorasDepto := 0; 
        while(rEmpleado.departamento = deptoActual) do begin
            writeln('Division: ', rEmpleado.division);
            divActual := rEmpleado.division;
            montoDiv := 0;
            totHorasDiv := 0;
            writeln('Nro. Empleado      Total Hs        Importe a cobrar');
            while(rEmpleado.departamento = deptoActual) and (rEmpleado.division = divActual) do begin
                writeln(rEmpleado.nEmpleado,'         ',rEmpleado.cantHorasExtra,'          ',rEmpleado.cantHorasExtra*arreglovalorHora[rEmpleado.categoria]);
                montoDiv := montoDiv + rEmpleado.cantHorasExtra*arreglovalorHora[rEmpleado.categoria];
                totHorasDiv := totHorasDiv + rEmpleado.cantHorasExtra;
                leer(archivo, rEmpleado);
            end;
            writeln('Total de horas division: ', totHorasDiv);
            writeln('Monto total de division: ',montoDiv);
            totHorasDepto := totHorasDepto + totHorasDiv;
            montoDepto := montoDepto + montoDiv;
        end;
        writeln('Total horas departamento: ', totHorasDepto);
        writeln('Monto total departamento: ', montoDepto);
    end;
end;

procedure cargarValores(var archivoValores: Text; var arreglovalorHora: valorHora);
var
    aux: real;
    categoria: integer;
    i: integer;
begin
    for i := 1 to 15 do begin
        readln(archivoValores, categoria, aux);
        arreglovalorHora[categoria] := aux;
    end;
end;

VAR
    archivo: archivoEmpleados;
    archivoValores: Text;
    arregloValorHora: valorHora;
BEGIN
    Assign(archivoValores, 'valorHora');
    Assign(archivo, 'archivoEmpleados');
    reset(archivoValores);
    reset(archivo);
    cargarValores(archivoValores, arreglovalorHora);
    imprimirListado(archivo, arreglovalorHora);
END.
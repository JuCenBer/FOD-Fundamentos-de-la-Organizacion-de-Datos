program ejercicio5;


const
    valorAlto =  32000;

type
    nacimiento = record
        nPartidaNacimiento: integer;
        nombre: string;
        direccion: string;
        matriculaMedico: integer;
        nombreMadre: string;
        dniMadre: integer;
        nombrePadre: string;
        dniPadre: integer;
    end;

    fallecimiento = record
        nPartidaNacimiento: integer;
        dni: integer;
        nombre: string;
        matriculaMedico: integer;
        fechaDeceso: string;
        horaDeceso: integer;
        lugarDeceso: string;
    end;

    persona = record
        nPartidaNacimiento: integer;
        nombre: string;
        direccion: string;
        matriculaMedico: integer;
        nombreMadre: string;
        dniMadre: integer;
        nombrePadre: string;
        dniPadre: integer;
        estaFallecido: boolean;
        matriculaMedicoDeceso: integer;
        fechaDeceso: string;
        horaDeceso: integer;
        lugarDeceso: string;
    end;

    archivoNacimiento = file of nacimiento;
    archivoFallecimiento = file of fallecimiento;

    archivosNacimiento = array [1..50] of archivoNacimiento;
    archivosFallecimiento = array [1..50] of archivoFallecimiento;

    registrosNacimientos = array [1..50] of nacimiento;
    registrosFallecimientos = array [1..50] of fallecimiento;

    archivoMaestro = file of persona;

procedure leerNacimiento(var archivoNacimiento: archivoNacimiento; var detalleNacimiento: nacimiento);
begin
    if(not eof(archivoNacimiento)) then read(archivoNacimiento, detalleNacimiento)
    else detalleNacimiento.nPartidaNacimiento := valorAlto;
end;

procedure leerFallecimiento(var archivoFallecimiento: archivoFallecimiento; var detalleFallecimiento: fallecimiento);
begin
    if(not eof(archivoFallecimiento)) then read(archivoFallecimiento, detalleFallecimiento)
    else detalleFallecimiento.nPartidaNacimiento := valorAlto;
end;

procedure minimoNacimiento(var rNacimientos: registrosNacimientos; var nacimientos: archivosNacimiento; var minNacimiento: nacimiento);
var
    i: integer;
    minIndice: integer;
begin
    minIndice := -1;
    minNacimiento.nPartidaNacimiento := valorAlto;
    for i := 1 to 50 do begin
        if(rNacimientos[i].nPartidaNacimiento < minNacimiento.nPartidaNacimiento) then begin
            minIndice := i;
            minNacimiento := rNacimientos[i] ;
        end; 
    end;
    if (minIndice <> -1) then leerNacimiento(nacimientos[minIndice], rNacimientos[minIndice]);
end;

procedure buscarFallecido(nPartidaNacimiento: integer; var rFallecimientos: registrosFallecimientos; var fallecimientos: archivosFallecimiento; var registro: fallecimiento);
var
    i: integer;
begin
    registro.nPartidaNacimiento := valorAlto;
    for i := 1 to 50 do begin
        if(rFallecimientos[i].nPartidaNacimiento = nPartidaNacimiento) then begin
            registro := rFallecimientos[i];
            break;
        end;
    end;
end;

procedure merge(var nacimientos: archivosNacimiento; var fallecimientos: archivosFallecimiento; var maestro: archivoMaestro);
var
    i: integer;
    rNacimientos: registrosNacimientos;
    rFallecimientos: registrosFallecimientos;
    rMaestro: persona;
    minNacimiento: nacimiento;
    minFallecimiento: fallecimiento;
begin
    for i := 1 to 50 do begin
        leerNacimiento(nacimientos[i],rNacimientos[i]) ;
        leerFallecimiento(fallecimientos[i], rFallecimientos[i]);
    end;
    minimoNacimiento(rNacimientos, nacimientos, minNacimiento);
    while(minNacimiento.nPartidaNacimiento <> valorAlto) do begin
        rMaestro.nPartidaNacimiento:= minNacimiento.nPartidaNacimiento;
        rMaestro.direccion:= minNacimiento.direccion;
        rMaestro.matriculaMedico:= minNacimiento.matriculaMedico;
        rMaestro.nombreMadre := minNacimiento.nombreMadre;
        rMaestro.dniMadre :=  minNacimiento.dniMadre;
        rMaestro.nombrePadre:= minNacimiento.nombrePadre;
        rMaestro.dniPadre:= minNacimiento.dniPadre;
        buscarFallecido(minNacimiento.nPartidaNacimiento, rFallecimientos, fallecimientos, minFallecimiento);
        if(minFallecimiento.nPartidaNacimiento = rMaestro.nPartidaNacimiento) then begin
            rMaestro.estaFallecido:= true;
            rMaestro.matriculaMedicoDeceso:= minFallecimiento.matriculaMedico;
            rMaestro.fechaDeceso:= minFallecimiento.fechaDeceso;
            rMaestro.horaDeceso:= minFallecimiento.horaDeceso;
            rMaestro.lugarDeceso:= minFallecimiento.lugarDeceso;
        end
        else begin
            rMaestro.estaFallecido:= false;
            rMaestro.matriculaMedicoDeceso:= -1;
            rMaestro.fechaDeceso:= '0';
            rMaestro.horaDeceso:= -1;
            rMaestro.lugarDeceso:= '0';
        end;
        write(maestro, rMaestro);
    end;
end;

var
    nacimientos: archivosNacimiento;
    fallecimientos: archivosFallecimiento;
    maestro: archivoMaestro;
    i: Integer;
BEGIN
    for i := 1 to 50 do begin
        Assign(nacimientos[i], 'archivo Nacimiento N'+IntToStr(i)) ;
        reset(nacimientos[i]);
        Assign(fallecimientos[i],'archivo Fallecimiento N'+IntToStr(i));
        reset(fallecimientos[i]);
    end;
    Assign(maestro, 'archivoMaestro');
    rewrite(maestro);

    merge(nacimientos, fallecimientos, maestro);

    for i := 1 to 50 do begin
        close(nacimientos[i]);
        close(fallecimientos[i]);
    end;
    close(maestro);
END.
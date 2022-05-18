program ejercicio2;

const
    valorAlto = 32000;

type
    alumno = record
        codAlumno: integer;
        apellido: string;
        nombre: string;
        cursadasAprobadas: integer;
        finalesAprobados: integer;
    end;

    detalleAlumno = record
        codAlumno: integer;
        aproboCursada: boolean;
        aproboFinal: boolean;
    end;

    archivoAlumnos = file of alumno;
    archivoDetalle = file of detalleAlumno;

procedure leer(var archivoDetalle; var rDetalle:detalleAlumno);
begin
    if not eof(archivoDetalle) then read(archivoDetalle, rDetalle)
    else rDetalle.codAlumno := valorAlto;
end;

procedure actualizarArchivoMaestro(var archivoDetalle: archivoDetalle; var archivoAlumnos: archivoAlumnos);
var
    rDetalle: detalleAlumno;
    rAlumno: alumno;
    codActual: integer;
begin
    read(archivoAlumnos, rAlumno);
    leer(archivoDetalle, rDetalle);
    while(rDetalle <> valorAlto) do begin
        codActual := rDetalle.codAlumno;
        rAlumno.cursadasAprobadas := 0;
        rAlumno.finalesAprobados := 0;
        while(codActual = rDetalle.codAlumno) do begin
            if(rDetalle.aproboCursada) then begin
                if(rDetalle.aproboFinal) then rAlumno.finalesAprobados := rAlumno.finalesAprobados + 1
                else rAlumno.cursadasAprobadas := rAlumno.cursadasAprobadas + 1;
            end;
            leer(archivoDetalle, rDetalle);
        end;

        while(rAlumno.codAlumno <> codActual) do
            read(archivoAlumnos, rAlumno);

        seek(archivoAlumnos, FilePos(archivoAlumnos) - 1);

        write(archivoAlumnos, rAlumno);

        if not eof(archivoAlumnos) then
            read(archivoAlumnos, rAlumno);
    end;
end;

procedure exportarAlumnos(var archivoAlumnos: archivoAlumnos);
var
    archivo: archivoAlumnos;
    alumno: alumno;
begin
    Assign(archivoAlumnos, 'alumnosEspeciales');
    reset(archivo);
    while(not eof(archivoAlumnos)) do begin
        read(archivoAlumnos, alumno);
        if(alumno.cursadasAprobadas > 4) then
          write(archivo, alumno);
    end;
    close(archivo);
end;


var
    archivoAlumnos: archivoAlumnos;
    archivoDetalle: archivoDetalle;
    opcion: Integer;
begin
    opcion := -1;
    Assign(archivoAlumnos, 'archivo_alumnos');
    Assign(archivoDetalle, 'detalle_alumnos');
    reset(archivoAlumnos); reset(archivoDetalle);
    while(opcion <> 0) do begin
        writeln('1. Actualizar el archivo de alumnos');
        writeln('2. Exportar en archivo de texto los alumnos que tengan mas de cuatro materias con cursada aprobada');
        write('Seleccione la opcion deseada (Ingrese 0 para finalizar): '); readln(opcion);
        case opcion of:
            1: actualizarArchivoMaestro();
            2: exportarAlumnos();
        end;
    end;
end.
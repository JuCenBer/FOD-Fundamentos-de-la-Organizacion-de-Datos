
Program ejercicio2;

Type 
    archivo =   file Of integer;


Procedure procesarEnteros(Var archivo1: archivo);

Var 
    num:   integer;
    sum:   integer;
    prom:   real;
    menores1500:   integer;
    n :   integer;
Begin
    n := 0;
    prom := 0;
    num := 0;
    sum := 0;
    menores1500 := 0;
    While (Not(eof(archivo1))) Do
        Begin
            read(archivo1, num);
            n := n + 1;
            If (num < 1500) Then menores1500 := menores1500 + 1;
            sum := sum + num;
            writeln('* ', num);
        End;
    prom := sum / n;
    writeln('La cantidad de enteros menores a 1500 es: ', menores1500);
    writeln('El promedio es: ', prom:0:3);
End;

Var 
    archivo1:   archivo;
    nombreArchivo:   string;
Begin
    write('Ingrese el nombre del archivo con enteros a procesar: ');
    readln(nombreArchivo);
    Assign(archivo1, nombreArchivo);
    reset(archivo1);
    procesarEnteros(archivo1);

End.

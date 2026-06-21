unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    BtnGenerar: TButton;
    BtnReiniciar: TButton;
    BtnSumar: TButton;
    BtnRestar: TButton;
    BtnTrasA: TButton;
    BtnOpusB: TButton;
    BtnOpusA: TButton;
    BtnTrasB: TButton;
    BtnMultiplicar: TButton;
    BtnPorEscalar: TButton;
    BtnDeterminanteA: TButton;
    EdFilasA: TEdit;
    EdColA: TEdit;
    EditFilasB: TEdit;
    EdColB: TEdit;
    GrillaA: TStringGrid;
    GrillaB: TStringGrid;
    GrillaResultado: TStringGrid;
    Logo: TImage;
    LblTitulo: TLabel;
    LblMatA: TLabel;
    LblMatB: TLabel;
    LblMatResul: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    procedure BtnDeterminanteAClick(Sender: TObject);
    procedure BtnGenerarClick(Sender: TObject);
    procedure BtnMultiplicarClick(Sender: TObject);
    procedure BtnOpusAClick(Sender: TObject);
    procedure BtnOpusBClick(Sender: TObject);
    procedure BtnPorEscalarClick(Sender: TObject);
    procedure BtnReiniciarClick(Sender: TObject);
    procedure BtnRestarClick(Sender: TObject);
    procedure BtnSumarClick(Sender: TObject);
    procedure BtnTrasAClick(Sender: TObject);
    procedure BtnTrasBClick(Sender: TObject);
  private

  public

  end;

const
  max = 9; // Límite en base 0 para matrices de 10x10
var
  Form1: TForm1;
  matrizA: array [0..max, 0..max] of integer;   //matriz A
  matrizB: array [0..max, 0..max] of integer;  // matriz B
  matrizR: array [0..max, 0..max] of integer; // matriz de resultados
  filasA, colA, filasB, colB: integer;

implementation

{$R *.lfm}

{ TForm1 }

//GENERAR MATRICES
procedure TForm1.BtnGenerarClick(Sender: TObject);
var
  f, c: integer;
  valido: boolean;
begin
  valido := true;

  // Validamos que ningún edit esté vacío o fuera de rango (1 a 10)
  if (StrToInt(EdFilasA.Text) < 1) or (StrToInt(EdFilasA.Text) > 10) or
     (StrToInt(EdColA.Text) < 1) or (StrToInt(EdColA.Text) > 10) or
     (StrToInt(EditFilasB.Text) < 1) or (StrToInt(EditFilasB.Text) > 10) or
     (StrToInt(EdColB.Text) < 1) or (StrToInt(EdColB.Text) > 10) then
  begin
    valido := false;
    ShowMessage('Las dimensiones de las matrices deben ser valores entre 1 y 10');
  end;

  if valido = true then
  begin
    // Guardamos los límites máximos en base 0
    filasA := StrToInt(EdFilasA.Text) - 1;
    colA := StrToInt(EdColA.Text) - 1;
    filasB := StrToInt(EditFilasB.Text) - 1;
    colB := StrToInt(EdColB.Text) - 1;

    // Asignamos tamaños a las grillas
    GrillaA.RowCount := StrToInt(EdFilasA.Text);
    GrillaA.ColCount := StrToInt(EdColA.Text);
    GrillaB.RowCount := StrToInt(EditFilasB.Text);
    GrillaB.ColCount := StrToInt(EdColB.Text);

    Randomize;   //numeros aleatorios

    // Cargar y mostrar Matriz A
    for f := 0 to filasA do
      for c := 0 to colA do
      begin
        matrizA[f, c] := Random(100);
        GrillaA.Cells[c, f] := IntToStr(matrizA[f, c]);
      end;

    // Cargar y mostrar Matriz B
    for f := 0 to filasB do
      for c := 0 to colB do
      begin
        matrizB[f, c] := Random(100);
        GrillaB.Cells[c, f] := IntToStr(matrizB[f, c]);
      end;

    // Habilitar botones de operaciones y deshabilitar Generar
    BtnGenerar.Enabled := False;
    BtnSumar.Enabled := True;
    BtnRestar.Enabled := True;
    BtnTrasA.Enabled := True;
    BtnTrasB.Enabled := True;
    BtnOpusA.Enabled := True;
    BtnOpusB.Enabled := True;
    BtnMultiplicar.Enabled := True;
    BtnPorEscalar.Enabled := True;
    BtnDeterminanteA.Enabled := True;
  end;
end;



// REINICIAR
procedure TForm1.BtnReiniciarClick(Sender: TObject);
begin
// Al reinicio vuelve contenido de filas y columnas a 0
  GrillaA.RowCount := 0;
  GrillaA.ColCount := 0;

  GrillaB.RowCount := 0;
  GrillaB.ColCount := 0;

  GrillaResultado.RowCount := 0;
  GrillaResultado.ColCount := 0;

  // vacia los TEdit p/ que el usuario vuelva a escribir
  EdFilasA.Text := '';
  EdColA.Text := '';
  EditFilasB.Text := '';
  EdColB.Text := '';

  // Restablecer estados de botones
  BtnGenerar.Enabled := True;
  BtnSumar.Enabled := False;
  BtnRestar.Enabled := False;
  BtnTrasA.Enabled := False;
  BtnTrasB.Enabled := False;
  BtnOpusA.Enabled := False;
  BtnOpusB.Enabled := False;
  BtnMultiplicar.Enabled := False;
  BtnPorEscalar.Enabled := False;
  BtnDeterminanteA.Enabled :=False;


  ShowMessage('Aplicación reiniciada. Puede ingresar nuevas dimensiones.');
end;

//SUMAR A + B
procedure TForm1.BtnSumarClick(Sender: TObject);
var
  f, c: integer;
begin
  if (filasA = filasB) and (colA = colB) then
  begin
    // Ajustamos la grilla de resultado al tamaño que corresponde
    GrillaResultado.RowCount := filasA + 1;
    GrillaResultado.ColCount := colA + 1;

    for f := 0 to filasA do
      for c := 0 to colA do
      begin
        matrizR[f, c] := matrizA[f, c] + matrizB[f, c];
        GrillaResultado.Cells[c, f] := IntToStr(matrizR[f, c]);
      end;
  end
  else
    ShowMessage('¡Operación Imposible! Para SUMAR, las matrices deben ser del MISMO ORDEN.');
end;

//RESTAR A - B
procedure TForm1.BtnRestarClick(Sender: TObject);
  var
    f, c: integer;
  begin
    if (filasA = filasB) and (colA = colB) then
    begin
      GrillaResultado.RowCount := filasA + 1;
      GrillaResultado.ColCount := colA + 1;

      for f := 0 to filasA do
        for c := 0 to colA do
        begin
          matrizR[f, c] := matrizA[f, c] - matrizB[f, c];
          GrillaResultado.Cells[c, f] := IntToStr(matrizR[f, c]);
        end;
    end
    else
      ShowMessage('¡Operación Imposible! Para RESTAR, las matrices deben ser del MISMO ORDEN.');
  end;

// MULTIPLICAR AxB
procedure TForm1.BtnMultiplicarClick(Sender: TObject);
  var
    f, c, k: integer;
    acumulador: integer;
  begin
    // Valida que las columnas de A sean = a las filas de B
    if colA = filasB then
    begin
      // Dimensionamos la grilla de resultado
      GrillaResultado.RowCount := filasA + 1;
      GrillaResultado.ColCount := colB + 1;

      // Recorre filas de A
      for f := 0 to filasA do
      begin
        // Recorre columnas de B
        for c := 0 to colB do
        begin
          acumulador := 0; // Inicializamos el contador para la celda actual

          // El tercer bucle recorre simultáneamente la fila de A y la columna de B
          for k := 0 to colA do
          begin
            acumulador := acumulador + (matrizA[f, k] * matrizB[k, c]);
          end;

          // Guardamos el total en la matriz de resultados y lo mostramos
          matrizR[f, c] := acumulador;
          GrillaResultado.Cells[c, f] := IntToStr(matrizR[f, c]);
        end;
      end;
    end
    else
    begin
      // Si no coinciden las dimensiones, avisamos al usuario
      ShowMessage('¡Operación Imposible! Para multiplicar A x B, la cantidad de COLUMNAS de A (' +
                  IntToStr(colA + 1) + ') debe ser igual a las FILAS de B (' + IntToStr(filasB + 1) + ').');
    end;
  end;

//MULTIPLICAR POR UN ESCALAR
procedure TForm1.BtnPorEscalarClick(Sender: TObject);
  var
    f, c: integer;
    escalar: integer;
    matrizElegida: string;
    valido: boolean;
  begin
    valido := true;

    // Le preguntamos al usuario cual matriz elige
    matrizElegida := InputBox('Multiplicar por Escalar', '¿Qué matriz desea multiplicar? (Escriba A o B):', '');

    // Pasamos a mayúsculas la letra que ingresó
    matrizElegida := UpperCase(matrizElegida);

    // Validamos que haya ingresado A o B
    if (matrizElegida <> 'A') and (matrizElegida <> 'B') then
    begin
      valido := false;
      ShowMessage('Error: Debe ingresar "A" o "B" para seleccionar la matriz.');
    end;

    // Si la opción esta ok pedimos el n° escalar y hacemos la cuenta
    if valido = true then
    begin
      escalar := StrToInt(InputBox('Multiplicar por Escalar', 'Ingrese el número entero (escalar):', ''));

      // --- CASO MATRIZ A ---
      if matrizElegida = 'A' then
      begin
        // Dimensionamos la grilla con el tamaño de A
        GrillaResultado.RowCount := filasA + 1;
        GrillaResultado.ColCount := colA + 1;

        // Recorremos y multiplicamos la Matriz A
        for f := 0 to filasA do
          for c := 0 to colA do
          begin
            matrizR[f, c] := matrizA[f, c] * escalar;
            GrillaResultado.Cells[c, f] := IntToStr(matrizR[f, c]);
          end;
      end;

      // --- CASO MATRIZ B ---
      if matrizElegida = 'B' then
      begin
        // Dimensionamos la grilla con el tamaño de B
        GrillaResultado.RowCount := filasB + 1;
        GrillaResultado.ColCount := colB + 1;

        // Recorremos y multiplicamos la Matriz B
        for f := 0 to filasB do
          for c := 0 to colB do
          begin
            matrizR[f, c] := matrizB[f, c] * escalar;
            GrillaResultado.Cells[c, f] := IntToStr(matrizR[f, c]);
          end;
      end;

    end;
  end;



//TRASPUESTA DE A
procedure TForm1.BtnTrasAClick(Sender: TObject);
var
  f, c: integer;
begin
  // La grilla de resultado invierte las filas de A por las columnas de A
  GrillaResultado.RowCount := colA + 1;
  GrillaResultado.ColCount := filasA + 1;

  for f := 0 to filasA do
    for c := 0 to colA do
    begin
      // El elemento [f, c] se guarda en la posición cambiada [c, f]
      matrizR[c, f] := matrizA[f, c];
      // En la grilla de destino, la coordenada al revés de [c, f] es .Cells[f, c]
      GrillaResultado.Cells[f, c] := IntToStr(matrizR[c, f]);
    end;
end;

//TRASPUESTA DE B
procedure TForm1.BtnTrasBClick(Sender: TObject);
var
  f, c: integer;
begin
  GrillaResultado.RowCount := colB + 1;
  GrillaResultado.ColCount := filasB + 1;

  for f := 0 to filasB do
    for c := 0 to colB do
    begin
      matrizR[c, f] := matrizB[f, c];
      GrillaResultado.Cells[f, c] := IntToStr(matrizR[c, f]);
    end;
end;

//OPUESTA DE A
procedure TForm1.BtnOpusAClick(Sender: TObject);
var
  f, c: integer;
begin
  GrillaResultado.RowCount := filasA + 1;
  GrillaResultado.ColCount := colA + 1;

  for f := 0 to filasA do
    for c := 0 to colA do
    begin
      matrizR[f, c] := matrizA[f, c] * (-1);    //multiplica x -1 para cambiar el signo
      GrillaResultado.Cells[c, f] := IntToStr(matrizR[f, c]);
    end;
end;

//OPUESTA DE B
procedure TForm1.BtnOpusBClick(Sender: TObject);
var
  f, c: integer;
begin
  GrillaResultado.RowCount := filasB + 1;
  GrillaResultado.ColCount := colB + 1;

  for f := 0 to filasB do
    for c := 0 to colB do
    begin
      matrizR[f, c] := matrizB[f, c] * (-1);
      GrillaResultado.Cells[c, f] := IntToStr(matrizR[f, c]);
    end;
end;

// DETERMINANTE DE A  (solo orden 2 y 3)
procedure TForm1.BtnDeterminanteAClick(Sender: TObject);
var
  det: integer;
  mensajeInversa: string;
begin
  // validar que es una matriz cuadrada
  if filasA = colA then
  begin

    // --- CASO ORDEN 2 ---
    if filasA = 1 then
    begin
      det := (matrizA[0,0] * matrizA[1,1]) - (matrizA[0,1] * matrizA[1,0]);
      // Evaluamos si admite inversa o no
      if det <> 0 then
        mensajeInversa := 'Como el determinante es distinto de 0, la Matriz A es REGULAR (admite matriz inversa).'
      else
        mensajeInversa := 'Como el determinante es 0, la Matriz A es SINGULAR (no admite matriz inversa).';

      ShowMessage('El determinante de la Matriz A (2x2) es: ' + IntToStr(det)+ #13 + #13 + mensajeInversa);
    end

    // --- CASO ORDEN 3  ---
    else if filasA = 2 then
    begin
      // fórmula Regla de Sarrus
      det := (matrizA[0,0] * matrizA[1,1] * matrizA[2,2]) +
             (matrizA[0,1] * matrizA[1,2] * matrizA[2,0]) +
             (matrizA[0,2] * matrizA[1,0] * matrizA[2,1]) -
             (matrizA[0,2] * matrizA[1,1] * matrizA[2,0]) -
             (matrizA[0,0] * matrizA[1,2] * matrizA[2,1]) -
             (matrizA[0,1] * matrizA[1,0] * matrizA[2,2]);

      // Evaluamos si admite inversa o no
      if det <> 0 then
        mensajeInversa := 'Como el determinante es distinto de 0, la Matriz A es REGULAR (admite matriz inversa).'
      else
        mensajeInversa := 'Como el determinante es 0, la Matriz A es SINGULAR (no admite matriz inversa).';

      ShowMessage('El determinante de la Matriz A (3x3) es: ' + IntToStr(det)+ #13 + #13 + mensajeInversa);
    end
    else
    begin
      ShowMessage('Esta función está acotada únicamente para matrices de orden 2 o 3.');
    end;

  end
  else
  begin
    // Si no es cuadrada no se puede calcular
    ShowMessage('¡Operación Imposible! El determinante solo existe para matrices CUADRADAS.' + #13 +
                'La Matriz A actual es de ' + IntToStr(filasA + 1) + 'x' + IntToStr(colA + 1) + '.');
  end;
end;


end.


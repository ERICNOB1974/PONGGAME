Uses
    crt, graph;
 
const
    teclaArriba : char = #$48;
    teclaAbajo  : char = #$50;
    teclaW      : char = 'W';
    teclaS      : char = 'S';
    teclaEsc    : char = #27;
    teclaEnter  : char = #13;
 
type
    pelota = Record
           X, Y, DX, DY : integer;
           Col          : byte;
    End;
 
    barra = Record
          X1, Y1, X2, Y2 : integer;
          Col            : byte;
    End;
 
var
	LaPelota : pelota;
	barraIzq : barra;
	barraDer : barra;
	Cerrar   : boolean;
	p1       : byte;
	p2       : byte;
 
procedure IniciaGraficos;
var
   gn,gd: integer;
begin
     gd:=detect;
     initgraph(gd,gn,'C:\Users\ericn\Desktop\TrabajosPascal\TrabajoFINAL');
end;
 
procedure Sonido(hertz, duracion : word);
begin
     sound(hertz);
     delay(duracion);
     nosound;
end;
 
procedure PintaPelota(Col : Byte);
begin
    setfillstyle(1, Col);
    setcolor(Col);
    fillellipse(LaPelota.X, LaPelota.Y,5,5);
end;
 
procedure MuevePelota;
begin
    PintaPelota(0);
    LaPelota.X := LaPelota.X + LaPelota.DX;
    LaPelota.Y := LaPelota.Y + LaPelota.DY;
 
    if (LaPelota.X > barraDer.X1-6)  then
    begin
        if (LaPelota.Y>barraDer.Y1-6) and (LaPelota.Y<barraDer.Y2+6) then
        begin
            LaPelota.X := barraDer.X1-6;
            Sonido(2000, 5);
            LaPelota.DX := LaPelota.DX * -1;
        end;
        else
        begin
            Sonido(100, 50);
            LaPelota.X := barraIzq.X2+10;
            LaPelota.DY := LaPelota.DY*-1;
            p1 := p1 + 1;
        end;
    end;
 
    if (LaPelota.X < barraIzq.X2+6) then
    begin
        if (LaPelota.Y>barraIzq.Y1-6) and (LaPelota.Y<barraIzq.Y2+6) then
        begin
            LaPelota.X := barraIzq.X2+6;
            Sonido(2000, 5);
            LaPelota.DX := LaPelota.DX * -1;
        end
        else
        begin
            Sonido(100, 50);
            LaPelota.X := barraDer.X1-10;
            LaPelota.DY := LaPelota.DY*-1;
            p2 := p2 + 1;
        end;
    end;
 
    if LaPelota.Y > 468 then
    begin
        LaPelota.Y := 467;
        Sonido(1000, 5);
        LaPelota.DY := LaPelota.DY * -1;
    end;
 
    if LaPelota.Y < 61 then
    begin
        LaPelota.Y := 62;
        Sonido(1000, 5);
        LaPelota.DY := LaPelota.DY * -1;
    end;
 
    PintaPelota(LaPelota.Col);
end;
 
procedure PintaBarra(Col, Tipo : Byte);
begin
     setfillstyle(1, Col);
     setcolor(Col);
     if (Tipo=1) then
     begin
	bar(barraIzq.X1,barraIzq.Y1,barraIzq.X2,barraIzq.Y2);
     end
     else
     begin
	bar(barraDer.X1,barraDer.Y1,barraDer.X2,barraDer.Y2);
     end;
end;
 
procedure MueveBarra(arriba:boolean; Tipo:byte);
var
    color:byte;
begin
     PintaBarra(0,Tipo);
     if (arriba=True) then
     begin
          if (Tipo=1) then
	  begin
	       barraIzq.Y1 := barraIzq.Y1 - 25;
	       barraIzq.Y2 := barraIzq.Y2 - 25;
	  end
	  else
	  begin
	       barraDer.Y1 := barraDer.Y1 - 25;
	       barraDer.Y2 := barraDer.Y2 - 25;
	  end;
     end
     else
     begin
          if (Tipo=1) then
	  begin
	       barraIzq.Y1 := barraIzq.Y1 + 25;
	       barraIzq.Y2 := barraIzq.Y2 + 25;
	  end
	  else
	  begin
	       barraDer.Y1 := barraDer.Y1 + 25;
	       barraDer.Y2 := barraDer.Y2 + 25;
	  end;
     end;
     if (Tipo=1) then
     begin
          if (barraIzq.Y1<60) then
	  begin
	       barraIzq.Y1:=61;
	       barraIzq.Y2:=111;
	  end;
	  if (barraIzq.Y2>470) then
	  begin
	       barraIzq.Y1:=420;
	       barraIzq.Y2:=470;
	  end;
     end
     else
     begin
          if (barraDer.Y1<60) then
	  begin
	       barraDer.Y1:=61;
               barraDer.Y2:=111;
	  end;
	  if (barraDer.Y2>470) then
	  begin
	       barraDer.Y1:=420;
               barraDer.Y2:=470;
	  end;
     end;
     if (Tipo=1) then
     begin
          color:=barraIzq.Col;
     end
     else
     begin
          color:=barraDer.Col;
     end;
     PintaBarra(color,Tipo);
end;
 
procedure Inicializa;
begin
     cleardevice;
     setfillstyle(1,15);
     bar(0,50,639,55);
     bar(0,474,639,479);
     Randomize;
     p1 := 0;
     p2 := 0;
     settextstyle(0,0,2);
     outtextxy(235,18, 'P1');
     outtextxy(375,18, 'P2');
     rectangle(270,10,320,40);
     rectangle(321,10,371,40);
     LaPelota.X := 150 + Random(20);
     LaPelota.Y := 100;
     LaPelota.Col := 15;
     LaPelota.DX := 1;
     LaPelota.DY := -1;
     barraIzq.X1 := 1;
     barraIzq.X2 := 6;
     barraIzq.Y1 := 215;
     barraIzq.Y2 := 265;
     barraIzq.Col := 15;
     barraDer.X1 := 633;
     barraDer.X2 := 638;
     barraDer.Y1 := 215;
     barraDer.Y2 := 265;
     barraDer.Col := 15;
     PintaBarra(barraIzq.Col, 1);
     PintaBarra(barraDer.Col, 2);
     PintaPelota(LaPelota.Col);
end;
 
procedure LeeTeclado;
var
    Ch : Char;
begin
     if KeyPressed Then
     begin
          Ch := UpCase(ReadKey);
	  if (Ch=teclaEsc) then
	  begin
	       Cerrar:=True;
	  end;
	  if (Ch=teclaW) then
	  begin
	       MueveBarra(True,1);
	  end;
	  if (Ch=teclaS) then
	  begin
	       MueveBarra(False,1);
	  end;
	  if (Ch=teclaArriba) then
	  begin
	       MueveBarra(True,2);
	  end;
	  if (Ch=teclaAbajo) then
	  begin
	       MueveBarra(False,2);
	  end;
     end;
end;
 
procedure Marcador;
var
	marc : string;
begin
    setfillstyle(1,0);
    bar(290,18,305,32);
    str(p1,marc);
    outtextxy(290,18,marc);
    bar(340,18,355,32);
    str(p2,marc);
    outtextxy(340,18,marc);
end;
 
procedure fin(jugador:string);
var
    ch:char;
begin
    setfillstyle(1,8);
    bar(240,220,415,270);
    setfillstyle(1,15);
    bar(235,215,410,265);
    setcolor(0);
    outtextxy(245,230,jugador);
    outtextxy(275,230,' ganador');
    repeat
        Ch := UpCase(ReadKey);
        if (Ch=teclaEnter) then
        begin
            Cerrar:=True;
        end;
    until(Cerrar=True);
end;
 
 
procedure Juega;
var
	i : integer;
begin
     repeat
           MuevePelota;
	   Delay(3);
	   for i:=1 to 25 do
               LeeTeclado;
	   Marcador;
	   if (p1=7) then
	   begin
	        fin('p1');
	   end;
	   if (p2=7) then
	   begin
	        fin('p2');
	   end;
     until Cerrar = true;
end;
 
begin
     IniciaGraficos;
     Inicializa;
     Juega;
     textmode(2);
end.
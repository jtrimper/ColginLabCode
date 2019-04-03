
{$R-}    {Range checking off}
{$S+}    {Stack checking on}
{$I+}    {I/O checking on}
{$N-}    {No numeric coprocessor}

PROGRAM XLTX2IML(INPUT,OUTPUT);

{ $M 30000,30000,65000 }
{ $M 20000,20000,45000 }

{$M 65520,0,510000}

Uses
  Crt,
  Dos,
  Printer;
  {GRAPH;
   }
TYPE
      r1array=array[1..100] of real;
      strng256 = string[128];
      strng128 = string[128];
      strng100 = string[100];
      strng20 = string[20];

var filename,xfilename,yfilename: strng100;
    Strng,ext: string[4];
    ch:char;
    z: r1array;
    i,err,xDim,zDim,PerSample: integer;

procedure Replace_comma_with_dot(Var Value: strng256);
var i: integer;
begin
  for i:=1 to Length(Value) do
  begin
    if Value[i]=',' then Value[i]:='.';
  end;
end;

procedure Split_Data(nr,FXMax:integer);

var gfil,nfil: text;
    Gnamn,Line,Nyline,Text_Value: strng256;
    K,Kact,I,j,Length_of_column: integer;
    Colwidth: r1array;
    end_of_item: char;
    Strng: string[2];
begin
  for K:=1 to FXMax do Colwidth[K]:=1;
  for Kact:=1 to 2 do
  begin
{    Assign(gfil,'\circ\pigtbh.txt');
 }  Assign(gfil,'\DAT\'+ParamStr(1)+'.txt');
    Assign(nfil,'\matlab\toolbox\menu\interml.var');
    rewrite(nfil);reset(gfil);
    Str(Kact,Strng);
    end_of_item:=chr(9);
{    end_of_item:=',';        }
    I:=0;
    if not EOF(gfil) then
    repeat
      readln(gfil,Line);
{      readln(gfil,Line); }
{      writeln(Line); Ch:=ReadKey; if Ch='x' then Halt;}
      I:=I+1; NyLine:='';
      for K:=1 to FXmax do
      begin
        Length_of_column:=Pos(end_of_item,Line);
        if Length_of_column=0 then Length_of_column:=Length(Line)+1;
        if Kact=1 then if (Length_of_column>Colwidth[K]) then colwidth[K]:=Length_of_column;
        if Length_of_column>1 then Text_Value:=Copy(Line,1,Length_of_column-1)
        else Text_Value:='?';
  {      for j:=1 to 10 do
        begin
          if Text_Value[1]=' ' then Text_Value:=Copy(Text_Value,2,Length(Text_Value));
        end;  }
        if Text_Value='' then Text_Value:='?';
 {       Replace_comma_with_dot(Text_Value);
        if Text_Value='?' then Text_Value:='NaN';
        if Kact=2 then while Length(Text_Value)<Colwidth[K] do Text_Value:=' '+Text_value;
  }    {  if k=nr then} Nyline:=Text_Value;
        Line:=Copy(Line,Length_of_column+1,Length(Line));
        if Text_Value='' then Text_Value:=' ';
   {     if k=FXMAX then } writeln(Nfil,Nyline);
      end;
{      write('.');
 }   until (I=1{EOF(gfil)});
    close(nfil); close(gfil);
  end;
end;

BEGIN
   Val(ParamStr(2),xDim,err);
   writeln('xDim=',xdim);
   Split_Data(i,xDim);
END.

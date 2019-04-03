{$R-}    {Range checking off}
{$S+}    {Stack checking on}
{$I+}    {I/O checking on}
{$N-}    {No numeric coprocessor}

PROGRAM str2asc(INPUT,OUTPUT);

{ $M 30000,30000,65000 }
{ $M 20000,20000,45000 }

{$M 65520,0,510000}

Uses
  Crt,
  Dos,
  Printer;

TYPE  r1array=array[1..100] of real;
      strng128 = string[128];
      strng100 = string[100];
      strng20 = string[20];

var Strng,ext: string[4];
    ch:char;
    z: r1array;
    err: integer;


procedure Split_Data(FXMax:integer);

var gfil,nfil: text;
    Gnamn,Line,Nyline,Text_Value: strng128;
    K,Kact,I,Length_of_column: integer;
    Colwidth: integer;
    end_of_item: char;
    Strng: string[3];
begin
  Colwidth:=1;
  for Kact:=1 to 2 do
  begin
    Assign(gfil,'\matlab\toolbox\menu\interml.var');
    Assign(nfil,'\matlab\toolbox\menu\interml.asc');
    rewrite(nfil);reset(gfil);
    Str(Kact,Strng);
    end_of_item:=chr(9);
    I:=0;
    if not EOF(gfil) then
    repeat
      readln(gfil,Line);
{      writeln(Line); Ch:=ReadKey; if Ch='x' then Halt;
 }     I:=I+1; NyLine:='';
      FXMAX:=Length(Line);
      if FXMAX>Colwidth then Colwidth:=FXMAX;
      for K:=1 to FXmax do
      begin
        Text_Value:=Copy(Line,k,1); Ch:=Text_Value[1];
  {      writeln('k:',k,Text_Value,Ord(Ch));
   }     Str(Ord(Ch),Strng);
        Text_Value:=Strng;
        while Length(Text_Value)<3 do Text_Value:=' '+Text_value;
        Nyline:=Nyline+' '+Text_Value;
      end;
      for i:=1 to Colwidth-FXMAX do NyLine:=Nyline+'  32';
      writeln(Nfil,Nyline);
    until (EOF(gfil));
    close(nfil); close(gfil);
  end;
end;

BEGIN
   Split_Data(18);
END.

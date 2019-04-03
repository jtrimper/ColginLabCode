Nummer=1; Time=0;
AntalEnheter=3;
A(1)=1; A(2)=1; A(3)=1; B(1)=0; B(2)=0;
NextTime=20*rand; Nummer=1;
Time=NextTime;
for k=1:10;
Time=NextTime;
if (Nummer<AntalEnheter),
 if (A(Nummer)==0),
   A(Nummer)=1;
   B(Nummer)=Time;
   NextTime=Time+20*rand;
   disp(['Enhet nr ',num2str(Nummer),' lagad vid tiden ',num2str(Time)])
   if (Nummer==1), C1=[C1,Time]; end
   if (Nummer==2), D1=[D1,Time]; end
 else
   A(Nummer)=0;
   NextTime=Time+5*rand;      % NextTime talar om när det skall hända ngt
                              % härnäst med enheten
   disp(['Enhet nr ',num2str(Nummer),' trasig vid tiden ',num2str(Time)])
   if (Nummer==1), C0=[C0,Time]; end
   if (Nummer==2), D0=[D0,Time]; end
   if (Time-B(3-Nummer)<0),  % Om andra enheten är yngre än 2 repareras den ej
     % nothing               
   else
     if (A(3-Nummer)==0),     % Om andra enheten redan är under reparation 
                              % skall ingen reparatör tillkallas
     else
       disp(['Andra enheten byts också '])
       B(3-Nummer)=Time;
       Nummer=3-Nummer;
       NextTime=Time+20*rand;
     end
   end
 end
else
 disp(['Tid ',num2str(Time)])
 NextTime=Time+100; % Går in var hundrade tidsenhet och skriver ut tiden
end
S=0;
for i=1:AntalEnheter-1,
  S=S+A(i);
end %for
disp(['Antal hela enheter: ',num2str(S)])
end







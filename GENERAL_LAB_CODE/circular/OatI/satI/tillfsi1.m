Nummer=1; Time=0;
AntalEnheter=2; Big=1000000.0;
A(1)=1; A(2)=1; A(3)=1; B(1)=0; B(2)=0;
AliveTime1=[0]; DeathTime1=[Big];
AliveTime2=[0]; DeathTime2=[Big];
AliveTime1(1)=20*rand;
AliveTime2(1)=20*rand;
if (AliveTime1(length(AliveTime1))<AliveTime2(length(AliveTime2))),
  Nummer=1;
  NextTime=AliveTime1(length(AliveTime1));
else
  Nummer=2;
  NextTime=AliveTime2(length(AliveTime1));
end
for k=1:40;
Time=NextTime;
if (Nummer<=AntalEnheter),
 if (A(Nummer)==0),
   A(Nummer)=1;
   B(Nummer)=Time;
   if (Nummer==1),
      AliveTime1=[AliveTime1,Time+20*rand];
   else
      AliveTime2=[AliveTime2,Time+20*rand];
   end
   NextTime=Time+20*rand;
   disp(['Enhet nr ',num2str(Nummer),' lagad vid tiden ',num2str(Time)])
 else
   A(Nummer)=0;
   if (Nummer==1),
      DeathTime1=[DeathTime1,Time+5*rand];
   else
      DeathTime2=[DeathTime2,Time+5*rand];
   end
%   NextTime=Time+5*rand;      % NextTime talar om när det skall hända ngt
%                              % härnäst med enheten
   disp(['Enhet nr ',num2str(Nummer),' trasig vid tiden ',num2str(Time)])
   if (Time-B(3-Nummer)<2),  % Om andra enheten är yngre än 2 repareras den ej
     % nothing               
   else
     if (A(3-Nummer)==0),   % Om andra enheten redan är under reparation 
       % nothing            % (dvs är trasig) skall ingen reparatör tillkallas
     else
       disp(['Andra enheten byts också '])
       if (Nummer==1),
         AliveTime2(length(AliveTime2))=Time+20*rand;
       else
         AliveTime1(length(AliveTime1))=Time+20*rand;
       end       
       B(3-Nummer)=Time;
%%%       Nummer=3-Nummer;
       t=[];
 %      if (length(AliveTime1)>=1),
 %          t(1)=AliveTime1(length(AliveTime1));
 %      else
 %          t(1)=exp(10);
 %      end
 %      if (length(AliveTime2)>=1),
 %          t(2)=AliveTime2(length(AliveTime2));
 %      else
 %          t(2)=exp(10)
 %      end
 %      if (DeathTime1~=[]),
 %          t(3)=DeathTime1(length(DeathTime1));
 %      else
 %          t(3)=exp(10);
 %      end
 %      if (DeathTime2==[]),
 %          t(4)=exp(10);
 %      else
 %          t(4)=DeathTime2(length(DeathTime2));
 %      end
 %      if (Nummer==1), t(1)=Big; end;
 %      if (Nummer==2), t(2)=Big; end;
 %      [t0,i]=min(t)
 %      t
 %      if ((i==1)|(i==3)), Nummer=1; end;
 %      if ((i==2)|(i==3)), Nummer=2; end;
 %      NextTime=t0;
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
%disp(['Antal hela enheter: ',num2str(S)])
       t=[];
       t(1)=AliveTime1(length(AliveTime1));
       t(2)=AliveTime2(length(AliveTime2));
       t(3)=DeathTime1(length(DeathTime1));
       t(4)=DeathTime2(length(DeathTime2));
       if (Nummer==1), t(1)=Big; end;
       if (Nummer==2), t(2)=Big; end;
       for i=1:4,
           if (t(i)<=Time), t(i)=Big; end;
       end
       [t0,i]=min(t);
       if ((i==1)|(i==3)), Nummer=1; end;
       if ((i==2)|(i==4)), Nummer=2; end;
       NextTime=t0;
end







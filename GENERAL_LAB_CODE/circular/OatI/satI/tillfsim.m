NbrofEvents=40;
AntalEnheter=2; Big=1000000.0; Super=10000000000.0; 
A(1)=1; A(2)=1; A(3)=1; B(1)=0; B(2)=0;
AliveTime1=[0]; DeathTime1=[Big];
AliveTime2=[0]; DeathTime2=[Big]; SkrivTid=[-100];
AliveTime1(1)=20*rand;
AliveTime2(1)=20*rand;
if (AliveTime1(length(AliveTime1))<AliveTime2(length(AliveTime2))),
  Nummer=1;
  NextTime=AliveTime1(length(AliveTime1));
else
  Nummer=2;
  NextTime=AliveTime2(length(AliveTime1));
end
Nummer=3;
NextTime=0;
for k=1:NbrofEvents;
Time=NextTime;
if (Nummer<=AntalEnheter),
 if (A(Nummer)==0),
   A(Nummer)=1;
   B(Nummer)=Time;
   NextTime=Time+20*rand;
   if (Nummer==1),
      AliveTime1=[AliveTime1,NextTime];
   else
      AliveTime2=[AliveTime2,NextTime];
   end
   disp(['Enhet nr ',num2str(Nummer),' lagad vid tiden ',num2str(Time)])
 else
   A(Nummer)=0;
   NextTime=Time+5*rand;
   if (Nummer==1),
      DeathTime1=[DeathTime1,NextTime];
   else
      DeathTime2=[DeathTime2,NextTime];
   end
   disp(['Enhet nr ',num2str(Nummer),' trasig vid tiden ',num2str(Time)])
   if (Time-B(3-Nummer)<2),  % Om andra enheten är yngre än 2 repareras den ej
     % nothing               
   else
     if (A(3-Nummer)==0),   % Om andra enheten redan är under reparation 
       % nothing            % (dvs är trasig) skall ingen reparatör tillkallas
     else
       disp(['Andra enheten byts också '])
       NextTime=Time+20*rand;
       if (Nummer==1),
         AliveTime2(length(AliveTime2))=NextTime;
       else
         AliveTime1(length(AliveTime1))=NextTime;
       end       
       B(3-Nummer)=Time;
     end
   end
 end
else
 disp(['Tid ',num2str(Time)])
 SkrivTid=[SkrivTid,Time+100]; % Går in var hundrade tidsenhet och skriver ut tiden
end
S=0;
for i=1:AntalEnheter,
  S=S+A(i);
end %for
disp(['Antal hela enheter: ',num2str(S)])
       t=[];
       t(1)=AliveTime1(length(AliveTime1));
       t(2)=AliveTime2(length(AliveTime2));
       t(3)=DeathTime1(length(DeathTime1));
       t(4)=DeathTime2(length(DeathTime2));
       t(5)=SkrivTid(length(SkrivTid));
       for i=1:5,
           if (t(i)<=Time), t(i)=Super; end;
       end
       [t0,i]=min(t);
       if ((i==1)|(i==3)), Nummer=1; end;
       if ((i==2)|(i==4)), Nummer=2; end;
       if (i==5), Nummer=3; end;
       NextTime=t0;
end











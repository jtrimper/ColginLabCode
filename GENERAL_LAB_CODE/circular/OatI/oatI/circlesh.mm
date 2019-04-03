% circlesh
%
% A menu shell for circular data analysis.
%
% CALL: circlesh
%
% Copyright (C) 1993, Bjorn Holmquist, Dept of Math. Stat., University of Lund.
%
global FontSize
global htext
global htextcount
global X
global loaded
global casesymbol
global Describe
htextcount=0;  
FontSize=9;
htext=[];
casesymbol=['o','x','+','*','.'];
casecolor=['y','m','c','r','s','b','w','k'];
  r=0.0; A=[0.0;0];
%  f1=figure('NumberTitle','off','Name','     ','Pointer','crosshair');
  f1=figure('NumberTitle','off','Name','SAT','Pointer','crosshair');
%  f1=figure('NumberTitle','off','Name','Circular Plot','Pointer','crosshair');
  g1=uimenu(f1,'Label','Files','Accelerator','s','Position',1);
  g2=uimenu(f1,'Label','Edit','Position',2);
%  g3=uimenu(f1,'Label','Select','Position',3);
  g3=uimenu(f1,'Label','Tools','Position',3);
  g3p1=uimenu(g3,'Label','sectplot','Callback','shg3p1','Position',1);
  g3p2=uimenu(g3,'Label','circplot','Position',2);
    g3p2p1=uimenu(g3p2,'Label','with circle','Callback','circ=1; shg3p2','Position',1);
    g3p2p2=uimenu(g3p2,'Label','without circle','Callback','circ=0; shg3p2','Position',2);
  g3p7=uimenu(g3,'Label','doubleplot','Callback','shg3p2a','Position',2);
  g3p5=uimenu(g3,'Label','circplot 2','Callback','shg3p5','Position',5);
  g3p3=uimenu(g3,'Label','table','Callback','tabmenu','Position',3);
  g3p4=uimenu(g3,'Label','select','Callback','selmenu','Position',4);
  g3p6=uimenu(g3,'Label','circplot m','Callback','shg3p6','Position',6);
  g4=uimenu(f1,'Label','Font','Position',4);
  g6=uimenu(f1,'Label','Stats','Position',5);
  g6p1=uimenu(g6,'Label','Univariate Stats','Position',1);
  g6p2=uimenu(g6,'Label','Multivariate Stats','Position',2);
  g6p3=uimenu(g6,'Label','Circular Stats','Position',3);
  g6p4=uimenu(g6,'Label','Linear-Circular Stats','Position',4);
 %uimenu(g,'Label','Rotate1','Callback','rayrot2','Position',4);
  g1p1=uimenu(g1,'Label','Use file','Callback','usemenu','Position',1);
%94  g1p1=uimenu(g1,'Label','XLtxt2MLtxt','Callback','shg1p1','Position',1);
%94  uimenu(g1,'Label','Load8(1-20)','Callback','ldxl2ml8; var=getvars(0); begin8; M=Ang(:,1)','Position',2);
%94  uimenu(g1,'Label','Load12(1-23)','Callback','ldxl2ml2; var=getvars(0); begin12; M=Ang(:,1)','Position',3);
%94  uimenu(g1,'Label','Load(1-18)','Callback','ldxl2ml1; var=getvars(0); begin','Position',4);
%94  uimenu(g1,'Label','Load vM','Callback','M=vm(2,120,50,''deg''); circle(M,''degrees''); hold on','Position',5);
%94  uimenu(g1,'Label','Save','Position',4);
  g1p5=uimenu(g1,'Label','Clear','Callback','cla, htext=[];','Position',5);
%94  g1p6=uimenu(g1,'Label','Save As ...','Position',6);
  g1p7=uimenu(g1,'Label','Print','Callback','shg1p7','Position',7);
  g1p8=uimenu(g1,'Label','Orientation','Callback','shg1p8','Position',8);
%94  g1p9=uimenu(g1,'Label','Save Plot','Callback','shg1p9','Position',9);
  %uimenu(g,'Label','Rotate2','Callback','view([10 80])','Position',5);
  uimenu(g1,'Label','Quit','Position',7);
% g2 = Edit  
  g21=uimenu(g2,'Label','Assign Roles','Callback','assmenu','Position',1);
  g2p3=uimenu(g2,'Label','Mean vector','Position',3);
    g2p3p1=uimenu(g2p3,'Label','with text','Callback','shg2p3','Position',1);
    g2p3p2=uimenu(g2p3,'Label','without text','Callback','shg2p3a','Position',2);
    g2p3p3=uimenu(g2p3,'Label','text only','Callback','shg2p2','Position',3);
    g2p3p4=uimenu(g2p3,'Label','Remove','Callback','shg2p8','Position',4);
  g2p4=uimenu(g2,'Label','Mean axis','Position',5);
    g2p4p1=uimenu(g2p4,'Label','with text','Callback','shg2p4','Position',1);
    g2p4p2=uimenu(g2p4,'Label','without text','Callback','shg2p4a','Position',2);
    g2p4p3=uimenu(g2p4,'Label','Remove','Callback','shg2p9','Position',3);
  g2p5=uimenu(g2,'Label','Mean vector sector','Callback',...
         'shg2p5','Position',7);
  g2p6=uimenu(g2,'Label','Mean axis sector','Callback','shg2p6','Position',8);
  g2p7=uimenu(g2,'Label','Sun ...','Position',9);
  uimenu(g2p7,'Label','Sunrise','Callback','[sol,sunr]=circmean(X(sample,vnrld(10,loaded))); sunrise([1.25*sol(2) 1.25*sol(1)]);','Position',1);
  uimenu(g2p7,'Label','Sun','Callback','[sol,sunr]=circmean(X(sample,vnrld(10,loaded))); sun([1.25*sol(2) 1.25*sol(1)]);','Position',2);
  uimenu(g2p7,'Label','Sunset','Callback',...
    '[sol,sunr]=circmean(X(sample,vnrld(10,loaded))); sunset([1.25*sol(2) 1.25*sol(1)]);','Position',3);
  g2p10=uimenu(g2,'Label','Home direction','Callback','shg2p10','Position',12);
  g2p11=uimenu(g2,'Label','Wind direction','Callback','shg2p11','Position',13);
  g2p12=uimenu(g2,'Label','gtext','Callback','shg2p12','Position',14);
  g2p13=uimenu(g2,'Label','text','Callback','shg2p13','Position',15);
  g2p14=uimenu(g2,'Label','Mean vector conf. int.','Position',4);
    uimenu(g2p14,'Label','Fisher and Lewis','Callback','shg2p14','Position',1);
    uimenu(g2p14,'Label','Holmquist','Callback','shg2p14b','Position',2);
  g2p15=uimenu(g2,'Label','Mean axis conf. int.','Position',6);
  uimenu(g2p15,'Label','Prentice','Callback','shg2p15','Position',1);
  uimenu(g2p15,'Label','Holmquist 1','Callback','shg2p15b','Position',2);
  uimenu(g2p15,'Label','Holmquist 2','Callback','shg2p15c','Position',3);
  g2p16=uimenu(g2,'Label','Median vector','Callback','shg2p16','Position',16);
  g2p17=uimenu(g2,'Label','Median vector conf. int.','Callback','shg2p17','Position',17);
  g2p18=uimenu(g2,'Label','Broken axis','Callback','shg2p18','Position',18);
  g2p19=uimenu(g2,'Label','Uni, bi, broken','Callback','shg2p3a; shg2p4a; shg2p18','Position',19);
%  uimenu(g21,'Label','Var1','Callback','M=ciplvar(1,Y,loaded)','Position',1);
% g4 = Font  
  g4p1=uimenu(g4,'Label','Type','Position',1);
    uimenu(g4p1,'Label','Roman','Callback',...
      'set(htext,''FontName'',''Roman'')','Position',1);
    uimenu(g4p1,'Label','Serif','Callback',...
      'set(htext,''FontName'',''Serif'')','Position',2);
    uimenu(g4p1,'Label','Terminal','Callback',...
      'set(htext,''FontName'',''Terminal'')','Position',3);
    uimenu(g4p1,'Label','System','Callback',...
      'set(htext,''FontName'',''System'')','Position',4);
  g4p2=uimenu(g4,'Label','Size','Position',2);
    uimenu(g4p2,'Label','7','Callback',...
      'FontSize=7; set(htext,''FontSize'',7)','Position',1);
    uimenu(g4p2,'Label','8','Callback',...
      'FontSize=8; set(htext,''FontSize'',8)','Position',2);
    uimenu(g4p2,'Label','9','Callback',...
      'FontSize=9; set(htext,''FontSize'',9)','Position',3);
    uimenu(g4p2,'Label','10','Callback',...
      'FontSize=10; set(htext,''FontSize'',10)','Position',4);
    uimenu(g4p2,'Label','12','Callback',...
      'FontSize=12; set(htext,''FontSize'',12)','Position',5);
    uimenu(g4p2,'Label','14','Callback',...
      'FontSize=14; set(htext,''FontSize'',14)','Position',6);
    uimenu(g4p2,'Label','20','Callback',...
      'FontSize=20; set(htext,''FontSize'',20)','Position',7);
    uimenu(g4p2,'Label','30','Callback',...
      'FontSize=30; set(htext,''FontSize'',30)','Position',8);
    uimenu(g4p2,'Label','40','Callback',...
      'FontSize=40; set(htext,''FontSize'',40)','Position',9);
  g4p3=uimenu(g4,'Label','Angle','Position',3);
    uimenu(g4p3,'Label','Normal','Callback',...
      'set(htext,''FontAngle'',''normal'')','Position',1);
    uimenu(g4p3,'Label','Italic','Callback',...
      'set(htext,''FontAngle'',''italic'')','Position',2);
    uimenu(g4p3,'Label','Oblique','Callback',...
      'set(htext,''FontAngle'',''oblique'')','Position',3);
  g4p4=uimenu(g4,'Label','Weight','Position',4);
    uimenu(g4p4,'Label','Light','Callback',...
      'set(htext,''FontWeight'',''light'')','Position',1);
    uimenu(g4p4,'Label','Normal','Callback',...
      'set(htext,''FontWeight'',''normal'')','Position',2);
    uimenu(g4p4,'Label','Demi','Callback',...
      'set(htext,''FontWeight'',''demi'')','Position',3);
    uimenu(g4p4,'Label','Bold','Callback',...
      'set(htext,''FontWeight'',''bold'')','Position',4);
% g6 = Stats
% g6p1 = Univariate Stats
%  g6p1p1=uimenu(g6p1,'Label','Mean,std,...','Callback','shg6p1','Position',1);
  g6p1p1=uimenu(g6p1,'Label','Descriptive Statistics','Position',1);
    g6p1p1p1=uimenu(g6p1p1,'Label','Numerical Descr Stats','Position',1);
      uimenu(g6p1p1p1,'Label','Mean,std,...','Callback',...
            'Describe=1; desmenu','Position',1);
    g6p1p1p2=uimenu(g6p1p1,'Label','*Graphical Descr Stats','Position',2);
      uimenu(g6p1p1p2,'Label','*Histogram','Callback',...
    'FigName=[''Histogram'']; mCallback='' ''; input1;','Position',1);
      uimenu(g6p1p1p2,'Label','*Polygon','Callback',...
    'FigName=[''Polygon'']; mCallback='' ''; input1;','Position',2);
      uimenu(g6p1p1p2,'Label','*Cum histogram','Callback',...
    'FigName=[''Cumulative histogram'']; mCallback='' ''; input1;','Position',3);
      uimenu(g6p1p1p2,'Label','*Ogive','Callback',...
    'FigName=[''Ogive'']; mCallback='' ''; input1;','Position',4);
    g6p1p2=uimenu(g6p1,'Label','One Sample Tests','Position',2);
  uimenu(g6p1p2,'Label','Student''s t-test','Callback',...
    'shg6p2p1','Position',1);
  uimenu(g6p1p2,'Label','Kolmogorov-Smirnovs''s test','Callback',...
    'FigName=[''Kolmogorov-Smirnovs '' ''test'']; mCallback='' ''; input1;',...
    'Position',2);
  uimenu(g6p1p2,'Label','Lilliefors'' test','Callback',...
    'FigName=[''Lilliefors '' ''test'']; mCallback='' ''; input1;',...
    'Position',3);
  g6p1p3=uimenu(g6p1,'Label','Two Sample Tests','Position',3);
  uimenu(g6p1p3,'Label','Kolmogorov-Smirnovs''s test','Callback',...
    'FigName=[''Kolmogorov-Smirnovs '' ''test'']; mCallback=''rks''; input2;',...
    'Position',1);
  uimenu(g6p1p3,'Label','Student''s t-test','Callback',...
    'shg6p3p1','Position',2);
  uimenu(g6p1p3,'Label','Wilcoxon-Mann-Whitney','Callback',...
    'FigName=[''Wilcoxon-Mann-Whitneys test''];mCallback=''rwmw'';input2;',...
    'Position',3);
%   'wilcoxon(x,y)','Position',3);
  uimenu(g6p1p3,'Label','Chi-square homogeneity test','Callback',...
    'shg6p3p5','Position',4);
  g6p1p6=uimenu(g6p1,'Label','Multi Sample Tests','Position',4);
  uimenu(g6p1p6,'Label','One-Way Anova','Callback',...
   'assmenu; anova1(y,xc);','Position',1);
  uimenu(g6p1p6,'Label','Kruskal-Wallis'' test','Callback',...
   'assmenu; [R,n,p,h]=kruswall(y,xc);','Position',2);
  uimenu(g6p1p6,'Label','Friedman''s test','Position',3);
  uimenu(g6p1p6,'Label','Bartlett''s test','Position',4);
  uimenu(g6p1p6,'Label','*Chi-square homogeneity test','Callback',...
    '   ','Position',5);
  g6p1p4=uimenu(g6p1,'Label','Regression','Position',5);
  uimenu(g6p1p4,'Label','Linear Regression','Callback',...
    'shg6p4p1','Position',1);
  uimenu(g6p1p4,'Label','Multiple Regression','Callback',...
    'assmenu; multreg(y,XX);','Position',2);
  g6p1p5=uimenu(g6p1,'Label','Confidence sets','Position',6);
  uimenu(g6p1p5,'Label','Mean (real line)','Callback','shg6p5p1','Position',1);
%  uimenu(g6p1p5,'Label','Mean direction (circular)','Callback',...
%    'shg6p5p2','Position',2);
%  uimenu(g6p1p5,'Label','Mean axis (circular)','Callback',...
%    'shg6p5p3','Position',3);
%  uimenu(g6p1p5,'Label','Mean direction (spherical)','Callback',...
%    'shg6p2p1','Position',3);
  g6p1p6=uimenu(g6p1,'Label','Graphical Descr Stats','Position',7);
  g6p1p6p1=uimenu(g6p1p6,'Label','Histogram','Callback',...
             'assmenu; hist1(y,xc);','Position',1);
  g6p1p6p2=uimenu(g6p1p6,'Label','Cumulative histogram','Callback',...
             'assmenu; cumhist(y);','Position',2);
  g6p1p6p3=uimenu(g6p1p6,'Label','Polygon','Callback',...
             'assmenu; polygon(y);','Position',3);
  g6p1p6p4=uimenu(g6p1p6,'Label','Ogive (Cum. polygon)','Callback',...
             'assmenu; cumpolyg(y);','Position',4);
%
% g6p2 = Multivariate Stats
  g6p2p1=uimenu(g6p2,'Label','Numerical Descr Stats','Position',1);
  g6p2p1p1=uimenu(g6p2p1,'Label','Mean,std,...','Position',1);
  g6p2p2=uimenu(g6p2,'Label','One Sample Tests','Position',2);
  uimenu(g6p2p2,'Label','Hotelling''s T2-test','Position',1);
  g6p2p3=uimenu(g6p2,'Label','Two Sample Tests','Position',3);
  uimenu(g6p2p3,'Label','Hotelling''s T2-test','Position',1);
  g6p2p6=uimenu(g6p2,'Label','Multi Sample Tests','Position',4);
  uimenu(g6p2p6,'Label','One-Way Manova','Position',1);
  uimenu(g6p2p6,'Label','Puri-Sen''s test','Position',2);
  g6p2p7=uimenu(g6p2,'Label','Multivariate Regression','Position',5);
%
% g6p3 = Circular Stats
  g6p3p1=uimenu(g6p3,'Label','Numerical Descr Stats','Position',1);
  uimenu(g6p3p1,'Label','Direction,vector length,...',...
             'Callback','Describe=2; desmenu','Position',1);
  g6p3p2=uimenu(g6p3,'Label','One Sample Tests','Position',2);
  g6p3p2p1=uimenu(g6p3p2,'Label','Test for uniformity','Position',1);
  g6p3p2p2=uimenu(g6p3p2,'Label','Test for bi-symmetry','Position',2);
  g6p3p2p3=uimenu(g6p3p2,'Label','*All of the above','Position',3);
  uimenu(g6p3p2p1,'Label','Watson''s Un','Callback',...
    'FigName=[''Watsons Un '' ''test'']; mCallback=''rwatun''; input1;',...
    'Position',1);
  uimenu(g6p3p2p1,'Label','Kuipers''s test','Callback',...
    'FigName=[''Kuipers test'']; mCallback=''rkuiper''; input1;',...
    'Position',2);
  uimenu(g6p3p2p1,'Label','Hodges-Ajne''s test','Callback',...
    'FigName=[''Hodges-Ajnes test'']; mCallback=''rha''; input1;',...
    'Position',3);
  uimenu(g6p3p2p1,'Label','*Rao''s average chi-square test','Callback',...
    'FigName=[''Raos average chi-square test'']; mCallback='' ''; input1;',...
    'Position',4);
  uimenu(g6p3p2p1,'Label','*Lehmacher-Lienert-Batschelet''s test','Callback',...
    'FigName=[''Lehmacher-Lienert-Batschelets test'']; mCallback='' ''; input1;',...
    'Position',5);
  uimenu(g6p3p2p1,'Label','*Chi-square test','Callback',...
    'FigName=[''chi-square test'']; mCallback='' ''; input1;',...
    'Position',6);
  uimenu(g6p3p2p1,'Label','*Range test','Callback',...
    'FigName=[''Range test'']; mCallback='' ''; input1;',...
    'Position',7);
  uimenu(g6p3p2p1,'Label','*Rao''s spacing test','Callback',...
    'FigName=[''Raos spacing test'']; mCallback='' ''; input1;',...
    'Position',8);
  uimenu(g6p3p2p1,'Label','*Cox''s test','Callback',...
    'FigName=[''Coxs test'']; mCallback='' ''; input1;',...
    'Position',9);
  uimenu(g6p3p2p1,'Label','Rayleigh''s test','Callback',...
    'FigName=[''Rayleighs test'']; mCallback=''rraytest''; input1;',...
    'Position',10);
  uimenu(g6p3p2p1,'Label','*V-test','Callback',...
    'FigName=[''V-test'']; mCallback='' ''; input1;',...
    'Position',11);
  uimenu(g6p3p2p1,'Label','*Moore''s test','Callback',...
    'FigName=[''Moores test'']; mCallback='' ''; input1;',...
    'Position',12);
  uimenu(g6p3p2p1,'Label','*All of the above','Callback',...
    'FigName=[''Tests for uniformity'']; mCallback='' ''; input1;',...
    'Position',13);
  uimenu(g6p3p2p2,'Label','Ajne''s integral test','Callback',...
    'FigName=[''Ajnes integral test'']; mCallback=''rajnean''; input1;',...
    'Position',1);
  uimenu(g6p3p2p2,'Label','*Rothman''s integral test','Callback',...
    'FigName=[''Rothmans integral test'']; mCallback='' ''; input1;',...
    'Position',2);
  uimenu(g6p3p2p2,'Label','*Specific bi-symmetry test','Callback',...
    'FigName=[''Holmquists test'']; mCallback='' ''; input1;',...
    'Position',3);
  g6p3p3=uimenu(g6p3,'Label','Two Sample Tests','Position',3);
  uimenu(g6p3p3,'Label','Watson''s U2 test for equal distr.','Callback',...
    'shg6p3p2','Position',1);
  uimenu(g6p3p3,'Label','*Kuipers''s test for equal distr.','Callback',...
    'FigName=[''Kuipers test'']; mCallback='' ''; input2;',...
    'Position',2);
  uimenu(g6p3p3,'Label','Mardia''s test for equal concentration','Callback',...
    'shg6p3p3','Position',3);
  uimenu(g6p3p3,'Label','Stephen''s test for equal direction','Callback',...
    'shg6p3p4','Position',4);
  g6p3p6=uimenu(g6p3,'Label','Multi Sample Tests','Position',4);
  uimenu(g6p3p6,'Label','*Watson-Williams'' test','Callback',...
    'FigName=[''Watson-Williams'' '' test'']; mCallback=''  ''; input2;',...
    'Position',1);
  g6p3p7=uimenu(g6p3,'Label','Confidence sets','Position',5);
  uimenu(g6p3p7,'Label','Mean direction (circular)','Callback',...
    'shg6p5p2','Position',1);
  uimenu(g6p3p7,'Label','Mean axis (circular)','Callback',...
    'shg6p5p3','Position',2);
%  uimenu(g6p1p5,'Label','Mean direction (spherical)','Callback',...
%    'shg6p2p1','Position',3);
  g6p3p8=uimenu(g6p3,'Label','Models','Position',6);
  uimenu(g6p3p8,'Label','vmod','Callback','shg6p7p1','Position',1);
  uimenu(g6p3p8,'Label','vmodp','Callback','shg6p7p2','Position',2);
  uimenu(g6p3p8,'Label','raymod','Callback','shg6p7p3','Position',3);
  uimenu(g6p3p8,'Label','raymodp','Callback','shg6p7p4','Position',4);
  uimenu(g6p3p8,'Label','pcdmod','Callback','shg6p7p5','Position',5);
 % g6p4 = Linear-Circular Stats
  g6p4p1=uimenu(g6p4,'Label','Correlation','Position',1);
  g6p4p1p1=uimenu(g6p4p1,'Label','*Mardias rank correlation','Position',1); %mardiacor
  g6p4p1p2=uimenu(g6p4p1,'Label','*Holmquist rank multi correlation','Position',2); %mardiacrp
  g6p4p1p2=uimenu(g6p4p1,'Label','*Holmquist rank modal correlation','Position',3); %lccorrI
  g6p4p1p2=uimenu(g6p4p1,'Label','*Holmquist rank max modal correlation','Position',4); %lccorrII
  g6p4p1p3=uimenu(g6p4p1,'Label','*All of the above','Position',5);







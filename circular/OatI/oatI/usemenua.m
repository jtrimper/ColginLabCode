% usemenua 
% DAT_DIR 2000-11-03
% Copyright 1994, Bjorn Holmquist, Dept of Math. Stat., Lund University.

%f1p1=figure('Name','Copy','NumberTitle','off',...
%'Position',[10 50 300 110],'Resize','off');
%set(f1p1,'MenuBar','none');
%axis('off');
%ht=[];
%ht(1)=text(0.02,0.9,'XL file: \DAT\');
%ht(2)=text(0.8,0.9,'.TXT');
%set(ht,'FontName','Serif');
%set(ht,'FontSize',16);
hedittest2=uicontrol('Style','edit','Callback','shg1p1f','Position',[154 80 67 20]);
%%%
DAT_DIR=get(hedit0,'String'); %2000-11-03
%str=get(hedit1,'String'); 
TXTFILE_DEF=get(hedit1,'String'); 
%stri=['copy \DAT\' str '.txt \DAT\stdxltxt.txt'
%stri=['copy C:\DAT\' str '.txt C:\DAT\stdxltxt.txt']
stri=['copy ' DAT_DIR TXTFILE_DEF '.txt ' DAT_DIR 'stdxltxt.txt']
dos(stri);
%eval(str);
if exist('MATLAB_DIR')==0, MATLAB_DIR='D:\matlab~1\'; end;
%str=get(hedit2,'String'); 
NOCOLS_DEF=get(hedit2,'String'); 
%dos(['D:\matlabR11\toolbox\menu\xtrvnam.exe stdxltxt ' str]);
%dos(['D:\matlabR11\toolbox\menu\xtrvnam.exe ' DAT_DIR 'stdxltxt ' str]); %2000-11-03
%dos([MATLAB_DIR 'toolbox\menu\xtrvnam.exe ' DAT_DIR 'stdxltxt ' str]); %2000-11-03
%dos([MATLAB_DIR 'toolbox\menu\xtrvnam.com ' DAT_DIR 'stdxltxt ' str]); %2000-11-03
%dos([MATLAB_DIR 'toolbox\menu\xtrvnam.exe ' DAT_DIR 'stdxltxt.txt ' str]); %2000-11-11
dos([MATLAB_DIR 'toolbox\menu\xtrvnam.exe ' DAT_DIR 'stdxltxt.txt ' MATLAB_DIR 'toolbox\menu\interml.var ' NOCOLS_DEF]); %2000-11-11
%disp([MATLAB_DIR 'toolbox\menu\xtrvnam.exe ' DAT_DIR 'stdxltxt.txt ' MATLAB_DIR 'toolbox\menu\interml.var ' NOCOLS_DEF]); %2000-11-11

%dos('D:\matlabR11\toolbox\menu\str2asc.exe');
%dos([MATLAB_DIR 'toolbox\menu\str2asc.exe']);
%dos([MATLAB_DIR 'toolbox\menu\str2asc.com']);
dos([MATLAB_DIR 'toolbox\menu\str2asc.exe ' MATLAB_DIR 'toolbox\menu\interml.var ' MATLAB_DIR 'toolbox\menu\interml.asc']); %2000-11-11
%disp([MATLAB_DIR 'toolbox\menu\str2asc.exe ' MATLAB_DIR 'toolbox\menu\interml.var ' MATLAB_DIR 'toolbox\menu\interml.asc']); %2000-11-11


%dos(['D:\matlabR11\toolbox\menu\xltx2iml.exe stdxltxt ' str ' 2000 1 ' str]);
%dos([MATLAB_DIR 'toolbox\menu\xltx2iml.exe ' DAT_DIR 'stdxltxt ' str ' 2000 1 ' str])
dos([MATLAB_DIR 'toolbox\menu\xltx2iml.com ' DAT_DIR 'stdxltxt ' str ' 2000 1 ' str])
%
%dos('copy \circ\interml.* \matlab\toolbox\menu\*.*')
%ldxl2ml2;
vars=['No ';' 1 ';'yet'];
vars=getvars(MATLAB_DIR)
var=vars; %2000-02-1
varlbl=vars; % 1999-03-10; 2000-02-12
if exist(vars)==0, vars=['No ';' 1 ';'yet']; end
%begin12; 
X=[];
loaded=[];
%str=get(hedit3,'String');
%str=get(hedit2,'String'); stri=str2num(str); [X,loaded]=chkld([1:23],X,loaded);
NOCOLS_DEF=get(hedit2,'String'); %stri=str2num(NOCOLS_DEF);
[X,loaded]=chkld([1:str2num(NOCOLS_DEF)],X,loaded);
%[X,loaded]=evel('chkld(' get(hedit3,'String') ',X,loaded); ej klar 00-11-11

%[rx,cx]=size(X); sample=[1:rx]';
sample=[1:size(X,1)]'
%str=get(hedit4,'String') %cage=[12:23];
cage=[12:str2num(get(hedit4,'String'))];
antsectors=length(cage);
fsectdir=str2num(get(hedit5,'String'));
%v=get(hchb,'Value');
CAGECALC=get(hchb,'Value');
%DD=ones(rx,1)*([0:antsectors-1]*360/antsectors)+X(:,fsectdir)*([0:antsectors-1]*0+1);
if (CAGECALC>0.5),
  DD=ones(rx,1)*([0:antsectors-1]*360/antsectors)+X(:,fsectdir)*([0:antsectors-1]*0+1);
  %DD=(1+0*[1:rx])'*([0:11]*360/12)+X(:,11)*([0:11]*0+1)
  [R,N,A1,A2,Ang]=sect2rk(X(:,cage),DD); 
  M=Ang(:,1);
  P=exp(-N'.*R(:,1).^2); P2=exp(-N'.*R(:,2).^2);
  X=[X,R,N,M]; %1999-03-10
end
close(fuse); 
%datamenu;


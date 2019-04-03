function tabell(T,titel,tabfil)
%
% CALL: tabell(T,titel,tabellfil)
%
if (nargin<3), tabfil='tabell.mat'; end
if (nargin<2), titel='a   b   c   d   e'; end
fp=fopen(tabfil,'w');
fprintf(fp,titel);
fprintf(fp,'\t\n\r\n\r',titel);
[r,c]=size(T);
form=[''];
for i=1:c-4,
 form=[form,'%6.0f '];
end
for i=c-3:c,
 form=[form,'%6.2f '];
end
form=[form,'\t\n\r\n\r'];
%fprintf(fp,'%4.0f %6.2f %6.0f %6.2f %6.2f \n\r', T');
fprintf(fp,form, T');
stat=fclose(fp);
%end

function tabelllx(T,titel,tabfil)
%
% CALL: tabelllx(T,titel,tabellfil)
%
if (nargin<3), tabfil='tabell.tex'; end
if (nargin<2), titel='a   b   c   d   e'; end
fp=fopen(tabfil,'w');
%fprintf(fp,titel);
%fprintf(fp,'\t\n\r\n\r',titel);
[r,c]=size(T);
form=[''];
%for i=c-3:c,
% form=[form,'%6.2f '];
%end
tabform=[''];
for i=1:c,
  tabform=[tabform,'r'];
end
form=[form,'\t\n\r\n\r'];
fprintf(fp,['\\documentstyle{article}' '\t\n\r']);
fprintf(fp,['\\begin{document}' '\t\n\r']);
%fprintf(fp,'%4.0f %6.2f %6.0f %6.2f %6.2f \n\r', T');
fprintf(fp,['\\begin{tabular}{|' tabform '|}' '\t\n\r']);
%fprintf(fp,['\\multicolumn{' num2str(c) '}{c}{' titel '}\\' '\\' '\t\n\r']);
fprintf(fp,['\\hline' '\t\n\r']);
fprintf(fp,[titel '\\' '\\' '\t\n\r']);
fprintf(fp,['\\hline' '\t\n\r']);
for i=1:r,
  for j=1:c-1,
    fprintf(fp,[num2str(T(i,j)) '&']);
  end
  fprintf(fp,[num2str(T(i,c)) '\\' '\\']);
  fprintf(fp,'\t\n\r');
end
fprintf(fp,['\\hline' '\t\n\r']);
fprintf(fp,['\\end{tabular}' '\t\n\r']);
fprintf(fp,['\\end{document}']);
%fprintf(fp,form, T');
stat=fclose(fp);
%dos(['latex ' tabfil])
%dos(['dvijep ' tabfil])
%dos(['skriv ' tabfil])
%end

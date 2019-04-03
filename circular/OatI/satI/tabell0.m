function tabell
%
%
titel=['obs ',' angle','   r  ','  n   ',' fett '];
%[Rr,Cr]=size(R);
%%%T=[[1:Rr]',R(:,2),R(:,1),akt,X(:,vnrld(8,loaded))]
T=X(sample,1:5);
fp=fopen('tabell.mat','w');
%fprintf('%4.0f %6.2f %6.2f %6.2f %6.2f \n\r', titel')
fprintf(fp,titel)
fprintf(fp,'A bbbbbbbbbbbbbbb %g\t\n\r',pi)
fprintf(fp,'H aaaaaaaaaaaa %g\t\n\r',2)
fprintf(fp,'%4.0f %6.2f %6.2f %6.2f %6.2f \n\r', T')
%fprintf(fp, '%26.2f \n\r', mdakt')
stat=fclose(fp);
tabell=21;
end

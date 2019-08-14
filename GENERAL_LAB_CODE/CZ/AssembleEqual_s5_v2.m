function AssembleEqual_s5_v2(TTList,imagedirectory,plot_scale,Path,note,sequence,x,y)

% have 5 sessions at most
% Path is another path where we want to save all the figures
% e.g.Path='C:\Users\ColginLab\Documents\MATLAB\MainFunctions\Code & Data Remapping\All Ratemaps'
% note is to identify the data
% e.g. note='dCA1_Rat28_AADDA_20131023_'

if nargin == 5 sequence = [1 2 3 4 5]; end
len=length(sequence);
if len<5 sequence(len+1:5)=100; end
Directory = pwd

imagedirectory=strcat(imagedirectory,num2str(plot_scale));

Session1 = strcat('Begin',num2str(sequence(1)),'\',imagedirectory);
Session2 = strcat('Begin',num2str(sequence(2)),'\',imagedirectory);
Session3 = strcat('Begin',num2str(sequence(3)),'\',imagedirectory);
Session4 = strcat('Begin',num2str(sequence(4)),'\',imagedirectory);
Session5 = strcat('Begin',num2str(sequence(5)),'\',imagedirectory);

TPath = strcat(Directory,'\',TTList);
cluster = ReadFileList(TPath);

cellspersheet = 7;
%empty = ones(402,402,3);
empty = ones(420,560,3);

for i = 1:length(cluster)

   bmpfile = strrep(char(cluster(i)),'.t','.bmp')

   ImgPathA = strcat(Directory,'\',Session1,'\',bmpfile);
   ImgPathB = strcat(Directory,'\',Session2,'\',bmpfile);
   ImgPathC = strcat(Directory,'\',Session3,'\',bmpfile);
   ImgPathD = strcat(Directory,'\',Session4,'\',bmpfile);
   ImgPathE = strcat(Directory,'\',Session5,'\',bmpfile);

   if (fopen(ImgPathA) >= 0) A = imread(ImgPathA); else A = empty.*255; end;
   if (fopen(ImgPathB) >= 0) B = imread(ImgPathB); else B = empty.*255; end;
   if (fopen(ImgPathC) >= 0) C = imread(ImgPathC); else C = empty.*255; end;
   if (fopen(ImgPathD) >= 0) D = imread(ImgPathD); else D = empty.*255; end;
   if (fopen(ImgPathE) >= 0) E = imread(ImgPathE); else E = empty.*255; end;

   I = [A B C D E];
   
   if (mod(i,cellspersheet) == 1) J = I; else J = [J; I]; end;
   if nargin == 5
       if (mod(i,cellspersheet) == 0)
%            imwrite(J,strcat(Directory,'\',TTList(1:end-4),'_',num2str(plot_scale),'_',num2str(i/cellspersheet),'.jpg'));
           imwrite(J,strcat(Path,'\',note,'_',num2str(plot_scale),'_',num2str(i/cellspersheet),'.jpg'));
       elseif i == length(cluster)
%            imwrite(J,strcat(Directory,'\',TTList(1:end-4),'_',num2str(plot_scale),'_',num2str(ceil(i/cellspersheet)),'.jpg'));
           imwrite(J,strcat(Path,'\',note,'_',num2str(plot_scale),'_',num2str(ceil(i/cellspersheet)),'.jpg'));
       end;
   else
       if(mod(i,cellspersheet) == 0)
%            imwrite(J,strcat(Directory,'\',TTList(1:end-4),'_',num2str(plot_scale),imagedirectory,'_ordered','_',num2str(i/cellspersheet),'.jpg'));
           imwrite(J,strcat(Path,'\',note,'_',num2str(plot_scale),'_ordered','_',num2str(i/cellspersheet),'.jpg'));
       elseif i == length(cluster)
%            imwrite(J,strcat(Directory,'\',TTList(1:end-4),'_',num2str(plot_scale),imagedirectory,'_ordered','_',num2str(ceil(i/cellspersheet)),'.jpg'));
           imwrite(J,strcat(Path,'\',note,'_',num2str(plot_scale),'_ordered','_',num2str(ceil(i/cellspersheet)),'.jpg'));
       end;
   end
end
% if nargin == 5
%    imwrite(J,strcat(Directory,'\',strrep(TTList,'.',''),imagedirectory,'last','.jpg'));
% else
%    imwrite(J,strcat(Directory,'\',strrep(TTList,'.',''),imagedirectory,'_ordered','last','.jpg'))
% end
fclose('all');
    

%image(J)
%axis off
%axis image

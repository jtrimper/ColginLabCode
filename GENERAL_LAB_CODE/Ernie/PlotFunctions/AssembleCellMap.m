% Gives you rate map and spike map across trials
% -Should start at the folder containing all the trials of interest
% -Notice all the available t-files will be read
function [] = AssembleCellMap(varargin)

if nargin > 0 
    spkfile = Readtextfile(varargin{1,1});
end

numCell_col = 5; %the number of cells in one figure
parentfolder = pwd;
scrsz = get(groot,'ScreenSize');
[folder_dir] = targetfolder('begin');
for dd = 1:size(folder_dir,1)
    cd(folder_dir{dd})
    
    if nargin == 0 
        spkfile = targetfile('.t');
    end
    posfile = targetfile('.nvt');
    [post,posx,posy] = LoadPos(posfile{1,1});
    count_fig = 0;
    for kk = 1:size(spkfile,1)
        
        if dd ==1
            if rem(kk,numCell_col) == 1
                count_fig = count_fig+1;
                h(count_fig) = figure('Position',[1 1 scrsz(3) scrsz(4)]);
            end
        end
        
        if rem(kk,numCell_col) == 1 && dd~=1
            count_fig = count_fig+1;
            figure(h(count_fig))
        end
        
        %figure position for subplot
        pp = rem(kk,numCell_col);
        if pp == 0
            pp = numCell_col;
        end
        
        %Load spikes
        if exist(spkfile{kk},'file') == 0
            subplot(numCell_col,size(folder_dir,1)*2,2*dd-1+size(folder_dir,1)*2*(pp-1))
            axis off
            subplot(numCell_col,size(folder_dir,1)*2,2*dd+size(folder_dir,1)*2*(pp-1))
            axis off
            continue
        end
        [spkt] = Readtfile(spkfile{kk});
        spkt = spkt./10^4; %convert to seconds
        spkpos = match(spkt,post);
        [~, cellname, ~] = fileparts(spkfile{kk});
        
        %Obtain rate map
        binWidth = 5;
        xLength = nanmax(posx)-nanmin(posx);
        yLength = nanmax(posy)-nanmin(posy);
        [map, ~, xAxis, yAxis] = rateMap(posx,posy,posx(spkpos),posy(spkpos),binWidth,binWidth,min(posx),xLength,min(posy),yLength,1/30);
               
        %plot raw map
        subplot(numCell_col,size(folder_dir,1)*2,2*dd-1+size(folder_dir,1)*2*(pp-1))        
        plot(posx,posy,'color',[0.3,0.3,0.3]);
        hold on;
        plot(posx(spkpos),posy(spkpos),'r*','MarkerSize',2);
        title( ['Trial ', num2str(dd),' ',cellname],'FontSize',8 );
        hold off;
        axis([nanmin(posx), nanmax(posx), nanmin(posy), nanmax(posy)]);
        axis off;
        axis square
        
        %plot rate map
        subplot(numCell_col,size(folder_dir,1)*2,2*dd+size(folder_dir,1)*2*(pp-1))
        drawfield(map,xAxis,yAxis, 'jet', max(max(map)),binWidth);
        axis off;
        axis square
        
    end
    
end

cd(parentfolder)
% Store the output
for ii = 1:size(h,2)
    if nargin > 0 
        figFile = strcat(varargin{1,1}(1:end-4),'_placemap_',num2str(ii));
    else
        figFile = strcat('placemap_',num2str(ii));
    end
    imageStore(h(ii),'eps',figFile)
    imageStore(h(ii),'png',figFile)
    close(h(ii))
    
end
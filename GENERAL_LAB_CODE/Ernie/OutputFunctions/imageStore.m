%__________________________________________________________________________
%
%                       Image storing function
%__________________________________________________________________________

% Function for storing figures to file
function imageStore(figHandle,format,figFile)

% Make the background of the figure white
set(figHandle,'color',[1 1 1]);

if strcmp(format,'bmp') == true
    % Store the image as bmp
    figFile = strcat(figFile,'.bmp');
    f = getframe(figHandle);
    pic = frame2im(f);
    imwrite(pic,figFile,'bmp');
end

if strcmp(format,'png') == true
    % Store image as png
    figFile = strcat(figFile,'.png');
    print(figHandle, '-dpng',figFile)
end

if strcmp(format,'eps') == true
    figFile = strcat(figFile,'.eps');
    saveas(figHandle,figFile,'epsc');
end
    

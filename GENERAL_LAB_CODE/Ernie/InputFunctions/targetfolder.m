% Obtain the directory of target folder. 
%
% For one target folder, enter the string of the folder name. 
%
% For multiple target folders, enter the folder names in cell array.
%
% The input only requires the folder name under the parent folder, not the
% whole directory
function [folder_dir] = targetfolder(foldername)

    if ischar(foldername)
        
        fdn{1,1} = foldername;
        
    elseif iscell(foldername)
            
        fdn = foldername;
        
    else
        error('Invalid input format. Input should be char or cell array.')
        
    end
   
    dirlist = dir;
    for ff = 1:size(fdn,1)
        for aa=1:length(dirlist)
            if(dirlist(aa).isdir) 
                temp=dirlist(aa).name;

                if(length(temp) < length(fdn{ff}))
                    continue;
                end
                if strcmp(temp(1:length(fdn{ff})), fdn{ff})
                    nn = str2double(temp(length(fdn{ff})+1:end));
                    if isnan(nn)
                        nn = 1;
                    end
                    folder_dir{nn,1} = strcat(pwd,'\',temp);
                end
            end

        end
        
    end
        

        
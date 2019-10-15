function [file_dir] = targetfile(file_ext,varargin)
    file_dir = [];
    if ischar(file_ext)
        
        fdn{1,1} = file_ext;
        
    elseif iscell(file_ext)
            
        fdn = file_ext;
        
    else
        error('Invalid input format. Input should be char or cell array.')
        
    end
    
    if nargin>1
        filename = varargin{1};
    end
   
    dirlist = dir;
    nn=0;
    for ff = 1:size(fdn,1)
        for aa=1:length(dirlist)
            if ~(dirlist(aa).isdir) 
               [~,name,ext] = fileparts(dirlist(aa).name);
                if exist('filename','var')
                    if strcmp(ext, fdn{ff}) && ~isempty(strfind(name,filename))
                        nn=nn+1;                    
                        file_dir{nn,1} = strcat(pwd,'\',dirlist(aa).name);
                    end
                    
                else
                    if strcmp(ext, fdn{ff})
                        nn=nn+1;                    
                        file_dir{nn,1} = strcat(pwd,'\',dirlist(aa).name);
                    end
                end
                                    
                    
            end

        end
        
    end
        

        
function Deletedir(dir_str)

dirlist = dir;
for dd = 3:size(dirlist,1)
    if dirlist(dd).isdir
        fdn = dirlist(dd).name;
        if ~isempty(strfind(fdn,dir_str))
            rmdir(strcat(cd,'\',fdn),'s')
        end
    end
end
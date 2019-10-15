function Deletefiletype(file_ext)

[file_dir] = targetfile(file_ext);
for ii=1:size(file_dir,1); 
    
    delete(file_dir{ii,1});
    
end
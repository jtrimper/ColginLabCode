parentfd = pwd;
dirlist = dir;
for ii = 3:size(dirlist)
    cd(strcat(parentfd,'\',dirlist(ii).name))
    if isdir(strcat(cd,'\cluster_gc_final'))
        [folder_dir] = targetfolder('begin');

        outdir = strcat(cd,'\out_FRonLT_',date);
        if ~isdir(outdir)
            mkdir(outdir)
        end
        dayfd = cd;
        for ff = 1:size(folder_dir,1)
            cfolder = folder_dir{ff,1};
            posfile = 'VT1.nvt';
            cd(cfolder)

            [spkfile_dir] = targetfile('.t');
            for kk = 1:size(spkfile_dir,1)
                spkfilepath = spkfile_dir{kk,1};
                TT_num = spkfilepath(strfind(spkfilepath,'TT')+2:regexp(spkfilepath,'_\d+[.]+t')-1);
                EEGfile = strcat('CSC',TT_num,'.ncs');
                spkfile = spkfilepath(strfind(spkfilepath,'TT'):end);

%                 FiringRate4LinearTrack(posfile,spkfile,outdir);
                cd(dayfd)
                SpkPhasePrecession(posfile,spkfile,EEGfile,outdir,'begin') 

            end

        end
    else
        continue
    end
end
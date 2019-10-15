function result = CheckAbsoluteRefractoryPeriod(ttList,sessionfd)

cellID = Readtextfile(ttList);
result = true(size(cellID,1),size(sessionfd,1));

for ii = 1:size(sessionfd,1)
    for jj = 1:size(cellID,1)
        
        spkfile = strcat(sessionfd{ii},'\',cellID{jj});
        if exist(spkfile,'file')
            spkt = Readtfile(spkfile)/10^1; % in msec
            if any(diff(spkt) < 1)
                result(jj,ii) = false;
            end
            
        else
            result(jj,ii) = true;
        end
    end
end
function [timestamp] = Readsmifile(file,outtype)

    tfp = fopen(file, 'r','b','UTF-8');
    if (tfp == -1)
        warning([ 'Could not open tfile ' tfn]);
    end
    
    n=0;
    timestamp = [];
    if strcmp(outtype,'double')
        while ~feof(tfp)   
            filecontent = fgets(tfp);
            loc = strfind(filecontent,'<P Class = ENUSCC>');
            
            if isempty(loc)
                loc = strfind(filecontent,'<P Class=ENUSCC>');
                if ~isempty(loc)
                    n = n+1;
                    endloc = strfind(filecontent,'</SYNC>');
                    timestamp(n,1) = str2double(filecontent(loc+16:endloc-1));
                else
                    continue
                end
                
            elseif ~isempty(loc)
                n = n+1;
                endloc = strfind(filecontent,'</SYNC>');
                timestamp(n,1) = str2double(filecontent(loc+18:endloc-1));
            else
                continue
            end
        end
    elseif strcmp(outtype,'cell')
        while ~feof(tfp)   
            filecontent = fgets(tfp);
            loc = strfind(filecontent,'<P Class = ENUSCC>');
            if ~isempty(loc)
                n = n+1;
                endloc = strfind(filecontent,'</SYNC>');
                timestamp{n,1} = filecontent(loc+18:endloc-1);
            else
                continue
            end
        end
    end
    fclose(tfp);
    
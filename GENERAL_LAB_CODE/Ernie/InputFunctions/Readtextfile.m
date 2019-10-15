function [filecontent] = Readtextfile(textfile,varargin)

%the number of sample to be extracted
if size(varargin,1)==1
    exn = varargin{1};
end

% Open the input file for reading
fid = fopen(textfile,'r');
if fid == -1
    disp('Couldn''t find the input file')
    return
end

if size(varargin,1)==1
    n = 0;
    while ~feof(fid) && n<=exn-1
        n = n+1;
        str = fgetl(fid);

        filecontent{n,1} = str;

    end
elseif size(varargin,1)==0
    n = 0;
    while ~feof(fid)
        n = n+1;
        str = fgetl(fid);

        filecontent{n,1} = str;

    end
end

fclose(fid);
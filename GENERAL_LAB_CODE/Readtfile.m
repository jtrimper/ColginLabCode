function [timestamp] = Readtfile(tfile, varargin)

fileType = 'uint32';
if nargin>1
    fileType = varargin{1};
end

tfp = fopen(tfile, 'rb','b');
if (tfp == -1)
    warning([ 'Could not open tfile ' tfn]);
end

ReadHeader(tfp);

timestamp = fread(tfp,inf,fileType);
fclose(tfp);

function S = loadSpikes_CZ(tfilelist, path, NaFile)
% tfilelist:    List of t-files. Each file contains a cluster of spikes
%               from a cell.
% path:         Path to the directory were the t-files are stored
% NaFile:       List of file names in tfilelist that don't exist
%               in the current directory
%
% inp: tfilelist is a cellarray of strings, each of which is a
% tfile to open.  Note: this is incompatible with version unix3.1.
% out: Returns a cell array such that each cell contains a ts 
% object (timestamps which correspond to times at which the cell fired)
%
% Edited by: Raymond Skjerpeng


%-------------------
% Check input type
%-------------------

if ~isa(tfilelist, 'cell')
   error('LoadSpikes: tfilelist should be a cell array.');
end


% Number of file names in tfilelist
nFiles = length(tfilelist);
% Actual number of files to be loaded
anFiles = nFiles - length(NaFile);


%--------------------
% Read files
%--------------------
fprintf(2, 'Reading %d files.', anFiles);

% for each tfile
% first read the header, then read a tfile 
% note: uses the bigendian modifier to ensure correct read format.


S = cell(nFiles, 1);
for iF = 1:nFiles
    %DisplayProgress(iF, nFiles, 'Title', 'LoadSpikes');
    tfn = tfilelist{iF};
    % Check if file exist
    if length(strmatch(char(tfn),NaFile,'exact'))>0
        S{iF} = -1; % Set this as default for each file that doesn't exist
    else
        tfn = strcat(strcat(path,'\'),tfn); % Path to file + file name
        if ~isempty(tfn)
            tfp = fopen(tfn, 'rb','b');
            if (tfp == -1)
                warning([ 'Could not open tfile ' tfn]);
            end

            ReadHeader(tfp);    
            S{iF} = fread(tfp,inf,'uint32');	%read as 32 bit ints
            S{iF} = ts(S{iF});
            fclose(tfp);
        end 	% if tfn valid
    end
end		% for all files
fprintf(2,'\n');
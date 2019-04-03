function multi_keep(keepers)
% function multi_keep(keepers)
%
% PURPOSE:
%   Function will get rid of all variables in the command window workspace that are not
%   included in the cell array 'keepers'
%
% INPUT:
%   keepers = cell array, listing variables to keep
%
% JB Trimper
% 12/2018
% Colgin Lab
%
% *Based on function 'keep' downloaded from MATLAB Central





variables = evalin('caller','who');

for v = length(variables):-1:1
    clearIt = 1;
    for k = 1:length(keepers)
        if strcmp(variables{v}, keepers{k}) || strcmp(variables{v}, 'keepers')
            clearIt = 0;
            break
        end
    end
    if clearIt == 1
        evalin('caller', ['clear ' variables{v}]);
    end
end

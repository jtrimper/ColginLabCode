function ts = findTime(D, ix, unitflag)
%
% ts/findTime
% 	t = findTime(D, ix)
% 	t = findTime(D, ix, unitflag)
%
% 	Returns timestamps at which index ix occures 
%   (in units of unitflag if specified)
% 
% ADR
% version L5.0
% v5.0: JCJ 2/27/2003 includes support for time units

ts = D.t(ix);

if nargin == 3
    if isempty(strmatch('units',fieldnames(D)))
        warning('D units not specified: assuming D units = sec ' )
        ts = convert(ts,'sec',unitflag);
    else
        ts = convert(ts,D.units,unitflag);
    end
end
   
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function R = convert(R,unit,unitflag)

switch (unitflag)
    case 'sec'
        switch unit
            case 'sec'
                R = R;
            case 'ts'
                R = R/10000;
            case 'ms'
                R = R/1000;
            otherwise
                warning('tsa has invalid units: no conversion possible' );
        end
        
    case 'sec0'
        switch unit
            case 'sec'
                R = (R - min(R));
            case 'ts'
                R = (R - min(R))/10000;
            case 'ms'
                R = (R - min(R))/1000;
            otherwise
                warning('tsa has invalid units: no conversion possible' );
        end
        
    case 'ts'
        switch unit
            case 'sec'
                R = R*10000;
            case 'ts'
                R = R;
            case 'ms'
                R = R*10;
            otherwise
                warning('tsa has invalid units: no conversion possible' );
        end
        
    case 'ms'
        switch unit
            case 'sec'
                R = R*1000;
            case 'ts'
                R = R/10;
            case 'ms'
                R = R;
            otherwise
                warning('tsa has invalid units: no conversion possible' );
        end
    otherwise
        warning('Convert called with invalid unitflag: no conversion possible');
end

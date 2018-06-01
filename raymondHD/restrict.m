function R = Restrict(tsa, A, B, C)

% 	R = Restrict(tsa, t0, t1, units)
% 	R = Restrict(tsa, t0, t1)
% 	Returns a new tsa (ctsd) R so that D.Data is between 
%		timestamps t0 and t1, where t0 and t1 are in units
%
%    R = Restrict(tsa, t, units)
%    R = Restrict(tsa, t)
%    Returns a new tsd (not ctsd) R so that D.Data includes
%         only those timestamps in t, where t is in units
%
%   If units are not specified, assumes t has same units as D
%
%   NOTE: D will be returned in its original units!
%
% ADR 2000
% version L5.0
% v4.1 29 oct 1998 now can handle nargin=2
% v4.2 23 jan 1999 now can handle t0 and t1 as arrays
% v5.0 JCJ 2/27/2003 includes support for time units

switch nargin
    case 2                             % R = Restrict(tsd, t)
        ix = findAlignment(tsa, A);
        
    case 3                             % R = Restrict(tsd, t0, t1)
        if isa(B,'char')               % units were specified R = Restrict(tsd, t, units)
            ix = findAlignment(tsa, A, B);

        else
            
            if length(A) ~= length(B)
                error('t0 and t1 must be same length')
            end
            ix = [];
            for it = 1:length(A)
                f = find(tsa.t >= A(it) & tsa.t <= B(it));
                ix = cat(1, ix, findAlignment(tsa, tsa.t(f)));
            end
        end

    case 4
        
        if length(A) ~= length(B)
            error('t0 and t1 must be same length')
        end
        ix = [];
        for it = 1:length(A)
            t=range(tsa,C);
            
            f = find(t >= A(it) & t <= B(it));
            ix = cat(1, ix, findAlignment(tsa, t(f),C));
        end
        
    otherwise
        error('Unknown number of input arguments.');
        
end % switch

if isempty(strmatch('units',fieldnames(tsa)))
    warning('units not specified: output variable has units = sec (no converstions preformed)' )
    R = ts(tsa.t(ix), 'sec');

else
    R = ts(tsa.t(ix), tsa.units);
end
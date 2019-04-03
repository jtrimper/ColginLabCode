function bool = CheckTS(varargin)

% bool = ts/CheckTS(X0, X1, X2, ...)
%
% checks to make sure that all timestamps are identical for all tsds included.
% works with combinations of ctsd and tsd
%
% NOTE: very sensitive to round-off error!
%
% ADR 1998
% version L5.0
% v5.0: JCJ 2/27/2003 includes support for time units

adrlib;
tsa=varargin{1};

R0 = Range(tsa,tsa.units);
for iX = 2:length(varargin)
   R1 = Range(varargin{iX},tsa.units); % use the same units.
   if (length(R0) ~= length(R1))
      bool = false;                  % if not same length, can't be equal.
      return
   end
   if (min(R0 == R1) == 0)
      bool = false;                  % if there are any non-equal elts, not equal
      return
   end
end
bool = true;                        % nothing failed, must be ok

         
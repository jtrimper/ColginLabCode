function s2plot(x,y,lines,ll)
%
% CALL: s2plot(x,y)
%
%       Plot vectors or matrices. 
%       S2PLOT(X,Y) plots vector x versus vector y. If X or Y is a matrix,
%       then the vector is plotted versus the rows or columns of the matrix,
%       whichever line up. 
% 
%       S2PLOT(Y) plots the columns of Y versus their index.
%       If Y is complex, S2PLOT(Y) is equivalent to PLOT(real(Y),imag(Y)).
%       In all other uses of S2PLOT, the imaginary part is ignored.
% 
%       Various line types, plot symbols and colors may be obtained with
%       PLOT(X,Y,S) where S is a 1, 2 or 3 character string made from
%       the following characters:
% 
%              y     yellow        .     point
%              m     magenta       o     circle
%              c     cyan          x     x-mark
%              r     red           +     plus
%              g     green         -     solid
%              b     blue          *     star
%              w     white         :     dotted
%              k     black         -.    dashdot
%                                  --    dashed
%                              
%       For example, S2PLOT(X,Y,'c+') plots a cyan plus at each data point.
% 
%       The PLOT command, if no color is specified, makes automatic use of
%       the colors in the above table.  The default is yellow for one line, 
%       and for multiple lines, to cycle through the first six colors
%       in the table.
% 
%       PLOT returns a column vector of handles to LINE objects, one
%       handle per line. 
% 
%       The X,Y pairs, or X,Y,S triples, can be followed by 
%       parameter/value pairs to specify additional properties 
%       of the lines.
%
if nargin<4, lll=1; else lll=ll; end
if (nargin==1),
  y=x; ny=length(y);
  x=[2*pi/ny:2*pi/ny:2*pi];
end;
if nargin<3, lines='w'; end
x=[x;x(1)]; y=[y;y(1)];
nx=length(x); ny=length(y);
if (nx~=ny),
  disp(' equal length necessary')
else
%  plot(cos(x),sin(x));
  u=[0:0.1:2*pi+0.1];
  plot(cos(u),sin(u));
  hold on;
  plot((lll+y).*cos(x),(lll+y).*sin(x));
end
 axis('equal');
 axis('off');
if nargin>=3,
 plot([(lll+y).*cos(x),lll*ones(ny,1).*cos(x)]',[(lll+y).*sin(x),lll*ones(ny,1).*sin(x)]',['w',lines]);
end
hold off
%end


 



function zero_line(optCol)

xRange = get(gca, 'XLim'); 
ln = line(xRange, [0 0]); 
set(ln, 'LineStyle', '--', 'Color', [0 0 0]); 
if nargin == 1
    set(ln, 'Color', rgb(optCol)); 
end
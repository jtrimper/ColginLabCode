function han = zero_line(optCol)

xRange = get(gca, 'XLim'); 
han = line(xRange, [0 0]); 
set(han, 'LineStyle', '--', 'Color', [0 0 0]); 
if nargin == 1
    set(han, 'Color', rgb(optCol)); 
end
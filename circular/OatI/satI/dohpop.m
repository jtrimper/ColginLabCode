%k=menu('Choose orientation','landscape','portrait','tall') 
%if (k==1), 
%   orient('landscape')
%end
%hpop=uicontrol('Style','Popup','String',...
%'landscape'|portrait|tall','Position',[20 320 100 50],...
%'Callback','dohpop')
val=get(hpop,'Value'); 
if val==1
   orient('landscape')
end
if val==2
   orient('portrait')
end
if val==3
   orient('tall')
end

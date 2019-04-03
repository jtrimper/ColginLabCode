function vindrikt(dir,hast)
%
% vindrikt(riktning,hastighet)
%
%text(1.45*cos((90-dir)*pi/180),1.45*sin((90-dir)*pi/180),['H=',num2str(dir)],'HorizontalAlignment','center')
for k=1:1:hast,
plot([(1.0+k*0.03)*sin(dir*pi/180);(1.03+k*0.03)*sin((dir-3)*pi/180)],[(1.0+k*0.03)*cos(dir*pi/180);(1.03+k*0.03)*cos((dir-3)*pi/180)],'-')
plot([(1.0+k*0.03)*sin(dir*pi/180);(1.03+k*0.03)*sin((dir+3)*pi/180)],[(1.0+k*0.03)*cos(dir*pi/180);(1.03+k*0.03)*cos((dir+3)*pi/180)],'-')
end
end


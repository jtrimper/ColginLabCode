POSITION=[120 110 60 20;250 110 80 20;180 90 40 20];
%datax=get(hedittest1,'String'); 
hti=2;
eval(['[Uk]=maag(' datay ',' datax ');'])
test='NS';
k=length(valuesof(datax));
if k==2, gr05=0.1869; gr01=0.2684; gr001=0.3850; end
if k==3, gr05=0.3093; gr01=0.4057; gr001=0.5374; end
if k==4, gr05=0.4216; gr01=0.5292; gr001=0.6727; end
if k==5, gr05=0.5290; gr01=0.6460; gr001=0.7996; end
if k==6, gr05=0.6333; gr01=0.7587; gr001=0.9213; end
if Uk>gr05, test='*'; end
if Uk>gr01, test='**'; end
if Uk>gr001, test='***'; end
ht(hti)=text(0.02,0.42,'U_{k,N} :'); hti=hti+1;
hedit=uicontrol('Style','edit','String',num2str(Uk),'Position',POSITION(1,:));
set(hedit,'BackgroundColor',[1 1 1]);
%ht(hti)=text(0.02,0.32,'n:'); hti=hti+1;
%%%%hedit=uicontrol('Style','edit','String',num2str(n),'Position',POSITION(2,:));
%%set(hedit,'BackgroundColor',[1 1 1]);
ht(hti)=text(0.42,0.44,'Test:'); hti=hti+1;
hedit=uicontrol('Style','edit','String',test,'Position',POSITION(2,:));
set(hedit,'BackgroundColor',[1 1 1]);


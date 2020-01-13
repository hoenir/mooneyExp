function savefigure(loadname,savedirectory,bins,angle,levels,re,section,descriptor,fmt_load);

 temp(levels,2)=0;
 
 temp(1,1)=bins+1;
 
 temp(1,2)=[section^(2*1)*bins+temp(1,1)-1];
    
 for i=2:levels;
     
     temp(i,1)=temp(i-1,2)+1;
     temp(i,2)=section^(i*2)*bins+temp(i,1)-1;
    
 end
 
 temp(:,3)=temp(:,2)-temp(:,1)+1;
        
 f1=figure('visible','off');
    

 subplot(levels+1,1,1);
 bar(descriptor(1:bins));
 xlim([1 bins]); ylim([0 1]);
 title('levels 0');

%  y=0:0.001:1;
 
 for i=1:levels;
    
     subplot(levels+1,1,i+1);
     bar(descriptor(temp(i,1):temp(i,2)));
     xlim([1 temp(i,3)]);ylim([0 1]);
     title(strcat('levels ',num2str(i)))
%      
%      for j=1:bins:temp(i,3);
%          
%          plot(j,y,'k')
% 
%      end    
    
 end

 saveas(f1,strcat(savedirectory,'\Result\',num2str(levels),'level ',num2str(bins),'bins ',num2str(section),'section ',num2str(angle)...
     ,'angle ',num2str(re),'reselution ',loadname),fmt_load);
 
 close(f1)
    
    
    
    

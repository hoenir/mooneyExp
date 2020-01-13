function [distanceatlevel]=displayDistances(distances,bins,levels,section)

distanceatlevel=[];


temp3(levels,2)=0;
temp3(1,1)=1;
temp3(1,2)=1;

for i=1:levels;
    temp3(i+1,1)=section^(2*i);
    temp3(i+1,2)=temp3(i+1,1)+temp3(i,2);
end


  
    distanceatlevel=median(distances(temp3(levels,2)+1:temp3(levels+1,2))); 
      
end


















% 
% 
% 
% 
% 
% temp(1,1)=bins+1;
% temp(1,2)=[section^(2*1)*8+temp(1,1)-1];
%     
% for i=2:levels;
%     temp(i,1)=temp(i-1,2)+1;
%     temp(i,2)=section^(i*2)*8+temp(i,1)-1;
% end
% 
% 
% 
% 
% for l=0:levels
%     
%     
%     
%     
%     
%     median_dist=median(part);
%     if l>0
%         distanceatlevel=[distanceatlevel;median_dist];
%     end
%     
%     
% %     x=1:1:coverage;
% %     subplot(levels+1,1,l+1);
% %     bar(part,'k');
% %     set(gca,'XTick',[]);
% %     set(gca,'YTick',[]);
% %     medianstr=['median similarity on level ' int2str(l) ': ' num2str(median_dist)];
% %     ylim([0 2]);
% %     title(medianstr,'FontSize',18);
% %     legend
% % end
% % resultfigure=f3;
% end
% 



% 
% 
% 
% function [resultfigure,distanceatlevel]=displayDistances(distances,levels)
% f3=figure('Visible','off');
% 
% endpos=0;
% pos=1;
% distanceatlevel=[];
% 
% for l=0:levels
%     coverage=4^l;
%     startpos=endpos+1;
%     endpos=endpos+pos+coverage-1;
%     part=distances(startpos:endpos);
%     part = part(~isnan(part));
%     median_dist=median(part);
%     if l>0
%         distanceatlevel=[distanceatlevel;median_dist];
%     end
%     x=1:1:coverage;
%     subplot(levels+1,1,l+1);
%     bar(part,'k');
%     set(gca,'XTick',[]);
%     set(gca,'YTick',[]);
%     medianstr=['median similarity on level ' int2str(l) ': ' num2str(median_dist)];
%     ylim([0 2]);
%     title(medianstr,'FontSize',18);
%     legend
% end
% resultfigure=f3;
% end
% 

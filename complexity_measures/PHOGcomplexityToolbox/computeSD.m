function sdvalues=computeSD(descriptor,bins,levels,section)




temp(1,1)=bins+1;
temp(1,2)=[section^(2*1)*bins+temp(1,1)-1];
    
for i=2:levels;
    temp(i,1)=temp(i-1,2)+1;
    temp(i,2)=section^(i*2)*bins+temp(i,1)-1;
end

   
    descript=(descriptor(temp(levels,1):temp(levels,2)));
      
    sd=std(descript);
    
    for j=1:length(sd);
        
        if max(descript)<1e-8;
            
            sd(j)=NaN;
            
            end
    end
     
    sdvalues=sd;
    
end




% 
% 
% 
% descriptor=vec2mat(descriptor,bins);
% 
% size(descriptor)
% 
% descriptor=descriptor';
% 
% sdvalues=std(descriptor);
% 
% size(sdvalues)
% 
% for i=1:length(sdvalues); 
%     
%    if max(descriptor(:,i))>1e-8;
%        sdvalues(i)=NaN;
%    end
%    
% end































% 
% 
% 
% 
% sdvalues=[];
% for l=0:levels
%         levelpart=[];
%      for pos=1:section^(2*l)
%          
%      
%          levelpart=[levelpart;getDescriptorPart(descriptor,bins,l,pos,section)];
%          
%      end
%      sd=std(levelpart);
%      if max(levelpart)>1e-8
%          sdvalues=[sdvalues;sd];
%      else
%          sdvalues=[sdvalues;NaN];
%      end
% end
% end
function distances=computeWeightedDistances(descriptor,descriptorglobal,bins,levels,method,SESFW,section,descriptornn)



distances=[];

%%
if SESFW=='G';
    comparisonglobal=(descriptor(1:bins));
    
    temp(levels,2)=0;
    
    temp(1,1)=bins+1;
    temp(1,2)=[section^(2*1)*bins+temp(1,1)-1];
    
    for i=2:levels;
        temp(i,1)=temp(i-1,2)+1;
        temp(i,2)=section^(i*2)*bins+temp(i,1)-1;
    end
        
    temp2=1;
    
    distances(temp2)=sum(min(comparisonglobal,comparisonglobal));
    
    for i=1:levels;
        for j=temp(i,1):bins:temp(i,2);
            part=descriptor(j:j+bins-1);
            
            if max(comparisonglobal)>1e-8 && max(part)>1e-8;
                               
                dist1=sum(min(comparisonglobal,part));
                
                m1=mean(descriptornn(1:bins));
                m2=mean(descriptornn(j:j+bins-1));
                
                area=section^(i*2);
                m2=m2*area;
                
                 if(m1<1e-8||m2<1e-8)
                     
                     strengthsimilarity=0;
                 elseif (m1>m2)
                         strengthsimilarity=m2/m1;
                 else
                     strengthsimilarity=m1/m2;
                 end
    
                 
                dist1=dist1*(strengthsimilarity);
                distances=[distances;dist1];
            else
                
                distances=[distances;0];
            end
        end
    end
    
                     
end


%%
if SESFW=='N';
   
    temp(levels,2)=0;
    
    temp(1,1)=bins+1;
    temp(1,2)=[section^(2*1)*bins+temp(1,1)-1];
    
    for i=2:levels;
        temp(i,1)=temp(i-1,2)+1;
        temp(i,2)=section^(i*2)*bins+temp(i,1)-1;
    end
        
    descript=descriptor(temp(i,1):temp(i,2));
    descriptnn=descriptornn(temp(i,1):temp(i,2));

    descript=vec2mat(descript,bins);
    descriptnn=vec2mat(descriptnn,bins);
   
    a=1:section^(2*levels);
    
    vec=vec2mat(a,section^levels);
    
    s=size(vec);
    
    output(1:length(a),1:8)=0;
    
    output(1,1:3)=[vec(1,2),vec(2,1),vec(2,2)];
    output(s(2),1:3)=[vec(1,s(2)-1),vec(2,s(2)),vec(2,s(2)-1)];
    output(vec(s(1),1),1:3)=[vec(s(1)-1,1),vec(s(1),2),vec(s(1)-1,2)];    
    output(vec(s(1),s(2)),1:3)=[vec(s(1)-1,s(2)),vec(s(1)-1,s(2)-1),vec(s(1),s(2)-1)];    
    
    for i=2:s(2)-1;
        output(vec(1,i),1:5)=[vec(1,i-1),vec(1,i+1),vec(2,i-1),vec(2,i),vec(2,i+1)];
        output(vec(s(1),i),1:5)=[vec(s(1),i-1),vec(s(1),i+1),vec(s(1)-1,i-1),vec(s(1)-1,i),vec(s(1)-1,i+1)];
        
        output(vec(i,1),1:5)=[vec(i-1,1),vec(i+1,1),vec(i-1,2),vec(i,2),vec(i+1,2)];
        output(vec(i,s(2)),1:5)=[vec(i-1,s(2)),vec(i+1,s(2)),vec(i-1,s(2)-1),vec(i,s(2)-1),vec(i+1,s(2)-1)]; 
    end
        
    for i=2:s(1)-1;
        for j=2:s(2)-1;
            
            output(vec(i,j),1:8)=[vec(i-1,j-1),vec(i-1,j),vec(i-1,j+1),vec(i,j-1),vec(i,j+1),vec(i+1,j-1),vec(i+1,j),vec(i+1,j+1)];
            
        end
    end
            
    l=length(output);
    
    for i=1:l;
        for j=1:8;
            
            if max(descript(i,:))>1e-8 
                
                if output(i,j)>0 && max(descript(output(i,j),:))>1e-8
                    
                    dist1=sum(min(descript(i,:),descript(output(i,j),:)));
                   
                     m1=mean(descriptnn(output(i,j),:));
                     m2=mean(descriptnn(i,:));
                
                                          
                     if(m1<1e-8||m2<1e-8)
                         strengthsimilarity=0;
                 
                     elseif (m1>m2)
                         strengthsimilarity=m2/m1;
                 
                     else
                     strengthsimilarity=m1/m2;
                 
                     end
                     
                    dist1=dist1*(strengthsimilarity);
                    
                end
                
            else 
                
                dist1=0;
                
            end
            
        end
        
        distances=[distances;dist1];  

    end
        
end

%%

if SESFW=='P';
    
    distances=[1];

    temp2(1:length(descriptor)/bins,section^2)=0;

    descript=vec2mat(descriptor,bins);
    descriptnn=vec2mat(descriptornn,bins);


    temp(1,1)=bins+1;
    temp(1,2)=[section^(2*1)*bins+temp(1,1)-1];

    for i=2:levels;
    
        temp(i,1)=temp(i-1,2)+1;
        temp(i,2)=section^(i*2)*bins+temp(i,1)-1;
    end
    
    temp3(levels,2)=0;
    temp3(1,1)=1;
    temp3(1,2)=1;
    
     for i=1:levels;
        temp3(i+1,1)=section^(2*i);
        temp3(i+1,2)=temp3(i+1,1)+temp3(i,2);
     end
    
    temp5=1;
 
    for z=1:levels;
    
      temp4(section^z,section^z)=0;
      temp1(section^z,section^z)=0;
    
    

      temp6=temp3(z,2)+1:temp3(z+1,2);

      temp6=vec2mat(temp6,section^(z));

        for i=1:section:section^z;
            for j=1:section:section^z;
                temp4(i:i+section-1,j:j+section-1)=temp5;
                temp5=temp5+1;
            end
        end
                    
       for i=1:section^z;
          for j=1:section^z;
             if max(descript(temp4(i,j),:))>1e-8 && max(descript(temp6(i,j),:))>1e-8;
            
                    dist1=sum(min(descript(temp4(i,j),:),descript(temp6(i,j),:)));
            
                    m1=mean(descriptnn(temp4(i,j),:));
                    m2=mean(descriptnn(temp6(i,j),:));
            
                    area1=section^((i-1)*2);
                    area2=section^(i*2);
                
                    m1=m1*area1;
                   m2=m2*area2;
            
                  if(m1<1e-8||m2<1e-8)
                
                        strengthsimilarity=0;
                
                 elseif (m1>m2)
                           
                        strengthsimilarity=m2/m1;
                
                  else
                                    
                     strengthsimilarity=m1/m2;
    
                  end
                                
                 dist1=dist1*(strengthsimilarity);
                 distances=[distances;dist1];
            
             else
                 distances=[distances;0];
        
             end 
          end 
       end
    end
end


    
    
    
    
    
    
    
    
%     
%     distances=[1];
%     
%     temp2(1:length(descriptor)/bins,section^2)=0;
%     
%     descript=vec2mat(descriptor,bins);
%     
%     temp(1,1)=bins+1;
%     temp(1,2)=[section^(2*1)*bins+temp(1,1)-1];
%     
%     for i=2:levels;
%         temp(i,1)=temp(i-1,2)+1;
%         temp(i,2)=section^(i*2)*bins+temp(i,1)-1;
%     end
%     
%     temp3(levels,2)=0;
%     temp3(1,1)=1;
%     temp3(1,2)=1;
%     
%     for i=1:levels;
%         temp3(i+1,1)=section^(2*i);
%         temp3(i+1,2)=temp3(i+1,1)+temp3(i,2);
%     end
%         
%     temp4(section^levels,section^levels)=0;
%     temp1(section^levels,section^levels)=0;
%     
%     temp6=temp3(levels,2)+1;
%     temp5=temp3(levels-1,2)+1;
%     
%     
%     
%     for z=1:levels;
%         
%         for i=1:section^z;
%             for j=1:section^z;
%                 
%                 temp1(i,j)=temp6;
%                 temp6=temp6+1;
%             end
%         end
%         
%         for i=1:section:section^z;
%             for j=1:section:section^z;
%                 temp4(i:i+2,j:j+2)=temp5;
%                 temp5=temp5+1;
%             end
%         end
%         
%         for i=1:section^z;
%             for j=1:section^z;
%                 
%                 if max(descriptor(temp1(i,j),:))>1e-8 && max(descriptor(temp4(i,j),:))>1e-8
%                     
%                     dist1=sum(min(descriptor(temp1(i,j),:),descriptor(temp4(i,j),:)));
%                     
%                      m1=mean(descriptor(temp1(i,j),:));
%                      m2=mean(descriptor(temp4(i,j),:));
%                      
%                      area1=section^((i-1)*2);
%                      area2=section^(i*2);
%                      
%                      m1=m1*area1;
%                      m2=m2*area2;
%                 
%                      if(m1<1e-8||m2<1e-8)
%                          
%                          strengthsimilarity=0;
%                  
%                      elseif (m1>m2)
%                          strengthsimilarity=m2/m1;
%                  
%                      else
%                      strengthsimilarity=m1/m2;
%                  
%                      end
%                     
%                     dist1=dist1*(1-strengthsimilarity);
%                     distances=[distances;dist1];
%                 else
%                  distances=[distances;0];
%                 end
%             end          
%         end
%     end
%     
%     
%     
% end
% 



% 
% 
% 
%     
%     for i=1:section^levels;
%         for j=1:section^levels;
%             
%             temp1(i,j)=temp6;
%             temp6=temp6+1;
%             
%         end
%     end
%     
%     
%     temp5=temp3(levels-1,2)+1;
%     
%     for i=1:3:section^levels;
%         for j=1:3:section^levels;
%             temp4(i:i+2,j:j+2)=temp5;
%             temp5=temp5+1;
%         end
%     end
%     
%     
%     
%     for i=1:section^levels;
%         for j=1:section^levels;
%             
%             if max(descriptor(temp1(i,j),:))>1e-8 && max(descriptor(temp4(i,j),:))>1e-8
%                     
%                     dist=sum(min(descriptor(temp1(i,j),:),descriptor(temp4(i,j),:)));
%                     distances=[distances;dist];
%              else
%                 
%                 distances=[distances;0];
%             end
%                             
%             
%         end
%     end
% end














%%

% if nargin<4
%     method='euclidean';
% end
% 
% distances=[];
% %compare to global histogram
% comparison=getDescriptorPart(descriptor,bins,0,1,section);
% comparisonglobal=getDescriptorPart(descriptorglobal,bins,0,1,section);
% 
% 
% for l=0:levels
%      for pos=1:4^l
%      
%          part=getDescriptorPart(descriptor,bins,l,pos,section);
%          partglobal=getDescriptorPart(descriptorglobal,bins,l,pos,section);
%          strengthsim=strengthsimilarity(comparisonglobal,partglobal,l);
%         %compare to parent histogram
%          if l>0 && SESFW=='P'
%             comparison=getDescriptorPart(descriptor,bins,l-1,ceil(pos/4),section);
%          end
% 
%          distmatrix=[comparison';part'];
%          dist=0;
%          if max(comparison)>1e-8 && max(part)>1e-8
%              if  strcmp(method,'min')
%                  dist=mindistance(comparison,part);
%                  dist=dist*strengthsim;
%              else
%                  dist=pdist(distmatrix,method);
%                  dist=dist*(1-strengthsim);
%              end
%              distances=[distances;dist];
%          else
%              %distances=[distances;NaN];%comment this line if you change the next line
%              %distances=[distances;0];%change (activate) this line to include empty areas into the PHOG computation
%          end
%      end
% end
% end
% 
% 
% 

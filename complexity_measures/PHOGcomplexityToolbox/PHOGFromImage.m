function [descriptor,distancesatlevel,sdvalues,measures]=PHOGFromImage( filename,savedirectory,bins,angle,levels,re,shouldsave,SESFW,ALLFINAL,...
    SeSf,Co,AnI,section,loadname,fmt_load,sesfweight,TypeOfImage)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%input:
%   filename:    image name
%   directory:    image name
%   bins:    number of bins used 
%   angle:    180 or 360 
%   levels:    number of pyramid levels
%   re:    resize scale
%   shouldsave: save the result image
%output:
%   descriptor:    bin values for all the levels and sections
%   distancesatlevel:    median value of the bins in different levels.
%   sdvalues:    standard deviation, anisotropy
%   measures:    gradient, complexity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



I=imread(filename);

if re < 101
    I=imresize(I,re);
else
    I=RESIZE_Image(I,re);
end


if TypeOfImage=='D';
    temp=I;
    
    clear I;
    
    I=decolorize(temp,0.5,25,0.001);
    
    TypeOfImage='c';
    
end


distancesatlevel=[];
sdvalues=[];
measures=[];

roi = [1  size(I,1)  1  size(I,2)];

[descriptor,gradientValue,gradientAngle]=computeColorPHOGMAXLAB(section,I,bins,angle,levels,roi,TypeOfImage);

% size(descriptor)

descriptornn=descriptor;

descriptor=normalizeDescriptor(descriptor,bins);

% sum(descriptornn)
% sum(descriptor)
% size(descriptor)

save('gra.mat','gradientValue','gradientAngle');


descriptorglobal = computeDescriptorGlobal(gradientValue,gradientAngle, bins, angle, levels,section);

% sum(descriptorglobal)
% size(descriptorglobal)

distances=computeWeightedDistances(descriptor,descriptorglobal,bins,levels,'min',SESFW,section,descriptornn);
       
    
%     size(distances)
%     sum(distances)
%     max(distances)
%     median(distances)

if AnI==1;
    sdvalues=computeSD(descriptorglobal,bins,levels,section);
else 
    sdvalues=[];
end

 
%      sdvalues


if Co==1;
    measures=specialMeasures(gradientValue);
else
    measures=[];
end

%      measures

if SeSf==1 
    
    if SESFW=='P' || SESFW=='G';
        
        
         distancesatlevel=0;
        
        for i=1:levels;
            
            distancesateachlevel(i)=displayDistances(distances,bins,i,section);
            
            distancesatlevel=distancesatlevel+distancesateachlevel(i)*sesfweight(i);
            
        end
        
        distancesatlevel=distancesatlevel/sum(sesfweight);      
        
        
        
        
%         if ALLFINAL=='F'
%             distancesatlevel=displayDistances(distances,bins,levels,section);
%         end
%         
%         if ALLFINAL=='A'
%             distancesatlevel=median(distances);
%     
%         end
        
    elseif SESFW=='N';
        
        distancesatlevel=median(distances);
        
else
    distancesatlevel=[];
    end

%      distancesatlevel

if shouldsave=='Y';  
  
    savefigure(loadname,savedirectory,bins,angle,levels,re,section,descriptor,fmt_load);
    
end
        
end






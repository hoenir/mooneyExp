function [descriptor,GradientValue,GradientAngle] = computePHOGLAB(Img,bins,angle,levels,roi,section,TypeOfImage)
  %EdgeImg=edge(Img(:,:,1),'canny');
 
  if TypeOfImage=='C';
      
      [GradientX,GradientY] = maxGradient(Img);
      
  end
  
  if TypeOfImage=='S';
      
      [GradientX,GradientY] = SUMofGradient(Img);
      
  end
      
  GradientValue = sqrt((GradientX.*GradientX)+(GradientY.*GradientY));
            
  index = GradientX == 0;
  GradientX(index) = 1e-5;
            
  YX = GradientY./GradientX;
  if angle == 180, GradientAngle = ((atan(YX)+(pi/2))*180)/pi; end
  if angle == 360, GradientAngle = ((atan2(GradientY,GradientX)+pi)*180)/pi; end

  GradientValue = GradientValue(roi(1,1):roi(1,2),roi(1,3):roi(1,4));
  GradientAngle = GradientAngle(roi(1,1):roi(1,2),roi(1,3):roi(1,4));
  %EdgeImg=EdgeImg(roi(1,1):roi(1,2),roi(1,3):roi(1,4));
  %GradientValue = GradientValue.*EdgeImg;
    
  descriptor = computeDescriptor(GradientValue, GradientAngle, bins, angle, levels,section);
  
 
end % of function computePHOG
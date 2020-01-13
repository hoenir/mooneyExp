function [descriptor,gradientValue,gradientAngle] = computeColorPHOGMAXLAB(section,img_read,bins,angle,levels,roi,TypeOfImage)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computes Pyramid Histogram of Oriented Gradients over 'levels' pyramid
% levels using a roi or the whole image I
%
% INPUT:
%	I --input image (Color or Gray)
%	bins -- Number of bins on the histogram, needs to be a multiple of 3
%	angle -- 180 or 360
%       levels -- number of pyramid levels
%       roi - Region Of Interest (ytop,ybottom,xleft,xright)
%
% OUTPUT:
%	descriptor -- pyramid histogram of oriented gradients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
% check if roi is specified
if nargin < 6
      roi = [1  size(img_read,1)  1  size(img_read,2)];
end
  
% convert to gray image if necessary
if size(img_read,3) == 3
    Img=img_read;
    if strcmp(class(Img),'uint16')==1
        % devide the image by 255
        Img=Img/257;
    end
     Img = RGB2Lab(Img);
  else
    Img(:,:,1)=img_read;
    Img(:,:,2)=img_read;
    Img(:,:,3)=img_read;
    Img = RGB2Lab(Img);
end
%Anna Bosch method to avoid small gradients


[descriptor,gradientValue,gradientAngle] = computePHOGLAB(Img,bins,angle,levels,roi,section,TypeOfImage);  


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






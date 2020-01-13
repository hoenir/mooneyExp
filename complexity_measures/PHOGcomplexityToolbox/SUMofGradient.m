function [gradientX gradientY]=SUMofGradient(Img)
    gradientX=zeros(size(Img,1),size(Img,2));
    gradientY=zeros(size(Img,1),size(Img,2));
    
    [gradientRX gradientRY]=gradient(double(Img(:,:,1)));
    [gradientGX gradientGY]=gradient(double(Img(:,:,2)));
    [gradientBX gradientBY]=gradient(double(Img(:,:,3)));
   
    gradientX=gradientRX+gradientGX+gradientBX;
    gradientY=gradientRY+gradientGY+gradientBY;
                
end
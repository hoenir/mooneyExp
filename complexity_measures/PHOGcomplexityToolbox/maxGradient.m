function [gradientX gradientY]=maxGradient(Img)
    gradientX=zeros(size(Img,1),size(Img,2));
    gradientY=zeros(size(Img,1),size(Img,2));
    
    [gradientRX gradientRY]=gradient(double(Img(:,:,1)));
    [gradientGX gradientGY]=gradient(double(Img(:,:,2)));
    [gradientBX gradientBY]=gradient(double(Img(:,:,3)));
    for x=1:size(Img,1)
        for y=1:size(Img,2)
            maxX=gradientGX(x,y);
            if (abs(gradientRX(x,y))>abs(gradientGX(x,y)))
                maxX=gradientRX(x,y);
            end
            if (abs(gradientBX(x,y))>abs(maxX))
                maxX=gradientBX(x,y);
            end
            
            maxY=gradientGY(x,y);
            if (abs(gradientRY(x,y))>abs(gradientGY(x,y)))
                maxY=gradientRY(x,y);
            end
            if (abs(gradientBY(x,y))>abs(maxY))
                maxY=gradientBY(x,y);
            end
            gradientX(x,y)=maxX;
            gradientY(x,y)=maxY;
            
        end
    end
    
end
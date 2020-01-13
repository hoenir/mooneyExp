function Res_Img=RESIZE_Image(Img,S);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resize the file to a new image to a total number of S pixels
%
% INPUT:
%	Img -- Original image
%   S -- Number of pixels in the image
%	   
% OUTPUT:
%	Res_Img -- Result Image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s1=size(Img);

b=s1(1)*s1(2);

d=sqrt(S/b);

s2=round(s1*d);

Res_Img=imresize(Img,[s2(1) s2(2)]);

end
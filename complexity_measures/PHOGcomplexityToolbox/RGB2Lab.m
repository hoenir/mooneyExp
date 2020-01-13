function [L,a,b] = RGB2Lab(I_rgb)
%RGB2LAB Convert an image from RGB to CIELAB
%
% function [L, a, b] = RGB2Lab(I_rgb)

cform = makecform('srgb2lab');
I_lab=applycform(I_rgb,cform);
L=I_lab(:,:,1);
a=I_lab(:,:,2);
b=I_lab(:,:,3);
if nargout < 2
  L = I_lab;
end

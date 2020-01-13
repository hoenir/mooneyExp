
function r = quantiles(x,q);
% Usage:   Finds quantiles q of data x
% Assumes: quantiles 0 <= q <= 1
% Example: r=quantiles(x,[0; 0.5; 1]);
%           xmin=r(1); xmedian=r(2); xmax=r(3)

tolerance=100*eps;
q=q(:);
x=sort(x);
n=size(x,1);
k=size(x,2);
e=1/(2*n);
q=max(e,min(1-e,q));
q=n*q+0.5;
p=min(n-1,floor(q));
q=q-p;
q(find(tolerance>q))=0;
q(find(q>(1-tolerance)))=1; 
q=repmat(q,[1,k]);
r=(1-q).*x(p,:)+q.*x(p+1,:);
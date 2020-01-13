
function normalizeddescriptor=normalizeDescriptor(descriptor,bins)

b=reshape(descriptor,bins,length(descriptor)/bins);

c=sum(b);

s=size(b);
temp(s(1),s(2))=0;



    for i=1:s(2);
        if c(i)~= 0;
            temp(:,i)=b(:,i)./c(i);
        else
            temp(:,i)=b(:,i);
    
        end
              
    end



normalizeddescriptor=reshape(temp,length(descriptor),1);


end
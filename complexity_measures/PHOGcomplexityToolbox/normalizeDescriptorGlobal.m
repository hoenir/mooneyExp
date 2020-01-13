
function normalizeddescriptorGlobal=normalizeDescriptorGlobal(descriptor)
    
   if sum(descriptor) ~= 0
        normalizeddescriptorGlobal = descriptor/sum(descriptor);
   end 
   
end
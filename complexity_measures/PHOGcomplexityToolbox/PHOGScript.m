% function PHOGScript(loaddirectory,savedirectory,imageformat_load,imageformat_save)
function PHOGScript(SeSf,Co,AnI,...
    loaddirectory,imageformat_load,savedirectory,bins,angle,levels,re,SESFW,ALLFINAL,shouldsave,section,sesfweight,TypeOfImage)


    [descriptors,distances,sdvalues,measures,filenames]=PHOGDirectory(loaddirectory,...
        imageformat_load,savedirectory,SeSf,Co,AnI,bins,angle,levels,re,SESFW,ALLFINAL,shouldsave,section,sesfweight,TypeOfImage);
    
    PHOGsaveDATA(descriptors,distances,sdvalues,measures,filenames)
    
%     save data
    
%     savedata(savefile_descriptors,savefile_measures,descriptors,distances,sdvalues,measures,filenames);
    
end
 














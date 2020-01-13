function [descriptors,distances,sdvalues,measures,filenames]=PHOGDirectory(directory,fmt_load,savedirectory,...
    SeSf,Co,AnI,bins,angle,levels,re,SESFW,ALLFINAL,shouldsave,section,sesfweight,TypeOfImage)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%directory:         image directory
%fmt_load:          file format of the images
%savedirectory:     save directory of the converted images
%fmt_save:          file format for saving the converted images
%SeSf:    Self-Similarity
%Co:    Complexity
%AnI:  Anisotropy
%BLM:  Birkhoff-like measure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DirFiles = dir([directory '*.' fmt_load]);
mkdir(savedirectory);
distances=[];
descriptors=[];
sdvalues=[];
measures=[];
filenames={};

for i = 1:numel(DirFiles)
    loadname=[directory DirFiles(i).name];
    
    filename=DirFiles(i).name;
     
    strcat('PHOG loadname=',directory,DirFiles(i).name,'    (finished percentage: ',num2str(i/numel(DirFiles)),')')

    [descriptor,distance,sdvalue,measure]=PHOGFromImage(loadname,savedirectory,bins,angle,levels,re,shouldsave,SESFW,ALLFINAL,...
       SeSf,Co,AnI,section,filename,fmt_load,sesfweight,TypeOfImage);
     
    descriptors=[descriptors,descriptor];

    distances=[distances,distance];

    sdvalues=[sdvalues,sdvalue];
    
    measures=[measures,measure];
        
    filenames{i}=loadname;
    
%     
end;





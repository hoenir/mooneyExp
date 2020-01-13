function PROGRAMDIRECTORY()
  
warning off

aaa= exist ('data.mat');

if aaa==2;
    delete('data.mat')
end

    prompt = {'Enter the directory with the images to be loaded from (Exp: c:\loaddirectory):', ...
        'Enter the name of directory where the directory name Result with the results would be saved to (Exp: c:\savedirectory):', ...
        'Enter the format the image loaded has (Exp: tif):'};
    name = 'Input for PHOGScript';
    numlines = 1;    
%     defaultanswer = {'D:\test\images','D:\test', 'tif','tif'};    
    defaultanswer = {'D:\Matlab\PHOG\Test images','D:\Matlab\PHOG\PHOG Program\Subjective database results', 'tif'};    
    answer = inputdlg(prompt,name,numlines,defaultanswer);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%loaddirectory:    image directory to be loaded from
%savedirectory:    image directory to be saved to
%imageformat_load  image format of images in the load directory
%imageformat_save  image format of stored results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                                          %
    loaddirectory = answer{1};                                            %
    savedirectory = answer{2};                                            %
    imageformat_load = answer{3};                                         %
                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    loaddirectory=[loaddirectory '/'];
    savedirectory=[savedirectory];
    mkdir(savedirectory,'Result')
    tmp=regexp(savedirectory,'([^\\,/]*)','match');
    categoryname=tmp{length(tmp)};
   
    h=msgbox('In the next window Type 1 for all the values you want to be calculated','Warning');waitfor(h)
    
    prompt = {'Self-Similarity', ...
        'Complexity', ...
        'Anisotropy'};
    
    name = 'Program Functions';
    numlines = 1;    
    defaultanswer = {'1','1','1'};    
    answer = inputdlg(prompt,name,numlines,defaultanswer);
            
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %SeSf:    Self-Similarity
% %Co:    Complexity
% %AnI:  Anisotropy
% %BLM:  Birkhoff-like measure
% %CHist:  Color Histogram
% %R3rd:  Rule of Thirds calculation
% %QHue:  Number of quantized bins for the color channels
% %SAS:  Size and Aspect ratio
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                          %
    SeSf=str2num(answer{1});                                               %
    Co=str2num(answer{2});                                                 %
    AnI=str2num(answer{3});                                                %

    save data
                                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input values for Self-Similarity, Complexity, anisotropy and Birkhoff like
%Measure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%section:    number of sections in each level
%bins:    number of bins used 
%angle:    180 or 360 
%levels:    number of pyramid levels
%re:    resize scale
%SESFW:    What the self-similarity is based on (Ground level, parent section or neighbours)
%shouldsave:    Should the images be save or not.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    temp=[SeSf Co AnI];
    if max(temp)==1;

        prompt = {
            'Number of bins:', ...
            'Angle size (180 or 360):', ...
            'Number of levels', ...
            'Resize scale  or total pixel, any value higher than 100 will be accounted as the approximate total number of pixels in the new image (Exp: 0.5 or [256 256] or 10000)',...
            'What should the Self-Similarity be based on? (Ground image (G), Parent section (P) or Neighbours (N))',...
            'Select the weighting values for self-similarity at each level in the case of Ground image (G) and Parent section (P) (EXP [0 0 0 1] for a level 4 analysis)',...
            'Do you want to save the result images? (Y/N)'};
      name = 'Input for PHOG calculation';
      numlines = 1;    
        defaultanswer = {'16','360', '3','1','G','[1 1 1]','N'};    
        answer = inputdlg(prompt,name,numlines,defaultanswer);
    
        TypeOfImage='C'; 
        section=2;
        bins=str2num(answer{1});
        angle=str2num(answer{2});
        levels=str2num(answer{3});
        re=str2num(answer{4});
        SESFW=answer{5};        
        sesfweight=str2num(answer{6});
        shouldsave=answer{7};
        
        savespec2(levels);
        
        fileID = fopen(strcat(savedirectory,'\Result\specification.txt'),'w');

        fprintf(fileID,' method ');
        fprintf(fileID,'%d \t',TypeOfImage);
        fprintf(fileID,' section ');
        fprintf(fileID,'%d \t',section);
        fprintf(fileID,' bins ');
        fprintf(fileID,'%d \t',bins);
        fprintf(fileID,' angle ');
        fprintf(fileID,'%d \t',angle);
        fprintf(fileID,' levels ');
        fprintf(fileID,'%d \t',levels);
        fprintf(fileID,'based on ');
        fprintf(fileID,'%s \t',SESFW);


    end
    
                          
fclose('all');

temp=[SeSf Co AnI];
ALLFINAL='F';
    if max(temp)==1;
        
        PHOGScript(SeSf,Co,AnI,loaddirectory,imageformat_load,savedirectory,bins,angle,levels,re,SESFW,ALLFINAL,shouldsave,section,sesfweight,TypeOfImage);
        
    else
        
        filenames={};

        DirFiles = dir([loaddirectory '*.' imageformat_load]);
        for i = 1:numel(DirFiles)
            
            loadname=[loaddirectory DirFiles(i).name];
            
            filenames{i}=loadname;
        end
        
        savefilenames(filenames);
        
    end
    
    
    
    clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input values for color characeteristics measures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    load data
    
    temp=1;
    
    fileID = fopen(strcat(savedirectory,'\Result\filenames.txt'),'w');
    for i=1:length(filenames)
        fprintf(fileID,'%s',char(filenames(i)));
        fprintf(fileID,'\n');
    end
    
   fclose('all');
         
   temp2= [SeSf Co AnI];
   
   if max(temp2)==1;
       
       if SeSf==1;
           
           a(temp,:)=distances;
           temp=temp+1;
       end
          
       if Co==1;
           
           a(temp,:)=measures;
           temp=temp+1;
       end
   
       if AnI==1;
           
           a(temp,:)=sdvalues;
           temp=temp+1;
       end
          
         a=a'
         
         fprintf('Mean: '); 
         mean(a)
         fprintf('Standard Deviation: '); std(a)
         
         xlswrite(strcat(savedirectory,'\Result\res.xls'),a)
         
         save(strcat(savedirectory,'\Result\data.mat'))
    
         clear st
         
         fileID = fopen(strcat(savedirectory,'\Result\columns.txt'),'w');
    
       if SeSf==1;
       
          fprintf(fileID,'%s \t','Self-similarity');
       end
   
     if Co==1;
       
          fprintf(fileID,'%s \t','Complexity');
       
     end
   
       if AnI==1;
       
         fprintf(fileID,'%s \t','Anisotropy');
       
       end
   end
   
    fclose('all');
   

   
    clear st

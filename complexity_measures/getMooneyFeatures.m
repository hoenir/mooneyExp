function mooneyFeatures = getMooneyFeatures

files = dir('candidateMooneys'); % location of all images

namesIdx_tt = find(endsWith({files.name},'tt.jpg')); % mooney image
namesIdx_gs = find(endsWith({files.name},'gs.jpg')); % grayscale image

% load precalculated PHOG complexity results
load('PHOGcomplexityTooklbox/Result/PHOGresults.mat');

for n = 1:length(namesIdx_tt)
    fprintf('image %i of %i \n',n,length(namesIdx_tt));
    thisMooney = imread(strcat('candidateMooneys/',files(namesIdx_tt(n)).name));
    thisGrayscale = imread(strcat('candidateMooneys/',files(namesIdx_gs(n)).name)); 
    if length(size(thisGrayscale)) == 3
        thisGrayscale = rgb2gray(thisGrayscale);
    end
    if length(size(thisMooney)) == 3
        thisMooney = rgb2gray(thisMooney);
    end
    
    % calculate Shannon entropy
    ent_mooney = entropy(thisMooney);
    ent_grayscale = entropy(thisGrayscale);
    
    mooneyFeatures(n).imgName = files(namesIdx_tt(n)).name(1:end-6);
    mooneyFeatures(n).entropyMooney = ent_mooney;
    mooneyFeatures(n).entropyGrayscale = ent_grayscale;
    
    % calculate structural similarity between mooney and grayscale image
    [structSim, structSimMap] = ssim(thisMooney,thisGrayscale);
    
    mooneyFeatures(n).structSim = structSim;
    mooneyFeatures(n).structSimMap = structSimMap;
    
    % save PHOG complexity scores
    mooneyFeatures(n).selfSimilarityMooney = PHOGresults(namesIdx_tt(n)-2).selfSim;
    mooneyFeatures(n).selfSimilarityGrayscale = PHOGresults(namesIdx_gs(n)-2).selfSim;
    mooneyFeatures(n).PHOGcomplexityMooney = PHOGresults(namesIdx_tt(n)-2).complexity;
    mooneyFeatures(n).PHOGcomplexityGrayscale = PHOGresults(namesIdx_gs(n)-2).complexity;
    mooneyFeatures(n).anisotropyMooney = PHOGresults(namesIdx_tt(n)-2).anisotropy;
    mooneyFeatures(n).anisotropyGrayscale = PHOGresults(namesIdx_gs(n)-2).anisotropy;
    
    % canny edge detection
    canny_mooney = edge(thisMooney,'canny');
    edge_mooney = ones(size(canny_mooney));
    edge_mooney(canny_mooney == 1) = 0;
    
    canny_grayscale = edge(thisGrayscale,'canny');
    edge_grayscale = ones(size(canny_grayscale));
    edge_grayscale(canny_grayscale == 1) = 0;
    
    % get entropy of edges
    ent_edge_mooney = entropy(edge_mooney);
    ent_edge_grayscale = entropy(edge_grayscale);
    
    % save edge images & entropy of edges
    mooneyFeatures(n).edgeMooney = edge_mooney;
    mooneyFeatures(n).edgeGrayscale = edge_grayscale;
    mooneyFeatures(n).edgeEntropyMooney = ent_edge_mooney;
    mooneyFeatures(n).edgeEntropyGrayscale = ent_edge_grayscale;
    
    clear thisMooney thisGrayscale
end
end
    
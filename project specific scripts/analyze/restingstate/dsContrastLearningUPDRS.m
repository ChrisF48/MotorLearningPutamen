% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

close all;
clear;

datafolder = '\results\HCP\datscan_learning\firstlevel';

d = dir(fullfile(datafolder,'learning','*.nii'));
for i = 1:length(d)
    fprintf('.');
    nii1 = single(niftiread(fullfile(datafolder,'learning',d(i).name)));
    niiinfo = niftiinfo(fullfile(datafolder,'learning',d(i).name));    
    nii2 = single(niftiread(fullfile(datafolder,'updrsside',d(i).name)));    

    % Standardisierung
    nii1t = nii1(:);
    zeroinds1 = (nii1 <= 0);
    nii1t(nii1t <= 0) = [];
    m1 = mean(nii1t);
    s1 = std(nii1t);

    nii2t = nii2(:);
    zeroinds2 = (nii2 <= 0);    
    nii2t(nii2t <= 0) = [];
    m2 = mean(nii2t);    
    s2 = std(nii2t);

    nii1std = (nii1-m1)./s1;
    nii1std(zeroinds1) = 0;
    nii2std = (nii2-m2)./s2;
    nii2std(zeroinds2) = 0;    

    nii1(zeroinds1) = 0;
    nii2(zeroinds2) = 0;
    nii1 = nii1 - nii2;
    
    nii1std = nii1std - nii2std;

    niiinfo.Datatype = 'single';
    niftiwrite(nii1,fullfile(datafolder,'contrast',d(i).name),niiinfo);   
    niftiwrite(nii1std,fullfile(datafolder,'contraststd',d(i).name),niiinfo);       
end
fprintf('\n');
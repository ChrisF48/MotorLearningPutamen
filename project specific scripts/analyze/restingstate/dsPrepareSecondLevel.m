% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

close all;
clear;

datafolder = 'Resting State Connectivity Analysis\results\HCP\datscan_learning\firstlevel';

overwrite = 0;

d1 = dir(fullfile(datafolder,'cond_Rest_RL'));
for j = 3:length(d1)
    fprintf('%s',d1(j).name);
    if (exist(fullfile(datafolder,'avg','grouproi',d1(j).name)) && ~overwrite)
        fprintf('\n');        
        continue;
    end
    if (exist(fullfile(datafolder,'avg','singlesj',d1(j).name)) && ~overwrite)
        fprintf('\n');        
        continue;
    end    
    mkdir(fullfile(datafolder,'avg',d1(j).name));    
    d2 = dir(fullfile(datafolder,'cond_Rest_RL',d1(j).name,'*.nii'));
    for i = 1:length(d2)
        fprintf('.');
        nii1 = single(niftiread(fullfile(datafolder,'cond_Rest_RL',d1(j).name,d2(i).name)));
        niiinfo = niftiinfo(fullfile(datafolder,'cond_Rest_RL',d1(j).name,d2(i).name));    
        nii2 = single(niftiread(fullfile(datafolder,'cond_Rest_LR',d1(j).name,d2(i).name)));    
    
        nii1 = (nii1 + nii2)/2;
        niiinfo.Datatype = 'single';

        niftiwrite(nii1,fullfile(datafolder,'avg',d1(j).name,d2(i).name),niiinfo);    
    end
    fprintf('\n');
end
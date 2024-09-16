% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

close all;
clear;

datafolder = 'Resting State Connectivity Analysis\results\HCP\datscan_learning';


d1 = dir(fullfile(datafolder,'firstlevel','avg','grouproi'));
for i = 3:length(d1)
    matlabbatch = [];
    matlabbatch{1}.spm.stats.factorial_design.dir = {fullfile(datafolder,'secondlevel','grouproi')};
    src = fullfile(datafolder,'firstlevel','avg','grouproi',d1(i).name);

    d2 = dir(fullfile(src,'*.nii'));
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {};    
    for j = 1:length(d2)
        matlabbatch{1}.spm.stats.factorial_design.des.t1.scans{end+1,1} = sprintf('%s,1',fullfile(src,d2(j).name));
    end
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;    
    
    spm_jobman('run',matlabbatch);    

    matlabbatch = [];    
    matlabbatch{1}.spm.stats.fmri_est.spmmat = {fullfile(fullfile(datafolder,'secondlevel','grouproi'),'SPM.mat')};
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;  
    spm_jobman('run',matlabbatch);     

    target = fullfile(datafolder,'secondlevel','grouproi',d1(i).name);
    mkdir(target);    
    d2 = dir(fullfile(datafolder,'secondlevel','grouproi','*.nii'));
    for j = 1:length(d2)
        if (d2(j).isdir)
            continue;
        end
        movefile(fullfile(datafolder,'secondlevel','grouproi',d2(j).name),fullfile(target,d2(j).name));        
    end
    d2 = dir(fullfile(datafolder,'secondlevel','grouproi','*.mat'));
    for j = 1:length(d2)
        if (d2(j).isdir)
            continue;
        end        
        movefile(fullfile(datafolder,'secondlevel','grouproi',d2(j).name),fullfile(target,d2(j).name));        
    end    
end
% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

srcf = 'data\prep\coreg_indiv\datscan_tf';
srcf2 = 'data\prep\coreg_indiv\ct';

spm('defaults', 'FMRI');

d = dir(fullfile(srcf,'cP*.nii'));
for i = 1:length(d)
    disp(d(i).name);
    sn = d(i).name(2:4);

    matlabbatch = {};
    matlabbatch{1}.spm.tools.oldnorm.write.subj.matname = {fullfile(srcf2,sprintf('c%s_sn.mat',sn))};
    matlabbatch{1}.spm.tools.oldnorm.write.subj.resample = {[fullfile(srcf,sprintf('c%s.nii',sn)) ',1']};
    matlabbatch{1}.spm.tools.oldnorm.write.roptions.preserve = 0;
    matlabbatch{1}.spm.tools.oldnorm.write.roptions.bb = [-78 -112 -70
                                                          78 76 85];
    matlabbatch{1}.spm.tools.oldnorm.write.roptions.vox = [2 2 2];
    matlabbatch{1}.spm.tools.oldnorm.write.roptions.interp = 1;
    matlabbatch{1}.spm.tools.oldnorm.write.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.tools.oldnorm.write.roptions.prefix = 'w';

    spm_jobman('run', matlabbatch);    
end
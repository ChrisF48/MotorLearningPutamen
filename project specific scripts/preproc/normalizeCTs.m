% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

srcf = 'data\prep\coreg_indiv\ct';

matlabbatch = {};
matlabbatch{1} = [];
matlabbatch{1}.spm.tools.MRI.CTnorm.images = {};

d = dir(fullfile(srcf,'P*.nii'));
for i = 1:length(d)
    matlabbatch{1}.spm.tools.MRI.CTnorm.images{end+1,1} = [fullfile(srcf,d(i).name),',1'];
end

matlabbatch{1}.spm.tools.MRI.CTnorm.ctles = '';
matlabbatch{1}.spm.tools.MRI.CTnorm.brainmaskct = 1;
matlabbatch{1}.spm.tools.MRI.CTnorm.bb = [-78 -112 -50
                                          78 76 85];
matlabbatch{1}.spm.tools.MRI.CTnorm.vox = [2 2 2];
matlabbatch{1}.spm.tools.MRI.CTnorm.DelIntermediate = 0;
matlabbatch{1}.spm.tools.MRI.CTnorm.AutoSetOrigin = 1;

spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);
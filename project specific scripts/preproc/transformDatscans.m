% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

srcf = 'data\prep\coreg_indiv\datscan_tf';
srcf2 = 'data\prep\coreg_indiv\ct';

spm('defaults', 'FMRI');

d = dir(fullfile(srcf,'P*.nii'));
for i = 1:length(d)
    disp(d(i).name);
    sn = d(i).name(1:3);
    tm = load(fullfile(srcf2,sprintf('%s_tf2.mat',sn)));

    matlabbatch = {};
    matlabbatch{1}.spm.util.reorient.srcfiles = {[fullfile(srcf,sprintf('%s.nii',sn)) ',1']};
    matlabbatch{1}.spm.util.reorient.transform.transM = tm.tf_mat_origtoc;
    matlabbatch{1}.spm.util.reorient.prefix = 'i';    

    spm_jobman('run', matlabbatch);    

    matlabbatch = {};    
    matlabbatch{1}.spm.spatial.coreg.write.ref = {[fullfile(srcf2,sprintf('c%s.nii',sn)) ',1']};
    matlabbatch{1}.spm.spatial.coreg.write.source = {[fullfile(srcf,sprintf('i%s.nii',sn)) ',1']};
    matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'c';    

    spm_jobman('run', matlabbatch);        

    movefile(fullfile(srcf,sprintf('ci%s.nii',sn)),fullfile(srcf,sprintf('c%s.nii',sn)));    
end
delete(fullfile(srcf,'iP*.nii'));
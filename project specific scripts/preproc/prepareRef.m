% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

srcf1 = 'Toolboxes\MRIcron\Resources\templates';
srcf2 = 'data\prep\coreg_indiv\datscan_normalized';

info = niftiinfo(fullfile(srcf1,'brodmann.nii.gz'));
nii = niftiread(fullfile(srcf1,'brodmann.nii.gz'));

nii((nii < 17) | (nii > 19)) = NaN;

niftiwrite(nii,fullfile(srcf2,'ref.nii'),info);
% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

srcf2 = 'data\prep\coreg_indiv\datscan_normalized';

refnii = single(niftiread(fullfile(srcf2,'Masken','ref2.nii'))); % okzipitale Referenz
refnii(isnan(refnii)) = 0;
refnii(refnii ~= 0) = 1;

d = dir(fullfile(srcf2,'wc*.nii'));
for i = 1:length(d)
    info = niftiinfo(fullfile(srcf2,d(i).name));
    niis = single(niftiread(fullfile(srcf2,d(i).name)));
    info.Datatype = 'single';
    refd = nanmean(niis(refnii == 1));
    niis = niis / refd; % Normierung auf okzipitale Referenz
    niftiwrite(niis,fullfile(srcf2,sprintf('r%s',d(i).name)),info);
end
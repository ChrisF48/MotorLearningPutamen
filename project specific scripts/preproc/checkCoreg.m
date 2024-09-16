% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

srcf = 'data\prep\coreg_indiv\ct';
srcf2 = 'data\prep\coreg_indiv\datscan_normalized';

d = dir(fullfile(srcf,'w*.nii'));
data = [];
info = niftiinfo(fullfile(srcf,d(1).name));
for i = 1:length(d)
    disp(d(i).name);
    dn = niftiread(fullfile(srcf,d(i).name));   
    if (isempty(data))
        data = dn;
    else
        data = data + dn;
    end
end
data = data / length(d);
niftiwrite(data,fullfile(srcf,'average_ct.nii'),info);

d = dir(fullfile(srcf2,'rw*.nii'));
data = [];
info = niftiinfo(fullfile(srcf2,d(1).name));
for i = 1:length(d)
    disp(d(i).name);
    dn = niftiread(fullfile(srcf2,d(i).name));   
    if (isempty(data))
        data = single(dn);
    else
        data = data + single(dn);
    end
end
data = data / length(d);
niftiwrite(data,fullfile(srcf2,'raverage_datscan.nii'),info);


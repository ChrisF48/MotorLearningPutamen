% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

srcf1 = 'data\prep';
srcf2 = 'data\prep\coreg_indiv\datscan_normalized';

% klinische Daten laden
[~,~,r] = xlsread(fullfile(srcf1,'clinicaldata.xlsx'));

% Indices of interest
binds = 4;

% Datensatz vorbereiten
pats = {};
for i = 1:(size(r,1)-1)
    pats{i,1} = r{i+1,1};
    pats{i,2} = sprintf('rwc%s.nii',pats{i,1});
    for j = 1:length(binds)
        pats{i,2+j} = r{i+1,binds(j)};
    end
end

for i = 1:38
    info = niftiinfo(fullfile(srcf2,pats{i,2}));
    nii = single(niftiread(fullfile(srcf2,pats{i,2})));
    if (pats{i,3} == 2)
        for j = 1:size(nii,3)
            nii(:,:,j) = flipud(nii(:,:,j));
        end
    end
    info.Datatype = 'single';        
    niftiwrite(nii,fullfile(srcf2,sprintf('f%s',pats{i,2})),info);
end
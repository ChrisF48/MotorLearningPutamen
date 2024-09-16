% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

srcf1 = 'data\prep';
srcf2 = 'data\prep\coreg_indiv\datscan_normalized';

% klinische Daten laden
[~,~,r] = xlsread(fullfile(srcf1,'clinicaldata.xlsx'));

% Indices of interest
binds = [2 6 8 16:18 23:26];

% Datensatz vorbereiten
pats = {};
for i = 1:(size(r,1)-1)
    pats{i,1} = r{i+1,1};
    pats{i,2} = fullfile(srcf2,sprintf('rwc%s.nii',pats{i,1}));
    for j = 1:length(binds)
        pats{i,2+j} = r{i+1,binds(j)};
    end
end
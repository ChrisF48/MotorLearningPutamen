% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

srcf1 = 'data\prep';
srcf2 = 'data\prep\coreg_indiv\datscan_normalized';

% klinische Daten laden
[~,~,r] = xlsread(fullfile(srcf1,'clinicaldata.xlsm'));

% Indices of interest
binds = [6 8 14:17 23:24 27:29];

% Datensatzliste vorbereiten
pats = {};
for i = 1:38 %(size(r,1)-1)
    pats{i,1} = r{i+1,1};
    pats{i,2} = fullfile(srcf2,sprintf('frwc%s.nii',pats{i,1}));
    for j = 1:length(binds)
        pats{i,2+j} = r{i+1,binds(j)};
    end
end

% Niftis laden
niis = {};
for i = 1:size(pats,1)
    niis{i,1} = niftiinfo(pats{i,2});
    niis{i,2} = single(niftiread(pats{i,2}));
end

% Niftis maskieren
put = single(niftiread(fullfile(srcf2,'Masken','mask.nii')));
put = put/255;
for i = 1:size(niis,1)
    niis{i,3} = niis{i,2} .* put;
    niis{i,3}(niis{i,3} == 0) = NaN;
end

% Stats
stats = {};
for j = 1:length(binds)
    d = [];
    ds = [];
    dp = [];
    for i = 1:size(niis,1)
        d1 = pats{i,2+j};
        d2 = nanmean(niis{i,3}(:));
        d3 = nanstd(niis{i,3}(:))/nanmean(niis{i,3}(:));
        d4 = max(niis{i,3}(:));
        d = [d; [d1 d2]];
        ds = [ds; [d1 d3]];
        dp = [dp; [d1 d4]];
    end
    d(isnan(d(:,1)),:) = [];
    stats{1,j} = r{1,binds(j)};
    [stats{2,j} stats{3,j}] = corr(d(:,1),d(:,2));
    [stats{4,j} stats{5,j}] = corr(ds(:,1),ds(:,2));    
    [stats{6,j} stats{7,j}] = corr(dp(:,1),dp(:,2));        
    stats{8,j} = d;
    stats{9,j} = ds;    
    stats{10,j} = dp;        
end

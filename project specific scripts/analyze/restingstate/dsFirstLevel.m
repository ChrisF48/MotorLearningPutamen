% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

basefolder = 'Resting State Connectivity Analysis';
datafolder = 'Resting State Connectivity Analysis\data\HCP\subjects';
targetfolder = 'data\results\Connectivity';

d = load(fullfile(basefolder,'denoisingOptions','unsmoothed_95_GSR.mat'));
denOpt = d.denoisingOptions;
cd(basefolder);

% d = dir(fullfile(basefolder,'rois','*.nii'));
rois = [];
% for i = 1:length(d)
%     rois(i).name = d(i).name;
%     rois(i).type = 'image';
%     rois(i).file = fullfile(basefolder,'rois',d(i).name);
%     rois(i).gmMask = 0.0;        
% end

% sphärische Peak-Koordinaten, 5-7.5-10 mm
for i = 5:2.5:10
    rois(end+1).name = sprintf('peak_learning_%.1f',i);
    rois(end).type = 'sphere';
    rois(end).coords = [-28 -16 12];
    rois(end).radius = i;
    rois(end).gmMask = 0.0;   
    
    rois(end+1).name = sprintf('peak_updrs_side_%.1f',i);
    rois(end).type = 'sphere';
    rois(end).coords = [-28 0 6];
    rois(end).radius = i;
    rois(end).gmMask = 0.0;   
end

% % Einzelsubjekt-Peaks
% d = load(fullfile(basefolder,'rois','rois.mat'));
% for i = 1:size(d.rois,1)
%     rois(end+1).name = sprintf('%s_peak',d.rois{i,1}(5:7));
%     rois(end).type = 'sphere';
%     rois(end).coords = d.rois{i,4};
%     rois(end).radius = 2.5;
%     rois(end).gmMask = 0.0;   
% end
% for i = 1:size(d.rois,1)
%     rois(end+1).name = sprintf('%s_cog',d.rois{i,1}(5:7));
%     rois(end).type = 'sphere';
%     rois(end).coords = d.rois{i,6};
%     rois(end).radius = 2.5;
%     rois(end).gmMask = 0.0;   
% end

sj = load(fullfile(datafolder,'subjects.mat'));
sj = sj.subjects;
sj = afxUpdatePaths(sj);

incl = 1:length(sj); 
incl = 1:2;

afxFirstlevel(sj,denOpt,rois,'datscan_learning',{'fc_wholebrain'},incl);
 
%system('shutdown /s /t 600');
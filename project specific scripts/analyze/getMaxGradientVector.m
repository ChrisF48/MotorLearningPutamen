% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

srcf1 = 'data\prep';
srcf2 = 'data\prep\coreg_indiv\datscan_normalized';

load(fullfile(srcf2,'Masken','rois.mat'));

[~,~,r] = xlsread(fullfile(srcf1,'clinicaldata.xlsm'));
global behavdata;
behavdata = cell2mat(r(2:39,8));

center = avg_rois{2,2};
global coords;
coords = avg_rois{1,2} - repmat(center,38,1);

x0 = 0;
options = optimset('PlotFcns','optimplotfval');
phimin = fminsearch(@rotcorr,x0,options)
[~,rmax,pmax,projcoords,rotdir] = rotcorr(phimin);
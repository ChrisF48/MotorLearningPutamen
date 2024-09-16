% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

srcf = 'data\raw';
tgtf = 'data\prep\coreg_indiv';

d = dir(srcf);
mkdir(fullfile(tgtf,'ct'));
mkdir(fullfile(tgtf,'datscan_tf'));
for i = 3:length(d)
    disp(d(i).name);
    if ((d(i).isdir) && (d(i).name(1) == 'P'))
        copyfile(fullfile(srcf,d(i).name,'ct.nii'),...
                 fullfile(tgtf,'ct',sprintf('%s%s',d(i).name(1:3),'.nii')));
        copyfile(fullfile(srcf,d(i).name,'datscan_tf.nii'),...
                 fullfile(tgtf,'datscan_tf',sprintf('%s%s',d(i).name(1:3),'.nii')));        
    end
end


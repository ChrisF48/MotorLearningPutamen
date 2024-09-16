% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

srcf2 = 'data\prep\coreg_indiv\datscan_normalized\Masken';

info = niftiinfo(fullfile(srcf2,'intensityds.nii'));
nii = niftiread(fullfile(srcf2,'intensityds.nii'));

x = [-45 0];
y = [-32 31];
z = [-32 31];

sn1 = size(nii,1);
sn2 = size(nii,2);
sn3 = size(nii,3);
for i1 = 1:sn1
    fprintf('.');
    parfor i2 = 1:sn2
        for i3 = 1:sn3
            p = info.Transform.transformPointsForward([i1 i2 i3]);            
            if ~(((p(1) >= x(1)) && (p(1) <= x(2)) &&...
                (p(2) >= y(1)) && (p(2) <= y(2)) &&...
                (p(3) >= z(1)) && (p(3) <= z(2))))
                nii(i1,i2,i3) = 0.0;
            end
        end
    end
end
fprintf('\n');

niftiwrite(nii,fullfile(srcf2,'mask.nii'),info);
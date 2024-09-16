% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

srcf2 = 'data\prep\coreg_indiv\datscan_normalized';

mask = niftiread(fullfile(srcf2,'Masken','mask.nii'));
d = dir(fullfile(srcf2,'frw*.nii'));
rois = {};
for i = 1:length(d)
    fprintf('.');
    nii = niftiread(fullfile(srcf2,d(i).name));
    info = niftiinfo(fullfile(srcf2,d(i).name));
    nii(mask == 0) = 0;
    
    mv = 0;
    mc = [];
    cog = [];
    for x = 1:size(nii,1)
        for y = 1:size(nii,2)
            for z = 1:size(nii,3)
                if (nii(x,y,z) > mv)
                    mv = nii(x,y,z);
                    mc = [x y z];
                end
                if (nii(x,y,z) > 0)
                    cog = [cog; [x y z nii(x,y,z)]];
                end
            end
        end
    end
    cog(:,4) = cog(:,4)-min(cog(:,4));
    cog(:,4) = cog(:,4)/max(cog(:,4));
    cogp = (cog(:,1:3)'*cog(:,4))/sum(cog(:,4));
    rois{i,1} = d(i).name;
    rois{i,2} = mc;
    rois{i,3} = mv;
    rois{i,5} = cogp';
    rois{i,4} = info.Transform.transformPointsForward(mc);
    rois{i,6} = info.Transform.transformPointsForward(cogp');    
end
fprintf('\n');
return;
%%
% Learning
nii = niftiread(fullfile(srcf2,'Results','Learning','spmT_0001.nii'));
info = niftiinfo(fullfile(srcf2,'Results','Learning','spmT_0001.nii'));
cog = [];
mv = 0;
mc = [];
for x = 1:size(nii,1)
    for y = 1:size(nii,2)
        for z = 1:size(nii,3)
            if (nii(x,y,z) > mv)
                mv = nii(x,y,z);
                mc = [x y z];
            end
            if (nii(x,y,z) > 0)
                cog = [cog; [x y z nii(x,y,z)]];
            end
        end
    end
end
cog(:,4) = cog(:,4)-min(cog(:,4));
cog(:,4) = cog(:,4)/max(cog(:,4));
cogp = (cog(:,1:3)'*cog(:,4))/sum(cog(:,4));
rois_tv{1,1} = 'Learning';
rois_tv{1,2} = mc;
rois_tv{1,3} = mv;
rois_tv{1,5} = cogp';
rois_tv{1,4} = info.Transform.transformPointsForward(mc);
rois_tv{1,6} = info.Transform.transformPointsForward(cogp');    

%%
% UPDRS
nii = niftiread(fullfile(srcf2,'Results','UPDRSSeite','spmT_0001.nii'));
info = niftiinfo(fullfile(srcf2,'Results','UPDRSSeite','spmT_0001.nii'));
cog = [];
mv = 0;
mc = [];
for x = 1:size(nii,1)
    for y = 1:size(nii,2)
        for z = 1:size(nii,3)
            if (nii(x,y,z) > mv)
                mv = nii(x,y,z);
                mc = [x y z];
            end
            if (nii(x,y,z) > 0)
                cog = [cog; [x y z nii(x,y,z)]];
            end
        end
    end
end
cog(:,4) = cog(:,4)-min(cog(:,4));
cog(:,4) = cog(:,4)/max(cog(:,4));
cogp = (cog(:,1:3)'*cog(:,4))/sum(cog(:,4));
rois_tv{2,1} = 'UPDRSSeite';
rois_tv{2,2} = mc;
rois_tv{2,3} = mv;
rois_tv{2,5} = cogp';
rois_tv{2,4} = info.Transform.transformPointsForward(mc);
rois_tv{2,6} = info.Transform.transformPointsForward(cogp');    

%%
avg_rois = {};
avg_rois{1,1} = [];
avg_rois{1,2} = [];
for i = 1:size(rois,1)
    avg_rois{1,1} = [avg_rois{1,1}; rois{i,4}];
    avg_rois{1,2} = [avg_rois{1,2}; rois{i,6}];    
end
avg_rois{2,1} = mean(avg_rois{1,1},1);
avg_rois{2,2} = mean(avg_rois{1,2},1);
avg_rois{3,1} = std(avg_rois{1,1});
avg_rois{3,2} = std(avg_rois{1,2});
avg_rois{4,1} = std(avg_rois{1,1})/sqrt(size(rois,1));
avg_rois{4,2} = std(avg_rois{1,2})/sqrt(size(rois,1));

%%
save(fullfile(srcf2,'Masken','rois.mat'),'rois','avg_rois','rois_tv');
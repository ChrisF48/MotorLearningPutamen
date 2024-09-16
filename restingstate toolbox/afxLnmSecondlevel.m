function [allMean,allMeanZ,allT] = afxLnmSecondlevel(firstlevelInfo,groups)
    if nargin < 2, groups = []; end
    if nargin < 1 || isempty(firstlevelInfo)
        firstlevelInfo = spm_select(1,'^firstlevel_info.mat$','Select firstlevel_info.mat',{},'results');
    end

    % load firstlevel information
    info = load(firstlevelInfo);
    dirFirstlevel = fullfile('results',info.firstlevelDir,'firstlevel');
    dirSecondlevel = fullfile('results',info.firstlevelDir,'secondlevel','lnsm');
    
    spm_jobman('initcfg'); % afxNlmMean uses jobmanager
    
    allT = cell(length(info.rois),1);
    allMean = cell(length(info.rois),1);
    
    % mean ROI connectivity
    for iRoi = 1:length(info.rois)
        fil = {};
        for iSubject =  find(~[info.subjects.exclude])
            for iCond = 1:length(info.subjects(iSubject).conditions)
                fil{end+1,1} = fullfile(dirFirstlevel,['cond_' info.subjects(iSubject).conditions(iCond).name],['roi_' info.rois(iRoi).name],[info.subjects(iSubject).name '.nii']);
            end
        end
        
        fMean  = fullfile(dirSecondlevel,'mean',['mean_roi_' info.rois(iRoi).name '.nii']);
        fT  = fullfile(dirSecondlevel,'ttest',['tmap_roi_' info.rois(iRoi).name '.nii']);
        
        afxLnmMean(fil,fMean);
        afxLnmTTest(fil,fT,iCond);
        
        allT{iRoi} = fT;
        allMean{iRoi} = fMean;
    end
    
    % Threshold .00005, see Boes et al.
    alpha = .00005;
    df = length(find(~[info.subjects.exclude]))-1;
    tCrit = tinv(1-alpha,df);
    fTCrit = fullfile(dirSecondlevel,'ttest','info.txt'); 
    fid = fopen(fTCrit,'wt');
    fprintf(fid, 'df = %i\nwith alpha = %f and one-tailed testing, tCrit = %f\n',df,alpha,tCrit);
    fclose(fid);
end

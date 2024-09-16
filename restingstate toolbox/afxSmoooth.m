function y = afxSmoooth(y,FWHM,dim,mat)
    % y = afxSmoooth(y,FWHM,dim,mat)
    % convolve data in y (linearly packed in the spatial dimension with
    % original dimensions dim and q-form matrix mat) with gausian smoothing
    % kernel with full width at half maximum of FWHM

    fprintf('   Smoothing ...')
    if (length(FWHM) == 1) 
        FWHM = [FWHM FWHM FWHM]; 
    end
   % y2 = y;
    if (FWHM ~= [0 0 0])
		% adapt fwhm to voxel size
		FWHM = FWHM./abs([mat(1,1) mat(2,2) mat(3,3)]);
		% generate dummy matrix for smoothed data
		sdat = nan(dim);
		% iterate over all timepoints
        fracs = 32; % ggf. Speicherüberlauf beachten
        done = 0;
        pos = 1;
        steps = round(size(y,1)/fracs);
        while (~done)
            st = pos;
            if (st > size(y,1))
                break;
            end
            en = pos+steps-1;
            if (en >= size(y,1))
                en = size(y,1);
                done = 1;
            end
            yk = y(st:en,:);
            parfor i = 1:size(yk,1)
			    % perform smoothing
			    spm_smooth(reshape(yk(i,:),dim),sdat,FWHM);
			    % copy data back to y
			    yk(i,:) = sdat(:);
            end
            y(st:en,:) = yk;
            pos = pos+steps;
            if (pos > size(y,1))
                done = 1;
            end
        end
% 	    for i = 1:size(y2,1)
% 		    % perform smoothing
% 		    spm_smooth(reshape(y2(i,:),dim),sdat,FWHM);
% 		    % copy data back to y
% 		    y2(i,:) = sdat(:);
%         end        
    end
    fprintf(' done\n')
end
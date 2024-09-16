% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

function [rmin,r,p,v,rotdir] = rotcorr(x)
    global behavdata;
    global coords;
    rotmat = @(phi) [[cos(phi) sin(phi)];[-sin(phi) cos(phi)]];

    rotdir = [rotmat(x(1))*[1 0]'; 0];
    
    v = [];
    for i = 1:size(coords,1)
        v = [v; coords(i,:) * rotdir];
    end
    [r,p] = corr(v,behavdata);
    rmin = 1-abs(r);
end


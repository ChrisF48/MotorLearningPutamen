function [p,pt] = permtest(x1,x2,n)
    if ((size(x1) ~= size(x2)) | (x1 == x2))
        p = NaN;
        pt = NaN;
        return;
    end
    diffs = zeros(n,1);
    for i = 1:n
        x = [x1 x2];
        sel = randi(2,length(x1),1);
        xt1 = zeros(length(x1),1);
        xt2 = zeros(length(x2),1);
        for j = 1:length(sel)
            xt1(j) = x(j,sel(j));
            xt2(j) = x(j,3-sel(j));
        end
        diffs(i) = mean(xt1-xt2);
    end
    testdiff = mean(x1-x2);
    nlow = length(find(diffs < testdiff));
    nhigh = length(find(diffs > testdiff));
    p = (min(nlow,nhigh)/n)*2;
    
    [~,pt] = ttest(x1,x2);
end


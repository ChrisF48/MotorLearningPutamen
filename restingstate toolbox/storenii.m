function storenii(fn,data,templheader)
    s = max(max(max(abs(data)))) / double(intmax('int16'));
    nh = templheader;
    nh.Filename = fn;    
    nh.MultiplicativeScaling = s;
    nh.AdditiveOffset = 0;    
    av = int16(data/s);    
    niftiwrite(av,nh.Filename,nh); 
end


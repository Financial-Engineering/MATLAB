fnames = dir;
l = length(fnames);
for i=1:l % exclude . and ..        
    file = fnames(i).name;
    if (length(strfind(file,'.mat')) > 0)
            load(file, '-mat');
    end                
end

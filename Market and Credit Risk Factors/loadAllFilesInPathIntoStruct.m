function [outputs] = loadAllFilesInPathIntoStruct(path)
    fnames = dir(path);
    path = strcat(path, '\');
    l = length(fnames);
    j = 1;
    for i=1:l % exclude . and ..        
        file = strcat(path,fnames(i).name);        
        if (length(strfind(file,'.mat')) > 0)
            outputs(j,1) = struct2cell(load(file, '-mat'));
            j = j + 1;
        end                
    end
end
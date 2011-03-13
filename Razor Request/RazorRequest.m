function xml = RazorRequest(s)

    import java.io.*;
    import java.net.*;
    import java.lang.ProcessBuilder;
    
    dir = getenv('MATLAB_RAZOR_REQUEST');

    if strcmp(dir,'')
        err = MException('RazorRequest:EnvVarNotSet',...
            'The environment variable: MATLAB_RAZOR_REQUEST is not set');
        throw(err);
    end
    
    env = getenv('MATLAB_RAZOR_CONFIG');

    if strcmp(env,'')
        err = MException('RazorRequest:EnvVarNotSet',...
            'The environment variable: MATLAB_RAZOR_CONFIG is not set');
        throw(err);
    end
   
    % Replace this with the 64bit COM DLL
    cmd = [dir 'req.cmd'];
    
    % launch script and grab stdin/stdout and stderr
    processBuilder = ProcessBuilder(cmd);
    processBuilder.directory(File(env));
    
    process = processBuilder.start();
    
    stdin = process.getOutputStream();
    stdout = process.getInputStream();

    stdin.write(java.lang.String(s).getBytes());
    stdin.flush();

    stdin.close();

    bReader = BufferedReader(InputStreamReader(stdout));
        
    xml = '';
    
    line = bReader.readLine();    
    while line ~= ''
       xml = [xml char(line)];
       line = bReader.readLine();
    end
    
    bReader.close();

end


function [timestamp] = Readtfile(tfile)

    tfp = fopen(tfile, 'rb','b');
    if (tfp == -1)
        warning([ 'Could not open tfile ' tfn]);
    end

    ReadHeader(tfp);    
    
    timestamp = fread(tfp,inf,'uint32');	%read as 32 bit ints
    fclose(tfp);
    
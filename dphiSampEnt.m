% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

function v = dphiSampEnt(data, col1, col2);

    samplingRate = 16; %Needs to be turned to 100Hz according to relvant article (1600Hz/16 = 100Hz)
    
    [rows, columns] = size(data);
    
    %data(1:rows, col1:col2)
    
    i = 1;
    sampleLen=1;
    while i + samplingRate <= rows
        %data(i, col1:col2)
        %data(i+samplingRate, col1:col2)
        V1(sampleLen) = data(i+samplingRate, col1) - data(i, col1);
        V2(sampleLen) = data(i+samplingRate, col2) - data(i, col2); 
        i = i + samplingRate;
        sampleLen = sampleLen + 1;
    end
    sampleLen = sampleLen - 1;
    
    %V1
    
    for i = 1:sampleLen
        phi(i) = rad2deg(atan2(V2(i), V1(i)));
        if phi(i) < 0
            phi(i) = phi(i) + 360;
        end
    end
    
   %phi
    dPhi=[];
    for i = 1:sampleLen-1
       dPhi(i) = phi(i+1) - phi(i);
       if dPhi(i) < -180
           dPhi(i) = dPhi(i) + 360;
       end
       if dPhi(i) > 180
           dPhi(i) = dPhi(i) - 360;
       end
    end
    
    %dPhi
    
    m=3;
    r=0.2;
    [e,se,A,B] = sampen(dPhi, m+1, r, 1 ,0);
    %Return the last sample entropy (m=3)
    v = e(m);
    
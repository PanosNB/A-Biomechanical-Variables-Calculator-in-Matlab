% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

function f = filterForceplateData(data)
    % Find the size of the raw file
    [rows, columns] = size(data);

    % Define the sampleRate and cut-off frequency for the filter
    freq = 6;
    Fs = 1600;

    % The design of the lowpass filter
    Hd = designfilt('lowpassfir','FilterOrder',20,'CutoffFrequency',freq, ...
    'DesignMethod','window','Window',{@kaiser,3},'SampleRate',Fs);

    % Filtered required signals only
    for i = 1:columns
        if (i>2 && i < 11) || (i > 19 && i < 28)
            x(:,i) = filter(Hd,data(:,i)); 
        else 
            x(:,i) = data(:,i); 
        end
    end

    f = x;

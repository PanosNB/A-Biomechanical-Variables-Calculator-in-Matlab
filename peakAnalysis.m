% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

function [lr, tz1, tz2, tz3] = peakAnalysis(data, col);
    
    [rows, columns] = size(data);
    
    limit = mean(-(data(:, col)));% + std(-(data(:, col)));
    warning ('off','all');
    [pks,locs,w,p] = findpeaks(-(data(:, col)),'MinPeakHeight',limit);
    
    [fztz2, tz2] = max((data(locs(1):locs(length(locs)), col)));

    
    if size(locs)>=1
        lr = abs(data(locs(1), col)/locs(1)); %Loading Rate
        tz1 = locs(1); %First peak time
        tz2 = tz2 + tz1;
        tz3 = locs(length(locs)); %Last peak time
    else
        lr = '';
        tz1 = '';
        tz2 = '';
        tz3 = '';
    end
    
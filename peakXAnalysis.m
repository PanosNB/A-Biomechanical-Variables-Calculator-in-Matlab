% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

function [updatedData, tx1, tx2, tx3] = peakXAnalysis(data, col);
    
    [rows, columns] = size(data);
    
    limit = mean(-(data(:, col)));% + std(-(data(:, col)));
    warning ('off','all');
    [pks,locs,w,p] = findpeaks(-(data(:, col)),'MinPeakHeight',limit);
    
    [mn, tx1] = min(data(:, col));
    [mx, tx3] = max(data(:, col));
    
    if tx1 > tx3
       data(:, col) = -data(:, col);
       temp = tx1;
       tx1 = tx3;
       tx3 = temp;
    end
    
    updatedData = data;
    
    M = data(tx1:tx3,col);
    tx2 = tx1;
    if length(M)>0
        nearZeroPoints = find(M(:).*circshift(M(:), [-1 0]) <= 0);
        if length(nearZeroPoints)>0
            tx2 = nearZeroPoints(1) + tx1;
        end       
    end
    
    
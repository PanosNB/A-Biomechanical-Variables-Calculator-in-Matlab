% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

function [m ,s] = displacement2d(data, col1, col2);
    
    [rows, ~] = size(data);
    dist = zeros(1, rows-1);
    for i = 2:rows
       dist(i-1)=sqrt((data(i, col1) - data(i-1, col1))^2 + (data(i, col2) - data(i-1, col2))^2);
    end
    
    m = mean(dist);
    s = std(dist);
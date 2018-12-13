% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

function [m, s] = displacement1d(data, col);
    
    [rows, ~] = size(data);
    disp = zeros(1, rows-1);
    for i = 2:rows
       disp(i-1) = abs(data(i, col) - data(i-1, col)); 
    end
    m = mean(disp);
    s = std(disp);
% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

function [m, s] = meanStd(data, col);
    
    [rows, columns] = size(data);
    m = mean(data(1:rows,col));
    s = std(data(1:rows,col));
    
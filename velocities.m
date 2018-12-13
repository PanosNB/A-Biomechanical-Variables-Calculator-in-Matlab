% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

function [COPVelocity, COPXVelocity, COPYVelocity] = velocities(data, col1, col2);
    
    [rows, ~] = size(data);
    totalDist = 0;
    distX = 0;
    distY = 0;
    for i = 2:rows
       totalDist = totalDist + sqrt((data(i, col1) - data(i-1, col1))^2 + (data(i, col2) - data(i-1, col2))^2);
       distX = distX + sqrt((data(i, col1) - data(i-1, col1))^2);
       distY = distY + sqrt((data(i, col2) - data(i-1, col2))^2);
    end
    
    COPVelocity = totalDist/rows;
    COPXVelocity = distX/rows;
    COPYVelocity = distY/rows;

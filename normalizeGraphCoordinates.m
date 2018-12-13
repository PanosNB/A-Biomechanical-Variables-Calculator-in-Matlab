% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

function [xNorm, yNorm] = normalizeGraphCoordinates(coords, xlim, ylim);
    
    xNorm = (coords(1)-xlim(1))/(xlim(2)-xlim(1))*8/10+1/10;
    yNorm = (coords(2)-ylim(1))/(ylim(2)-ylim(1))*0.7;
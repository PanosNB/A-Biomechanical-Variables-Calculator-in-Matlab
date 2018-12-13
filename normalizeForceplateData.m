% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

function normData = normalizeForceplateData(data, weight, cols)
    % Find the size of the raw file
    [rows, columns] = size(data);

    for j = 1:columns
        found = false;
        for k = cols
           if k == j
               found = true;
               break;
           end
        end
        if found
            normData(:,j) = data(:, j)/weight;
        else
            normData(:,j) = data(:, j);
        end
    end


% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

function stepData = splitSteps(data, cols);

    % Assumptions (To be checked)
    minimumStepLength = 160; %0.1s => 1600*0.1 = 160
    maximumStepLength = 40000;

    [rows, columns] = size(data);
    k = 0;
    for j = cols
        if j <= columns
            n = 0;
            inStep = false;
            for i = 1:rows
                if ~inStep
                    if abs(data(i,j)) > 0.05
                        n = 1;
                        inStep = true;
                    end
                else
                    if abs(data(i,j)) > 0.05
                        n = n + 1;
                    else
                        inStep = false;
                        if n > minimumStepLength
                            k = k + 1;
                            
                            steps(k).firstLine = i-n;
                            
                            if n > maximumStepLength
                                n = maximumStepLength;
                            end
                            
                            steps(k).data = data(steps(k).firstLine:steps(k).firstLine + n - 1, 1:columns);
                            [stepDuration, ~] = size(steps(k).data);
                            steps(k).stepDuration = stepDuration;
                            steps(k).fZcol = j;
                        end
                    end
                end
            end
            if inStep
                if n > minimumStepLength
                    k = k + 1;
                            
                    steps(k).firstLine = i-n;
                            
                    if n > maximumStepLength
                        n = maximumStepLength;
                    end

                    steps(k).data = data(steps(k).firstLine:steps(k).firstLine + n - 1, 1:columns);
                    [stepDuration, ~] = size(steps(k).data);
                    steps(k).stepDuration = stepDuration;
                    steps(k).fZcol = j;
                end
            end
        end
    end

    if k>=1
        % Sort steps by time
        [~,sortIdx] = sort([steps.firstLine]);
        stepData = steps(sortIdx);
    else
        stepData = [];
    end
        
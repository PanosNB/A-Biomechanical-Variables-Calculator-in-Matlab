% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

% Source: http://www.cs.utah.edu/~tch/CS4300/resources/refs/ErrorEllipses.pdf
% https://www.ngs.noaa.gov/PUBS_LIB/AlgorithmsForConfidenceCirclesAndEllipses_TR_NOS107_CGS3.pdf

function v = ellipseArea(data, col1, col2);
    
    % For 95% confidence ellipse
    scaleFactor = 2.4477;

    covs = cov(data(:,col1), data(:,col2));
    
    [~, eigenval ] = eig(covs);
    
    l1 = sqrt(eigenval(1,1))*scaleFactor;
    
    l2 = sqrt(eigenval(2,2))*scaleFactor;
    
    v = pi*l1*l2;

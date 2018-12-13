% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

clear ALL;
clc;

v = [1 2 3 4 1 2 3 4 5];
[e,se,A,B] = sampen(v, 5, .2 ,1 ,0);
e

return
for j=1:8
    for n=0:0.1:2
        size = 1000;
        v = zeros(1, size);
        for i=1:size
           v(i) = mod(i, 2) + n*rand(); 
        end

        [e,se,A,B] = sampen(v, 5, 0.2 ,1 ,0);

        fprintf("%g\t%g\n", n, e(1));
    end
end
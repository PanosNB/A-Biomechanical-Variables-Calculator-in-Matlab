% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.
clear ALL;
clc;

% SAMPLING_RATE
SAMPLING_RATE = 1600;

% Display figures
DISPLAY_FIGURES = true;

% Display annotations
DISPLAY_ANNOTATIONS = false;

% Define column numbers for required data
Fx3 = 3;
Fy3 = 4;
Fz3 = 5;

Fx2 = 20;
Fy2 = 21;
Fz2 = 22;

Cx3 = 9;
Cy3 = 10;

Cx2 = 26;
Cy2 = 27;

% Step-length limit for dislaying graphs
figureLengthLimit = 6000;

% Read ParticipantInfo file
partWeightCol = 4;
partStatusCol = 7;
participantInfo = csvread("./ParticipantInfo.csv", 1, 0);

%Display headers
fprintf("File\tStatus\tFZCol\tFirstLine\tstepDuration\tfyAvg (BW)\tfxAvg (BW)\tfzAvg (BW)\tfyStd (BW)\tfxStd (BW)\tfzStd (BW)\tAvgCOPDisp (mm)\tAvgCOPyDisp (mm)\tAvgCOPxDisp (mm)\tAvgCOPLRDisp (mm)\tAvgCOPLRyDisp (mm)\tAvgCOPLRxDisp (mm)\tAvgCOPLRDispStd (mm)\tAvgCOPLRyDispStd (mm)\tAvgCOPLRxDispStd (mm)\tAvgCOPMStDisp (mm)\tAvgCOPMStyDisp (mm)\tAvgCOPMStxDisp (mm)\tAvgCOPMStDispStd (mm)\tAvgCOPMStyDispStd (mm)\tAvgCOPMStxDispStd (mm)\tAvgCOPTStDisp (mm)\tAvgCOPTStyDisp (mm)\tAvgCOPTStxDisp (mm)\tAvgCOPTStDispStd (mm)\tAvgCOPTStyDispStd (mm)\tAvgCOPTStxDispStd (mm)\tAvgCOPPSDisp (mm)\tAvgCOPPSyDisp (mm)\tAvgCOPPSxDisp (mm)\tAvgCOPPSDispStd (mm)\tAvgCOPPSyDispStd (mm)\tAvgCOPPSxDispStd (mm)\tLoadingRate (BW/Frame)\tSEDPhi\tEllArea (mm^2)\tFz1 (BW)\tFz2 (BW)\tFz3 (BW)\tFx1 (BW)\tFx2 (BW)\tFx3 (BW)\tTz1 (Stance)\tTz2 (Stance)\tTz3 (Stance)\tTx1 (Stance)\tTx2 (Stance)\tTx3 (Stance)\tParticipantVelocity (mm/Frame)\tcxAvg (mm)\tcxStd (mm)\tcyAvg (mm)\tcyStd (mm)\tCOPTVelocity (mm/Frame)\tCOPXVelocity (mm/Frame)\tCOPYVelocity (mm/Frame)\tWeight (kg)\n");

count = 0;

% Find all csv files
nFigures=0;

% Select files to be analyzed based on folder name and file name
files = dir('./**/**/*.csv');

[nFiles, ~] = size(files);
for f = 1:nFiles
    file=files(f);
    fn=file.name;
    if fn(1)~='~' && fn~="ParticipantInfo.csv"
        % Unsupress the following to display filenames
        fileName=strcat(file.folder, '\', file.name);
        
        %fprintf("%s\t", fileName);

        % Read the csv file that contains the raw signal
        data = csvread(fileName,5,0);

        % Filter before any calculations
        filteredData = filterForceplateData(data);
        %filteredData = data;
        
        % Get participant's idx
        tokens = split(extractAfter(extractAfter(file.folder, pwd), 2), {' ' , '_'});
        pIdx = str2num(tokens{1}) + 1;
             
        
        % Get participant's weight
        pWeightKg = participantInfo(pIdx, partWeightCol);
        pWeight = 9.81*pWeightKg;
        
        % Get participant's status
        pStatus = participantInfo(pIdx, partStatusCol);
        
        %fprintf("%g\n", pWeight);
        
        %continue;
        
        % Normalize force date: divide by weight in Newtons
        normalizedData = normalizeForceplateData(filteredData, pWeight, [Fx2, Fy2, Fz2, Fx3, Fy3, Fz3]);
        

        % Perform calculations

        % Spit data into steps
        stepData = splitSteps(normalizedData, [Fz3 Fz2]);

        % Calculate variables per step
        [~, nSteps] = size(stepData);
        for i = 1:nSteps             
            %Averages & stdevs
            [stepData(i).fyAvg, stepData(i).fyStd] = meanStd(stepData(i).data, stepData(i).fZcol-1);
            [stepData(i).fxAvg, stepData(i).fxStd] = meanStd(stepData(i).data, stepData(i).fZcol-2);
            [stepData(i).fzAvg, stepData(i).fzStd] = meanStd(stepData(i).data, stepData(i).fZcol);
            
            [stepData(i).cyAvg, stepData(i).cyStd] = meanStd(stepData(i).data, stepData(i).fZcol+5);
            [stepData(i).cxAvg, stepData(i).cxStd] = meanStd(stepData(i).data, stepData(i).fZcol+4);

            %2d Displacement
            [stepData(i).COPDisp, ~] = displacement2d(stepData(i).data, stepData(i).fZcol+4, stepData(i).fZcol+5);

            %1d Displacement
            [stepData(i).COPyDisp, ~] = displacement1d(stepData(i).data, stepData(i).fZcol+5);
            [stepData(i).COPxDisp, ~] = displacement1d(stepData(i).data, stepData(i).fZcol+4);
            
            %Velocities
            [stepData(i).COPVelocity, stepData(i).COPXVelocity, stepData(i).COPYVelocity] = velocities(stepData(i).data, stepData(i).fZcol+4, stepData(i).fZcol+5);

            %Peak analysis
            [stepData(i).lr, stepData(i).tz1, stepData(i).tz2, stepData(i).tz3] = peakAnalysis(stepData(i).data, stepData(i).fZcol);
            
            [stepData(i).data, stepData(i).tx1, stepData(i).tx2, stepData(i).tx3] = peakXAnalysis(stepData(i).data, stepData(i).fZcol-2);

            %Gait COP analysis
            %LR COP
            [stepData(i).COPLRyDisp, stepData(i).COPLRyDispStd] = displacement1d(stepData(i).data(1:stepData(i).tz1, :), stepData(i).fZcol+5);
            [stepData(i).COPLRxDisp, stepData(i).COPLRxDispStd] = displacement1d(stepData(i).data(1:stepData(i).tz1, :), stepData(i).fZcol+4);
            [stepData(i).COPLRVel, stepData(i).COPLRVelStd] = displacement2d(stepData(i).data(1:stepData(i).tz1, :), stepData(i).fZcol+4, stepData(i).fZcol+5);
            
            %MSt COP
            [stepData(i).COPMStyDisp, stepData(i).COPMStyDispStd] = displacement1d(stepData(i).data(stepData(i).tz1:stepData(i).tz2, :), stepData(i).fZcol+5);
            [stepData(i).COPMStxDisp, stepData(i).COPMStxDispStd] = displacement1d(stepData(i).data(stepData(i).tz1:stepData(i).tz2, :), stepData(i).fZcol+4);
            [stepData(i).COPMStVel, stepData(i).COPMStVelStd] = displacement2d(stepData(i).data(stepData(i).tz1:stepData(i).tz2, :), stepData(i).fZcol+4, stepData(i).fZcol+5);
            
            %TSt COP
            [stepData(i).COPTStyDisp, stepData(i).COPTStyDispStd] = displacement1d(stepData(i).data(stepData(i).tz2:stepData(i).tz3, :), stepData(i).fZcol+5);
            [stepData(i).COPTStxDisp, stepData(i).COPTStxDispStd] = displacement1d(stepData(i).data(stepData(i).tz2:stepData(i).tz3, :), stepData(i).fZcol+4);
            [stepData(i).COPTStVel, stepData(i).COPTStVelStd] = displacement2d(stepData(i).data(stepData(i).tz2:stepData(i).tz3, :), stepData(i).fZcol+4, stepData(i).fZcol+5);

            %PS COP
            [stepData(i).COPPSyDisp, stepData(i).COPPSyDispStd] = displacement1d(stepData(i).data(stepData(i).tz3:end, :), stepData(i).fZcol+5);
            [stepData(i).COPPSxDisp, stepData(i).COPPSxDispStd] = displacement1d(stepData(i).data(stepData(i).tz3:end, :), stepData(i).fZcol+4);
            [stepData(i).COPPSVel, stepData(i).COPPSVelStd] = displacement2d(stepData(i).data(stepData(i).tz3:end, :), stepData(i).fZcol+4, stepData(i).fZcol+5);
            
            %COP DPhi Sample Entropy
            stepData(i).dPhiSE = dphiSampEnt(stepData(i).data, stepData(i).fZcol+4, stepData(i).fZcol+5);

            %COP Ellipse Area
            stepData(i).ellArea = ellipseArea(stepData(i).data, stepData(i).fZcol+4, stepData(i).fZcol+5);
            
            %Estimate speed for SUCCESSIVE steps
            stepData(i).velocity = -1;
            if i > 1
               % This and previous steps must be on DIFFERENT plates
               if stepData(i).fZcol ~= stepData(i-1).fZcol
                   % This and previous step must be on the SAME direction
                   if stepData(i).fxAvg*stepData(i-1).fxAvg > 0
                       %Calculate spatial coordinates
                       x0 = stepData(i-1).cxAvg;
                       x1 = stepData(i).cxAvg;
                       
                       y0 = stepData(i-1).cyAvg;
                       y1 = stepData(i).cyAvg;
                       
                       distance = sqrt((x1-x0)^2 + (y1-y0)^2);
                       
                       %Calculate temporal coordinates
                       t0 = stepData(i-1).firstLine + stepData(i-1).stepDuration/2;
                       t1 = stepData(i).firstLine + stepData(i).stepDuration/2;
                       dt = t1-t0;
                       
                       %Speed!
                       v = distance/dt;
                       stepData(i-1).velocity = v;
                       stepData(i).velocity = v;
                   end
               end
            end
            
            % Dislay graphs ONLY for short steps
            if DISPLAY_FIGURES && stepData(i).stepDuration < figureLengthLimit
                %Plot Fz (uncomment to see them)
                plotTitle=sprintf('%s: Col %d @ ln. %d (tz1=%g)', fn, stepData(i).fZcol, stepData(i).firstLine, stepData(i).tz1);
                nFigures = nFigures + 1;
                figure(nFigures)
                %clear title xlabel ylabel

                % Weight (Fz) line
                plot(linspace(0, 1, stepData(i).stepDuration), -stepData(i).data(:, stepData(i).fZcol))

                % Add loading rate line
                line([0 stepData(i).tz1/stepData(i).stepDuration], [-stepData(i).data(1, stepData(i).fZcol) stepData(i).lr*stepData(i).tz1], 'LineStyle', '--', 'Color','red' ) 

                % Find axes data
                fig = gcf;
                xlim = fig.CurrentAxes.XLim;
                ylim = fig.CurrentAxes.YLim;
                
                % Fz1/Tz1 Line
                x1 = stepData(i).tz1/stepData(i).stepDuration;
                x2 = stepData(i).tz1/stepData(i).stepDuration;
                y1 = 0;
                y2 = -stepData(i).data(stepData(i).tz1, stepData(i).fZcol);
                line([x1 x2], [y1 y2], 'LineStyle', ':', 'Color','black', 'Marker', '*');
                if DISPLAY_ANNOTATIONS
                    [x1N y1N] = normalizeGraphCoordinates([x1, y1], xlim, ylim);
                    [x2N y2N] = normalizeGraphCoordinates([x2, y2], xlim, ylim);
                    annotation('textbox',[x1N y1N 0.1 0.2],'String','Tz1','FitBoxToText','on');
                    annotation('textbox',[x2N y2N 0.1 0.2],'String','Fz1','FitBoxToText','on');
                end
                
                % Fz2/Tz2 Line
                x1 = stepData(i).tz2/stepData(i).stepDuration;
                x2 = stepData(i).tz2/stepData(i).stepDuration;
                y1 = 0;
                y2 = -stepData(i).data(stepData(i).tz2, stepData(i).fZcol);
                line([x1 x2], [y1 y2], 'LineStyle', ':', 'Color','black', 'Marker', '*');
                if DISPLAY_ANNOTATIONS
                    [x1N y1N] = normalizeGraphCoordinates([x1, y1], xlim, ylim);
                    [x2N y2N] = normalizeGraphCoordinates([x2, y2], xlim, ylim);
                    annotation('textbox',[x1N y1N 0.1 0.2],'String','Tz2','FitBoxToText','on');
                    annotation('textbox',[x2N y2N 0.1 0.2],'String','Fz2','FitBoxToText','on');
                end

                % Fz3/Tz3 Line
                x1 = stepData(i).tz3/stepData(i).stepDuration;
                x2 = stepData(i).tz3/stepData(i).stepDuration;
                y1 = 0;
                y2 = -stepData(i).data(stepData(i).tz3, stepData(i).fZcol);
                line([x1 x2], [y1 y2], 'LineStyle', ':', 'Color','black', 'Marker', '*');
                if DISPLAY_ANNOTATIONS
                    [x1N y1N] = normalizeGraphCoordinates([x1, y1], xlim, ylim);
                    [x2N y2N] = normalizeGraphCoordinates([x2, y2], xlim, ylim);
                    annotation('textbox',[x1N y1N 0.1 0.2],'String','Tz3','FitBoxToText','on');
                    annotation('textbox',[x2N y2N 0.1 0.2],'String','Fz3','FitBoxToText','on');
                end

                xlabel(strcat('% Stance Time (', num2str(stepData(i).stepDuration/SAMPLING_RATE),'s)'));
                ylabel('Vertical GRF (% Body Weight)');

                % COP Scatter plot
                %scatter(stepData(i).data(:, stepData(i).fZcol+4), stepData(i).data(:, stepD)ata(i.fZcol+5))

                title(plotTitle)


                %Plot Fx (uncomment to see them)
                plotTitle=sprintf('Fx: %s: Col %d @ ln. %d', fn, stepData(i).fZcol-2, stepData(i).firstLine);
                nFigures = nFigures + 1;
                figure(nFigures)
                %clear title xlabel ylabel

                % (Fx) line
                plot(linspace(0, 1, stepData(i).stepDuration), stepData(i).data(:, stepData(i).fZcol-2))

                line([0 1], [0 0], 'LineStyle', '--');
                
                % Find axes data
                fig = gcf;
                xlim = fig.CurrentAxes.XLim;
                ylim = fig.CurrentAxes.YLim;
                
                % Tx1/Fx1 Line
                x1 = stepData(i).tx1/stepData(i).stepDuration;
                x2 = stepData(i).tx1/stepData(i).stepDuration;
                y1 = 0;
                y2 = stepData(i).data(stepData(i).tx1, stepData(i).fZcol-2);
                line([x1 x2], [y1 y2], 'LineStyle', ':', 'Color','black', 'Marker', '*');
                if DISPLAY_ANNOTATIONS
                    [x1N y1N] = normalizeGraphCoordinates([x1, y1], xlim, ylim);
                    [x2N y2N] = normalizeGraphCoordinates([x2, y2], xlim, ylim);
                    annotation('textbox',[x1N y1N 0.1 0.2],'String','Tx1','FitBoxToText','on');
                    annotation('textbox',[x2N y2N 0.1 0.2],'String','Fx1','FitBoxToText','on');
                end

                % Tx2/Fx2 Line
                x1 = stepData(i).tx2/stepData(i).stepDuration;
                x2 = stepData(i).tx2/stepData(i).stepDuration;
                y1 = 0;
                y2 = stepData(i).data(stepData(i).tx2, stepData(i).fZcol-2);
                line([x1 x2], [y1 y2], 'LineStyle', ':', 'Color','black', 'Marker', '*');
                if DISPLAY_ANNOTATIONS
                    [x1N y1N] = normalizeGraphCoordinates([x1, y1], xlim, ylim);
                    [x2N y2N] = normalizeGraphCoordinates([x2, y2], xlim, ylim);
                    annotation('textbox',[x1N y1N 0.1 0.2],'String','Tx2, Fx2','FitBoxToText','on');
                end

                % Tx3/Fx3 Line
                x1 = stepData(i).tx3/stepData(i).stepDuration;
                x2 = stepData(i).tx3/stepData(i).stepDuration;
                y1 = 0;
                y2 = stepData(i).data(stepData(i).tx3, stepData(i).fZcol-2);
                line([x1 x2], [y1 y2], 'LineStyle', ':', 'Color','black', 'Marker', '*');
                if DISPLAY_ANNOTATIONS
                    [x1N y1N] = normalizeGraphCoordinates([x1, y1], xlim, ylim);
                    [x2N y2N] = normalizeGraphCoordinates([x2, y2], xlim, ylim);
                    annotation('textbox',[x1N y1N 0.1 0.2],'String','Tx3','FitBoxToText','on');
                    annotation('textbox',[x2N y2N 0.1 0.2],'String','Fx3','FitBoxToText','on');
                end

                xlabel(strcat('% Stance Time (', num2str(stepData(i).stepDuration/SAMPLING_RATE),'s)'));
                ylabel('Anterior-Posterior GRF (% Body Weight)');

                title(plotTitle)
            end
        end

        % Display step data
        for step = stepData
            fprintf("%s\t%d\t%d\t%d\t%d\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\n", fileName, pStatus, ...
                step.fZcol, step.firstLine, step.stepDuration,...
                step.fyAvg, step.fxAvg, step.fzAvg,...
                step.fyStd, step.fxStd, step.fzStd,...
                step.COPDisp, step.COPyDisp, step.COPxDisp,...
                step.COPLRVel, step.COPLRyDisp, step.COPLRxDisp,step.COPLRVelStd, step.COPLRyDispStd, step.COPLRxDispStd,...
                step.COPMStVel, step.COPMStyDisp, step.COPMStxDisp,step.COPMStVelStd, step.COPMStyDispStd, step.COPMStxDispStd,...
                step.COPTStVel, step.COPTStyDisp, step.COPTStxDisp,step.COPTStVelStd, step.COPTStyDispStd, step.COPTStxDispStd,...
                step.COPPSVel, step.COPPSyDisp, step.COPPSxDisp,step.COPPSVelStd, step.COPPSyDispStd, step.COPPSxDispStd,...
                step.lr, step.dPhiSE, step.ellArea,...
                -step.data(step.tz1, step.fZcol), -step.data(step.tz2, step.fZcol), -step.data(step.tz3, step.fZcol), ...
                step.data(step.tx1, step.fZcol-2), step.data(step.tx2, step.fZcol-2), step.data(step.tx3, step.fZcol-2), ...
                step.tz1/step.stepDuration, step.tz2/step.stepDuration, step.tz3/step.stepDuration, ...
                step.tx1/step.stepDuration, step.tx2/step.stepDuration, step.tx3/step.stepDuration, ...
                step.velocity, ...
                step.cxAvg, step.cxStd, step.cyAvg, step.cyStd, ...
                step.COPVelocity, step.COPXVelocity, step.COPYVelocity, ...
                pWeightKg);
        end
        
        %count = count + 1;       
        %if count > 20
        %    return;
        %end
    end
end



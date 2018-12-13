# A Biomechanical Variables Calculator in Matlab

This project is a collection of Matlab scripts that scan a target directory for CSV files containing biomechanical data. Each line of the CSV file is expected to contain the following information (the exact column can be specified in the script):
* Two three-dimensional force vectors
* Two two-dimensional location points

Each file is configurably joined by a numeric ID with an accompanying information file that contains general information, such as one's weight and history of fall.

The data is analyzed on a per-step way. For each step, various variables are calculated and printed on a single line of the output. Additionally, graphs can be optionally plotted, which can be used, for instance, to visually verify step-correctness.

The following metrics are reported:
* File Path
* History of fall
* FZCol
* FirstLine
* stepDuration
* fyAvg (BW)
* fxAvg (BW)
* fzAvg (BW)
* fyStd (BW)
* fxStd (BW)
* fzStd (BW)
* AvgCOPDisp (mm)
* AvgCOPyDisp (mm)
* AvgCOPxDisp (mm)
* AvgCOPLRDisp (mm)
* AvgCOPLRyDisp (mm)
* AvgCOPLRxDisp (mm)
* AvgCOPLRDispStd (mm)
* AvgCOPLRyDispStd (mm)
* AvgCOPLRxDispStd (mm)
* AvgCOPMStDisp (mm)
* AvgCOPMStyDisp (mm)
* AvgCOPMStxDisp (mm)
* AvgCOPMStDispStd (mm)
* AvgCOPMStyDispStd (mm)
* AvgCOPMStxDispStd (mm)
* AvgCOPTStDisp (mm)
* AvgCOPTStyDisp (mm)
* AvgCOPTStxDisp (mm)
* AvgCOPTStDispStd (mm)
* AvgCOPTStyDispStd (mm)
* AvgCOPTStxDispStd (mm)
* AvgCOPPSDisp (mm)
* AvgCOPPSyDisp (mm)
* AvgCOPPSxDisp (mm)
* AvgCOPPSDispStd (mm)
* AvgCOPPSyDispStd (mm)
* AvgCOPPSxDispStd (mm)
* LoadingRate (BW/Frame)
* SEDPhi
* EllArea (mm^2)
* Fz1 (BW)
* Fz2 (BW)
* Fz3 (BW)
* Fx1 (BW)
* Fx2 (BW)
* Fx3 (BW)
* Tz1 (Stance)
* Tz2 (Stance)
* Tz3 (Stance)
* Tx1 (Stance)
* Tx2 (Stance)
* Tx3 (Stance)
* ParticipantVelocity (mm/Frame)
* cxAvg (mm)
* cxStd (mm)
* cyAvg (mm)
* cyStd (mm)
* COPTVelocity (mm/Frame)
* COPXVelocity (mm/Frame)
* COPYVelocity (mm/Frame)
* Weight (kg)

Each file implements the calculation of a different group of related metrics. Additionally, a few files contain testing and validation code.

## Usage
After installing Matlab, open the ForcePlateAnalysisScript.m file. Configure its various settings, including the path of the CSV files to be analyzed, and run it.

## TODO:
* Include reference of related paper when published

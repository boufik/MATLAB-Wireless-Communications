clear all
close all
clc
 
% 1. Simulation parameters
numBits = 20000
modOrder = 16  
srcBits = randi([0, 1], numBits, 1);

% 2. QAM Modulation ---> 5 symbols with 4 bits and unit average power (for SNR)
modOut = qammod(srcBits, modOrder, "InputType", "bit", "UnitAveragePower", true);

% 3. AWGN Channel (20 dB for an ideal channel)
SNR = 15;	% dB
chanOut = awgn(modOut,SNR);

% 4. Scatter plot to see the 5000 received symbols
scatterplot(chanOut)

% 5. QAM Demodulation ---> 20000 bits
demodOut = qamdemod(chanOut,modOrder,"OutputType","bit","UnitAveragePower",true);
check = isequal(srcBits,demodOut)

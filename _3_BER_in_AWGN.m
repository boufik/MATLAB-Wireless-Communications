% 1. Simulation parameters 
numBits = 20000;
modOrder = 16;
% Create source signal and apply 16-QAM modulation
srcBits = randi([0, 1], numBits, 1);
modOut = qammod(srcBits, modOrder, "InputType", "bit", "UnitAveragePower", true);

% 2. Apply AWGN
SNR = 15;
chanOut = awgn(modOut, SNR);
scatterplot(chanOut)
demodOut = qamdemod(chanOut, modOrder, "OutputType", "bit", "UnitAveragePower", true);

% 3. Calculate BER
isBitError = srcBits ~= demodOut;
numBitErrors = nnz(isBitError)
BER = numBitErrors / numBits

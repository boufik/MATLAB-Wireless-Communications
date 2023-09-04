clear all
close all
clc

% 1. Simulation parameters 
numBits = 20000;
modOrder = 16;
srcBits = randi([0, 1], numBits, 1);
modOut = qammod(srcBits, modOrder, "InputType", "bit", "UnitAveragePower", true);

% 2. Create the filters from Communications Toolbox ('comm' variable)
txFilt = comm.RaisedCosineTransmitFilter
rxFilt = comm.RaisedCosineReceiveFilter

% 3. Apply the filter to the 16-QAM modulated signal
txFiltOut = txFilt(modOut)

% 4. AWGN Channel - "measured" calculates the input signal's power and scales the noise power based on the SNR
SNR_dB = 7;
chanOut = awgn(txFiltOut, SNR_dB, "measured");

% 5. Receiver filter
rxFiltOut = rxFilt(chanOut);

% 6. Back into bits
scatterplot(rxFiltOut)
title("Receive Filter Output")
demodOut = qamdemod(rxFiltOut,modOrder,"OutputType","bit","UnitAveragePower",true);

specAn = dsp.SpectrumAnalyzer("NumInputPorts", 2, "SpectralAverages", 50, "ShowLegend", true);
specAn(txFiltOut,chanOut);

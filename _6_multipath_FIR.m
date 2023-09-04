clear all
close all
clc

% 1. Simulation parameters
numBits = 20000;
modOrder = 16;  % for 16-QAM
bitsPerSymbol = log2(modOrder);  % modOrder = 2^bitsPerSymbol
txFilt = comm.RaisedCosineTransmitFilter;
rxFilt = comm.RaisedCosineReceiveFilter;

srcBits = randi([0,1],numBits,1);
modOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
txFiltOut = txFilt(modOut);


% 2. Multipath Channel - Finite Impulse Response Filter
mpChan = zeros(17, 1);
mpChan(1) = 0.8;
mpChan(9) = -0.5;
mpChan(17) = 0.34;
stem(mpChan);


% 3. Apply the FIR filter simulating the multipath channel
mpChanOut = filter(mpChan, 1, txFiltOut)


% 4. Continue the process
SNR = 15;  % dB
chanOut = awgn(mpChanOut, SNR, "measured");
rxFiltOut = rxFilt(chanOut);
    
scatterplot(rxFiltOut)
title("Receive Filter Output")
demodOut = qamdemod(rxFiltOut,modOrder,"OutputType","bit","UnitAveragePower",true);
    
% Calculate the BER
delayInSymbols = txFilt.FilterSpanInSymbols/2 + rxFilt.FilterSpanInSymbols/2;
delayInBits = delayInSymbols * bitsPerSymbol;
srcAligned = srcBits(1:(end-delayInBits));
demodAligned = demodOut((delayInBits+1):end);

numBitErrors = nnz(srcAligned~=demodAligned)
BER = numBitErrors/length(srcAligned)


% 5. Spectral Analysis
specAn = dsp.SpectrumAnalyzer("NumInputPorts",2, "SpectralAverages",50,"ShowLegend",true);
specAn(txFiltOut,chanOut)

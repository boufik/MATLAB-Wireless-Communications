clear all
close all
clc

% 1. Basics
numBits = 20000;
modOrder = 16;  % for 16-QAM
bitsPerSymbol = log2(modOrder);
txFilt = comm.RaisedCosineTransmitFilter;
rxFilt = comm.RaisedCosineReceiveFilter;

srcBits = randi([0,1],numBits,1);
modOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
txFiltOut = txFilt(modOut);

SNR = 7;  % dB
chanOut = awgn(txFiltOut,SNR,"measured");

rxFiltOut = rxFilt(chanOut);
demodOut = qamdemod(rxFiltOut,modOrder,"OutputType","bit","UnitAveragePower",true);


% 2. Filter Delay
delayInSymbols = txFilt.FilterSpanInSymbols/2 + rxFilt.FilterSpanInSymbols/2
delayInBits = delayInSymbols * bitsPerSymbol


% 3. Aligned bits
srcAligned = srcBits(1 : (end - delayInBits));
demodAligned = demodOut((delayInBits + 1) : end);


% 4. BER
numBitErrors = nnz(srcAligned ~= demodAligned)
numAlignedBits = length(srcAligned)
BER = numBitErrors / numAlignedBits

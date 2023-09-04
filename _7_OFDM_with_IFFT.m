clear all
close all
clc

% 1. SImulation parameters
numBits = 32768;  % power of 2, to optimize performance of fft/ifft
modOrder = 16;    % for 16-QAM
srcBits = randi([0,1],numBits,1);
qamModOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
scatterplot(qamModOut)
title("16-QAM Signal")

% 2. No filter now - OFDM implementation - IFFT is executed after 16-QAM modulation (instead of filtering)
ofdmModOut = ifft(qamModOut)

% 3. AWGN channel
SNR = 15;
chanOut = awgn(ofdmModOut,SNR,"measured");

% 4. No filtering again - FFT is executed to decode the signal from the multiple sub-carriers
ofdmDemodOut = fft(chanOut)
scatterplot(ofdmDemodOut)

% 5. 16-QAM Demodulation and BER calculation
qamDemodOut = qamdemod(ofdmDemodOut,modOrder,"OutputType","bit","UnitAveragePower",true);
numBitErrors = nnz(srcBits~=qamDemodOut)
BER = numBitErrors/numBits

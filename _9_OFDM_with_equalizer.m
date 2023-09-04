clear all
close all
clc


% 1. Simulation parameters

modOrder = 16;  % for 16-QAM
bitsPerSymbol = log2(modOrder);
mpChan = [0.8; zeros(7,1); -0.5; zeros(7,1); 0.34];  % multipath channel
SNR = 15;

% 2. Select number of bits - Each carrier holds a symbol and each symbol holds 4 bits

numCarr = 8192;
numBits = numCarr * bitsPerSymbol;


% 3. QAM Modulation
srcBits = randi([0,1],numBits,1);
qamModOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);


% 4. Select cyclic prefix length, so that it is at least equal to the FIR filter length, but as low as possible, because it will
% contain data that will be discarded later. Cyclic prefix is needed to convert the signal into a periodic one. If a signal is 
% periodic, then linear and cyclic convolution are identical. Convolution "lies" at the receiver's edge, at equalizer.

cycPrefLen = 32;


% 5. OFDM Modulation
ofdmModOut = ofdmmod(qamModOut, numCarr, cycPrefLen);


% 6. Channel
pChanOut = filter(mpChan,1,ofdmModOut);
chanOut = awgn(mpChanOut,SNR,"measured");


% 7. OFDM Demodulation
ofdmDemodOut = ofdmdemod(chanOut, numCarr, cycPrefLen);
scatterplot(ofdmDemodOut);


% 8. Equalizer
mpChanFreq = fftshift(fft(mpChan,numCarr));
eqOut = ofdmDemodOut ./ mpChanFreq;
scatterplot(eqOut);


% 9. QAM Demodulation
qamDemodOut = qamdemod(eqOut,modOrder,"OutputType","bit","UnitAveragePower",true);
numBitErrors = nnz(srcBits~=qamDemodOut)
BER = numBitErrors/numBits

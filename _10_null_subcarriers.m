clear all
close all
clc


% 1. Simulation parameters

modOrder = 16;  % for 16-QAM
bitsPerSymbol = log2(modOrder)  % modOrder = 2^bitsPerSymbol
mpChan = [0.8; zeros(7,1); -0.5; zeros(7,1); 0.34];  % multipath channel
SNR = 15   % dB, signal-to-noise ratio of AWGN
numCarr = 8192;  % number of subcarriers
cycPrefLen = 32;  % cyclic prefix length


% 2. Define the indeces of guard bands (left and right)

numGBCarr = numCarr / 16;
gbLeft = 1 : numGBCarr;
gbRight = (numCarr - numGBCarr + 1) : numCarr;


% 3. Add the DC component index

dcIdx = numCarr / 2 + 1;        % Center of vector
nullIdx = [gbLeft dcIdx gbRight]';


% 4. Calculate the number of source bits that will be sent

numDataCarr = numCarr - length(nullIdx);
numBits = numDataCarr * bitsPerSymbol;


% 5. QAM Modulation

srcBits = randi([0,1],numBits,1);
qamModOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);


% 6. OFDM Modulation

ofdmModOut = ofdmmod(qamModOut, numCarr, cycPrefLen, nullIdx);


% 7. Channel

mpChanOut = filter(mpChan,1,ofdmModOut);
chanOut = awgn(mpChanOut,SNR,"measured");


% 8. OFDM Demodulation

symbolSamplingOffset = cycPrefLen;
ofdmDemodOut = ofdmdemod(chanOut, numCarr, cycPrefLen, symbolSamplingOffset, nullIdx);


% 9. The channel frequency response has numCarr frequency components. However, the OFDM demodulator output contains only the data
% subcarriers. To perform the elementwise division, you need to remove the null subcarrier frequency components from the channel
% frequency response.

mpChanFreq = fftshift(fft(mpChan, numCarr));
mpChanFreq(nullIdx) = [];


% 10. Equalizer

eqOut = ofdmDemodOut ./ mpChanFreq;
scatterplot(eqOut);


% 11. QAM Demodulation

qamDemodOut = qamdemod(eqOut,modOrder,"OutputType","bit","UnitAveragePower",true);
numBitErrors = nnz(srcBits~=qamDemodOut)
BER = numBitErrors/numBits

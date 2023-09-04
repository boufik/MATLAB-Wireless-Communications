clear all
close all
clc

% 1. Modulation and IFFT

numBits = 32768;  % power of 2, to optimize performance of fft/ifft
modOrder = 16;  % for 16-QAM
srcBits = randi([0,1],numBits,1);
qamModOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
ofdmModOut = ifft(qamModOut);


% 2. Channel

hasMultipath = true;
hasAWGN = true;
SNR = 15;
chanOut = channel(ofdmModOut,hasMultipath,hasAWGN,SNR);


% 3. FFT and Demodulation

ofdmDemodOut = fft(chanOut);
scatterplot(ofdmDemodOut)
title("OFDM Demodulator Output")
qamDemodOut = qamdemod(ofdmDemodOut,modOrder,"OutputType","bit","UnitAveragePower",true);
numBitErrors = nnz(srcBits~=qamDemodOut)
BER = numBitErrors/numBits



function chanOut = channel(sig,hasMP,hasAWGN,SNR)
    % Apply multipath channel if selected
    if hasMP
        mpChan = [0.8; zeros(7,1); -0.5; zeros(7,1); 0.34]; 
        mpChanOut = filter(mpChan,1,sig);
    else
        mpChanOut = sig;
    end
    % Apply AWGN if selected
    if hasAWGN
        chanOut = awgn(mpChanOut,SNR,"measured");
    else
        chanOut = mpChanOut;
    end
end

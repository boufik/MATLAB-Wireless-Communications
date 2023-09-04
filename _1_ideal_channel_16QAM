clear all
close all
clc

% 1. 20.000 bits in transmitter
srcBits = randi([0, 1], 20000, 1);

% 2. 4 bits per symbol (16 QAM)
modOrder = 16;

% 3. QAM Modulation ---> 5000 symbols with 4 bits
modOut = qammod(srcBits, modOrder, "InputType", "bit")

% 4. Plot the constellation
scatterplot(modOut)

% 5. Ideal Channel
chanOut = modOut;

% 6. QAM Demodulation ---> 20.000 bits output
demodOut = qamdemod(chanOut, modOrder, "OutputType", "bit");
size(demodOut)

% 7. Check if the received bits are identical to the transmitted ones
check = isequal(srcBits, demodOut)

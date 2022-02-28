clc
clear all
close all

% Start custom code
retVal = readDCA1000('C:\Users\Bishal\RadarProject\Data\RadarData\drone_gps_1.bin');

R_1 = retVal(1, :);
R_2 = retVal(2, :);
R_3 = retVal(3, :);
R_4 = retVal(4, :);

frames = 100;
m_samples = 256;
s = size(R_1, 2)/frames;
m_chirps = s/m_samples;

Receiver_1=reshape(R_1,s,frames);
Receiver_2=reshape(R_2,s,frames);
Receiver_3=reshape(R_3,s,frames);
Receiver_4=reshape(R_4,s,frames);

B = reshape(Receiver_4, frames, m_samples, m_chirps);
% for j=1:frames
%     range_main = 20*log10(abs(fft(B(j,:,:))));
%     %a = pulsint(range_main(j, :, :));
%     a = sum(range_main, 2);
%     plot(a)
%     figure(1)
% plot((1:size(a))*0.0976,a)
% xlabel('range in m');
% ylabel ('received power')
% end

for f=1:frames
    range_main(f,:,:) = 20*log10(abs(fft(B(f,:,:))));
    range = pulsint(reshape(range_main(f,:,:), m_samples, m_chirps));
    plot((1:m_samples)*0.0976,range);
end


function [retVal] = readDCA1000(fileName)
%% global variables
% change based on sensor config
numADCSamples = 256; % number of ADC samples per chirp
numADCBits = 16; % number of ADC bits per sample
numRX = 4; % number of receivers
numLanes = 2; % do not change. number of lanes is always 2
isReal = 0; % set to 1 if real only data, 0 if complex data0
%% read file
% read .bin file
fid = fopen(fileName,'r');
adcData = fread(fid, 'int16');
% if 12 or 14 bits ADC per sample compensate for sign extension
if numADCBits ~= 16
l_max = 2^(numADCBits-1)-1;
adcData(adcData > l_max) = adcData(adcData > l_max) - 2^numADCBits;
end
fclose(fid);
fileSize = size(adcData, 1);
% real data reshape, filesize = numADCSamples*numChirps
if isReal
numChirps = fileSize/numADCSamples/numRX;
LVDS = zeros(1, fileSize);
%create column for each chirp
LVDS = reshape(adcData, numADCSamples*numRX, numChirps);
%each row is data from one chirp
LVDS = LVDS.';
else
% for complex data
% filesize = 2 * numADCSamples*numChirps
numChirps = fileSize/2/numADCSamples/numRX;
LVDS = zeros(1, fileSize/2);
%combine real and imaginary part into complex data
%read in file: 2I is followed by 2Q
counter = 1;
for i=1:4:fileSize-1
LVDS(1,counter) = adcData(i) + sqrt(-1)*adcData(i+2); LVDS(1,counter+1) = adcData(i+1)+sqrt(-1)*adcData(i+3);
counter = counter + 2;
end
% create column for each chirp
LVDS = reshape(LVDS, numADCSamples*numRX, numChirps);
%each row is data from one chirp
LVDS = LVDS.';
end
%organize data per RX
adcData = zeros(numRX,numChirps*numADCSamples);
for row = 1:numRX
 for i = 1: numChirps
    adcData(row, (i-1)*numADCSamples+1:i*numADCSamples) = LVDS(i, (row-1)*numADCSamples+1:row*numADCSamples);
 end
end
% return receiver data
retVal = adcData;
end

%single target detection code
clc
clear all
close all
%retVal = readDCA1000('C:\ti\mmwave_studio_02_01_01_00\mmWaveStudio\PostProc\drone_gps_1.bin');
retVal = readDCA1000('C:\Users\Bishal\RadarProject\Data\RadarData\drone_gps_3.bin');
Receiver_1= retVal(1,:);
Receiver_2= retVal(2,:);
Receiver_3= retVal(3,:);
Receiver_4= retVal(4,:);

frames=100;
s=size(Receiver_2,2)/frames;
m_chirps=s/256;
Receiver_1=reshape(Receiver_1,s,frames);
Receiver_2=reshape(Receiver_2,s,frames);
Receiver_3=reshape(Receiver_3,s,frames);
Receiver_4=reshape(Receiver_4,s,frames);
for j=1:frames
      A=Receiver_4( :, j);
      B( :, :, j)=reshape(A,256,m_chirps);
      range_main=20*log10(abs(fft(B( :, :, j))));
      a=pulsint(range_main);
%       plot(a)
%       figure (1)
% plot((1:size(a))*0.0976,a)
% xlabel('range in m');
% ylabel ('received power')
doppler_main=20*log10(abs(fft2(B( :,:,j))));
  n= fftshift (doppler_main,2);
 m=pulsint(n);
  x_axis_img=(-64:63)* 0.1201;
  y_axis_img=(0:256)* 0.0976;
   figure(2)
imagesc(x_axis_img, y_axis_img,n)
xlabel('velocity in m/s');
ylabel ('range in m')
colorbar
hold off;
pause(0.2);
title(['FrameID:' num2str(j)])
end
 
%  figure (1)
% plot((1:size(a))*0.0976,a)
% xlabel('range in m');
% ylabel ('received power')
% hold on
% pause(0.5)
%  

% 
% title(['FrameID: ' num2str(j)])
% n(:,65) = 0; 
% maxval_col =  max(n,[],"all");
% maxval_row =max(n,[],"all");
% [rangeidx_col,doppleridx_col] = find(n == maxval_col);
% doppleridx_row(:,j)=(doppleridx_col-(64))*0.0937;
% rangeidx_row(:,j)=rangeidx_col *0.0878 ; 


% 
% All_receivers=[];
% All_receivers=reshape(retVal,[256,128,4,50])
%  %Doppler_matrix=mode(doppleridx_row, 'all')
% indices = find((doppleridx_row)>Doppler_matrix);
%doppleridx_row(indices) = [];
%rangeidx_row(indices) =[];
%indices1 = find((doppleridx_row)<Doppler_matrix);
%doppleridx_row(indices1) = [];
%rangeidx_row(indices1) =[];
%[~,dop_detect1] = findpeaks(m,'SortStr','descend','NPeaks',3 );
%dop_detect1(:,j)= dop_detect1*0.0878;

%RDM =10*log10(sum(abs(fft2(B( :, :, j))).^2,2)+1);

%testsample=sig_fft2(:,:,j)';

%H= phased.RangeDopplerResponse(...
 %   'RangeMethod','FFT',...
  %  'ReferenceRangeCentered',false,...
 %'DopplerOutput','Speed');
%[resp,rangrid,dopgrid]=step(H,B(:,:,j));
% Res=[];

% Res(:,:,j)=abs(resp);

%abs(fft2(B( :, :, j))abs(fft2(B( :, :, j))abs(fft2(B( :, :, j))abs(fft2(B( :, :, j))abs(fft2(B( :, :, j))abs(fft2(B( :, :, j))abs(fft2(B( :, :, j))
% imagesc(x_axis_img,y_axis_img, abs(resp))

%plotResponse(H,B(:,:,j));
%v_max=30;
%range_max=25;
%axis([-v_max v_max 0 rangrid ])
%caxis(clim)


%for i=1:99
 %   New=Res(:,:,i)-Res(:,:,i+1);
  %  imagesc(New)
%end
% m=max(Res(:,:,70),[],'all');
%rngangresp = phased.RangeAngleResponse(phased.RangeAngleResponse('RangeMethod','FFT'));
%[RESP,RANGE,ANG] = response(X)


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
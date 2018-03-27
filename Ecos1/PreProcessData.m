function channelData = PreProcessData(inputFileName)

%files=dir('13QAS0028_9_DVD_833_20130820_F_SW51.dat'); % or whatever wildcard makes best match to desired...

%for k = 1:length(files)
% inputFileName = files(k).name
[channelData,channelName] = LoadDumpData(inputFileName);

%     if k == 1
%        save AllChanNameSW channelName;
%     end
%% remove first and last points from the file
%     channelData([1:5 end-5:end],:)=[];

%% use time jump to filter data
idx=find(diff(channelData(:,1))>10);

i=1;
removeTimeIdx=[];
removeValueIdx =[];
filterTime = 300; % 2 min or 5 min
while (i<length(idx))
    
    %% filtering
    startTime = channelData(idx(i)+1,1);
    endTime = startTime + filterTime;
    
    if endTime >=channelData(idx(i+1),1)
        removeTimeIdx = [removeTimeIdx idx(i):idx(i+1)];
        i = i+1;
    else
        endIdx = find(channelData(:,1)>endTime, 1 );
        removeTimeIdx = [removeTimeIdx idx(i)+1:endIdx-1];
        i=i+1;
    end
end
removeTimeIdx=unique(removeTimeIdx);
channelData(removeTimeIdx, :)= [];

%% remove  -999.25 Channel value

for j = 2: size(channelData,2)
    removeValueIdx =[removeValueIdx; find(channelData(:,j)== -999.25)];
end
removeValueIdx = unique(removeValueIdx);
channelData(removeValueIdx,:) =[];


%% remove PNG Not Firing part for healthy class
%% Get PSSW information
%     PSSW_idx = find(strcmp(channelName,'PSSW')==1);
%     PSSW_channel = channelData(:,PSSW_idx);
%
%     SWbi = dec2bin(PSSW_channel,16);
%     SWbi = SWbi - '0';
%     SWbi = fliplr(SWbi);
%
%     PSSW_PNG_idx = find(SWbi(:,10)==1); % downlink received to stop PNG
%
%     channelData(PSSW_PNG_idx,:) =[];
%

% %% save filtered data
% inputFile = inputFileName(1:end-4);
% outputFileData = strcat(inputFile, '_Filter.mat');
% save(outputFileData,'channelData')





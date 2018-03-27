close all
clear all

currentFolder = uigetdir('*.csv','Select the DAT file to load');
FolderName = currentFolder;
DATFile = strcat(currentFolder, '\*.CSV');
%% find folder name

%currentFolder = pwd;

files=dir(DATFile); % or whatever wildcard makes best match to desired...

if length(files) > 1  % process the folder
    idx=strfind(currentFolder,'\');
    currentFolder(1:idx(end))=[];
    csvFileName = strcat(currentFolder,'_Result');
else % process one file
    csvFileName=strcat(files.name(1:end-4),'_Result');
end


%files=dir('14SCA0082_3_DVD_1801_20140329_H_SW52_ENV.DAT'); % or whatever wildcard makes best match to desired...

%load TechlogChannelNameAll.mat
load EnvChannel.mat



SHChannel={'SHKX'; 'SHKZ';'SHKR'};
VBChannel={'VBRX';'VBRL';'VBRR'};
TMPChannel ={'ATMP';'DTMP';'GXTP'};

tic
%% create cell array for storing all results to csv file
fields = cell(1, 81);
values = cell(length(files),81);
fields{1} = 'FILENAME';
fields{2} = 'JOBNAME';
fields{3} = 'TOOLSERIAL';
fields{4} = 'FWVERSION';
fields{5} = 'ACQSTARTTIME';
fields{6} = 'HIGHTEMPTIME';
fields{7} ='SHKL_MAX';
fields{8} ='SHKL_TIME_0';
fields{9} ='SHKL_TIME_1';
fields{10} ='SHKL_TIME_2';
fields{11} ='SHKL_TIME_3';
fields{12} ='SHKC_MAX';
fields{13} ='SHKC_CUMU';

for j= 1: length(SHChannel)
    idx = 13+(j-1)*7;
    fields{idx+1} =[SHChannel{j} '_MAX'];
    fields{idx+2} =[SHChannel{j} '_CUMU'];
    fields{idx+3} =[SHChannel{j} '_TIME_0G'];
    fields{idx+4} =[SHChannel{j} '_TIME_25G'];
    fields{idx+5} =[SHChannel{j} '_TIME_50G'];
    fields{idx+6} =[SHChannel{j} '_TIME_100G'];
    fields{idx+7} =[SHChannel{j} '_TIME_200G'];
    
end

for j= 1: length(VBChannel)
    idx = 34+ (j-1)* 6;
    fields{idx+1} =[VBChannel{j} '_MAX'];
    fields{idx+2} =[VBChannel{j} '_CUMU'];
    fields{idx+3} =[VBChannel{j} '_TIME_0G'];
    fields{idx+4} =[VBChannel{j} '_TIME_1G'];
    fields{idx+5} =[VBChannel{j} '_TIME_3G'];
    fields{idx+6} =[VBChannel{j} '_TIME_6G'];
    
end


for j= 1: length(TMPChannel)
    idx = 52+(j-1)*9;
    fields{idx+1} =[TMPChannel{j} '_MAX'];
    fields{idx+2} =[TMPChannel{j} '_TIME_0C'];
    fields{idx+3} =[TMPChannel{j} '_TIME_60C'];
    fields{idx+4} =[TMPChannel{j} '_TIME_75C'];
    fields{idx+5} =[TMPChannel{j} '_TIME_90C'];
    fields{idx+6} =[TMPChannel{j} '_TIME_105C'];
    fields{idx+7} =[TMPChannel{j} '_TIME_120C'];
    fields{idx+8} =[TMPChannel{j} '_TIME_135C'];
    fields{idx+9} =[TMPChannel{j} '_TIME_150C'];
    
end

fields{80}='ARGR_MAX';
fields{81}='PNGA_MAX';



for k = 1:length(files)
    inputFileName = files(k).name
    FullInputFileName = strcat(FolderName,'\',inputFileName);
    
%         quote = '"';
%         sep = ',';
%         escape = '\';
%         [channelData, text] = swallow_csv(FullInputFileName, quote, sep, escape);
%         channelData(1:3,:)=[];
%         channelData(:,all(isnan(channelData),1))=[];
%         channelName=text(1,1:size(channelData,2));
%         clear text
    
    [channelData,channelName]=LoadDumpDataCSV(FullInputFileName);
    
    %     [channelData,text] = xlsread(FullInputFileName,'');
    %    channelName = text(1,:);
    %    channelName = strrep(channelName,' ', '');
    
    EnvChannelIdx = [];
    for i=1:length(EnvChannel)
        EnvChannelIdx=[EnvChannelIdx;find(strcmp(channelName,EnvChannel{i})==1)];
    end
    
    
    % if size(channelData, 2)==196
    
    %% Get Env Channel Data
    EnvChannelData = channelData(:,EnvChannelIdx);
    clear channelData channelName;
    
    
    %% remove  -999.25 Channel value
    removeValueIdx =[];
    for j = 2: size(EnvChannelData,2)
        removeValueIdx =[removeValueIdx; find(EnvChannelData(:,j)== -999.25)];
    end
    removeValueIdx = unique(removeValueIdx);
    EnvChannelData(removeValueIdx,:) =[];
    [row, col]= find(isnan(EnvChannelData));
    EnvChannelData(row,:)=[];
    
    [ChannelData_max,I] = max(EnvChannelData,[],1);
    
    
    channel_idx = find(strcmp(EnvChannel,'SHKL')==1);
    %     % SHKL_channel = EnvChannelData(:,channel_idx);
    values{k,1} = inputFileName(1:end-4);
    sep_idx = strfind(inputFileName,'_');
    values{k,2} = inputFileName(1:sep_idx(1)-1);
    
    
    values{k,3} = inputFileName(sep_idx(3)+1:sep_idx(4)-1);
    values{k,4} = inputFileName(sep_idx(4)+1:end-4);
    startTime = inputFileName(sep_idx(1)+1:sep_idx(2)-1);
    values{k,5} = strcat([startTime(1:4),'/',startTime(5:6),'/',startTime(7:8),' ',startTime(9:10),':',startTime(11:12),':',startTime(13:end)]);
    
    values{k,7} = num2str(ChannelData_max(channel_idx));
    values{k,8} = num2str(sum(EnvChannelData(:,channel_idx)==0)*2);
    values{k,9} = num2str(sum(EnvChannelData(:,channel_idx)==1)*2);
    values{k,10} = num2str(sum(EnvChannelData(:,channel_idx)==2)*2);
    values{k,11} = num2str(sum(EnvChannelData(:,channel_idx)==3)*2);
    
    channel_idx = find(strcmp(EnvChannel,'SHKC')==1);
    
    values{k,12} = num2str(ChannelData_max(channel_idx));
    values{k,13} = num2str(sum(EnvChannelData(:,channel_idx)));
    
    
    for j= 1: length(SHChannel)
        idx =  13+(j-1)*7;
        SHChannel_idx = find(strcmp(EnvChannel,SHChannel(j))==1);
        % SHKL_channel = EnvChannelData(:,channel_idx);
        values{k,idx+1} = num2str(ChannelData_max(SHChannel_idx));
        values{k,idx+2} = num2str(sum(EnvChannelData(:,SHChannel_idx)));
        values{k,idx+3} = num2str(sum(EnvChannelData(:,SHChannel_idx)<=25)*2);
        values{k,idx+4} = num2str(sum((EnvChannelData(:,SHChannel_idx)>25)&(EnvChannelData(:,SHChannel_idx)<=50))*2);
        values{k,idx+5} = num2str(sum((EnvChannelData(:,SHChannel_idx)>50)&(EnvChannelData(:,SHChannel_idx)<=100))*2);
        values{k,idx+6} = num2str(sum((EnvChannelData(:,SHChannel_idx)>100)&(EnvChannelData(:,SHChannel_idx)<=200))*2);
        values{k,idx+7} = num2str(sum(EnvChannelData(:,SHChannel_idx)>200)*2);
    end
    
    for j= 1: length(VBChannel)
        idx = 34+ (j-1)* 6;
        VBChannel_idx = find(strcmp(EnvChannel,VBChannel(j))==1);
        % SHKL_channel = EnvChannelData(:,channel_idx);
        values{k,idx+1} = num2str(ChannelData_max(VBChannel_idx));
        values{k,idx+2} = num2str(sum(EnvChannelData(:,VBChannel_idx)));
        values{k,idx+3} = num2str(sum((EnvChannelData(:,VBChannel_idx)<=1))*2);
        values{k,idx+4} = num2str(sum((EnvChannelData(:,VBChannel_idx)>1)&(EnvChannelData(:,VBChannel_idx)<=3))*2);
        values{k,idx+5} = num2str(sum((EnvChannelData(:,VBChannel_idx)>3)&(EnvChannelData(:,VBChannel_idx)<=6))*2);
        values{k,idx+6} = num2str(sum(EnvChannelData(:,VBChannel_idx)>6)*2);
    end
    
    
    for j= 1: length(TMPChannel)
        idx = 52+(j-1)*9;
        TMPChannel_idx = find(strcmp(EnvChannel,TMPChannel(j))==1);
        
        if strcmp(TMPChannel(j),'DTMP')
            TIMEChannel_idx = find(strcmp(EnvChannel,'TIME')==1);
            TIME_channel = EnvChannelData(:,TIMEChannel_idx);
            time = TIME_channel(I(TMPChannel_idx));
            format = 'yyyy/mm/dd HH:MM:SS';
            timeDateNum = time/86400+ datenum(values{k,5},format);
            timeDataStr = datestr(timeDateNum,format);
            values{k,6} = timeDataStr;
            
            
        end
        % SHKL_channel = EnvChannelData(:,channel_idx);
        values{k,idx+1} = num2str(ChannelData_max(TMPChannel_idx));
        %TMPChannel_cumu(j) = sum(EnvChannelData(:,TMPChannel_idx));
        values{k,idx+2}= num2str(sum((EnvChannelData(:,TMPChannel_idx)<=60))*2);
        values{k,idx+3}= num2str(sum((EnvChannelData(:,TMPChannel_idx)>60)&(EnvChannelData(:,TMPChannel_idx)<=75))*2);
        values{k,idx+4} = num2str(sum((EnvChannelData(:,TMPChannel_idx)>75)&(EnvChannelData(:,TMPChannel_idx)<=90))*2);
        values{k,idx+5} = num2str(sum((EnvChannelData(:,TMPChannel_idx)>90)&(EnvChannelData(:,TMPChannel_idx)<=105))*2);
        values{k,idx+6} = num2str(sum((EnvChannelData(:,TMPChannel_idx)>105)&(EnvChannelData(:,TMPChannel_idx)<120))*2);
        values{k,idx+7} = num2str(sum((EnvChannelData(:,TMPChannel_idx)>120)&(EnvChannelData(:,TMPChannel_idx)<=135))*2);
        values{k,idx+8} = num2str(sum((EnvChannelData(:,TMPChannel_idx)>135)&(EnvChannelData(:,TMPChannel_idx)<=150))*2);
        values{k,idx+9} = num2str(sum(EnvChannelData(:,TMPChannel_idx)>150)*2);
    end
    
    values{k, 80} =  num2str(ChannelData_max(find(strcmp(EnvChannel,'ARGR')==1)));
    values{k, 81} =  num2str(ChannelData_max(find(strcmp(EnvChannel,'PNGA')==1)));
    
    clear TIME_channel
    
    %  end
end

toc
outputCSVFileName = [FolderName '\' csvFileName '.csv'];
storeCSVData = vertcat(fields,values);
cell2csv(outputCSVFileName,storeCSVData,',');

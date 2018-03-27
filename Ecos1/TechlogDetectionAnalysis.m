function [storeCSVData]= TechlogDetectionAnalysis(Info)






%% load healthy data and models
load('TechlogChannelNameAll.mat');
StatusChannelName = load('StatusFormatsChannel');
TPChannelName = load('TPFormatsChannel');
PowerChannelName = load('PowerFormatsChannel');
ResisChannelName = load('ResisFormatsChannel');
NGRChannelName = load('NGRFormatsChannel');
GGDChannelName = load('GGDFormatsChannel');
PNGChannelName = load('PNGFormatsChannel');
NPChannelName = load('NPFormatsChannel');
NGDChannelName = load('NGDFormatsChannel');
UltraChannelName = load('UltraFormatsChannel');
RotaryChannelName = load('RotaryFormatsChannel');
NBIChannelName = load('NBIFormatsChannel');


PowerHealthyData = load('PowerTechlogHealthyTrainData');
ResisHealthyData = load('ResistivityTechlogHealthyTrainData');
NGRHealthyData = load('NGRTechlogHealthyTrainData');
GGDHealthyData = load('GGDTechlogHealthyTrainData');
PNGHealthyData = load('PNGTechlogHealthyTrainData');
NPHealthyData = load('NPTechlogHealthyTrainData');
NGDHealthyData = load('NGDTechlogHealthyTrainData');
UltraHealthyData = load('UltraTechlogHealthyTrainData');
RotaryHealthyData = load('RotaryTechlogHealthyTrainData');
NBIHealthyData = load('NBITechlogHealthyTrainData');



Power_model = load('Power_Techlog_model');
Resis_model = load('Resistivity_Techlog_model');
NGR_model = load('NGR_Techlog_model');
GGD_model = load('GGD_Techlog_model');
PNG_model = load('PNG_Techlog_model');
NP_model = load('NP_Techlog_model');
NGD_model = load('NGD_Techlog_model');
Ultra_model = load('Ultra_Techlog_model');
Rotary_model = load('Rotary_Techlog_model');
NBI_model = load('NBI_Techlog_model');



ABSENT1 = 65535;


field1 = 'name';
value1 = {PowerChannelName.channelName,ResisChannelName.channelName,NGRChannelName.channelName, GGDChannelName.channelName,PNGChannelName.channelName,...
    NPChannelName.channelName,NGDChannelName.channelName,UltraChannelName.channelName, RotaryChannelName.channelName,NBIChannelName.channelName};
field2 = 'data';
value2 = {PowerHealthyData.data,ResisHealthyData.data, NGRHealthyData.data,GGDHealthyData.data, PNGHealthyData.data,...
    NPHealthyData.data,NGDHealthyData.data, UltraHealthyData.data,RotaryHealthyData.data, NBIHealthyData.data};
field3 = 'model';
value3 = {Power_model.SVMModel,Resis_model.SVMModel,NGR_model.SVMModel,GGD_model.SVMModel,PNG_model.SVMModel,...
    NP_model.SVMModel,NGD_model.SVMModel,Ultra_model.SVMModel,Rotary_model.SVMModel,NBI_model.SVMModel};
%field4 = 'BRTmodel';  value4 = {Power_BRT_model.model,PNG_BRT_model.model,B05NN_BRT_model.model,B06NG_BRT_model.model,B06GG_BRT_model.model};
%field5 = 'BRTSVMmodel';  value5 = {Power_BRTSVM_model.model,PNG_BRTSVM_model.model,B05NN_BRTSVM_model.model,B06NG_BRTSVM_model.model,B06GG_BRTSVM_model.model};

field4 = 'filename';
value4 ={'Power','Resis','NGR','GGD','PNG','NP','NGD','Ultra','Rotary','NBI'};

%# choose one channel for each board as an output
% power: AREF; PNG: ICLO; B05NN: MON; B06NG: LDTF; B06GG: SPCD

% field6 = 'BRTname';
% value6 ={'P333','IFLO','R2V5','ATMP','SPCD'};

HealthyDataRef = struct(field1,value1,field2,value2,field3,value3,field4,value4);

clear PowerChannelName ResisChannelName NGRChannelName GGDChannelName PNGChannelName NPChannelName NGDChannelName UltraChannelName RotaryChannelName NBIChannelName
clear PowerHealthyData ResisHealthyData NGRHealthyData GGDHealthyData PNGHealthyData NPHealthyData NGDHealthyData UltraHealthyData RotaryHealthyData NBIHealthyData
clear Power_model Resis_model NGR_model GGD_model PNG_model NP_model NGD_model Ultra_model Rotary_model NBI_model
%clear Power_BRTSVM_model PNG_BRTSVM_model B05NN_BRTSVM_model B06NG_BRTSVM_model B06GG_BRTSVM_model

%% create cell array for storing all results to csv file
fields = cell(1, 51);
values = cell(1,51);
fields{1} = 'FileName';
for i = 1:10
    f_idx = (i-1)* 5+1;
    fields{f_idx + 1} = [value4{i} 'MD'];
    fields{f_idx + 2} = [value4{i} 'SVM(%)'];
    %     fields{f_idx + 3} = [value6{i} 'BRT(%)'];
    %     fields{f_idx + 4} = [value6{i} 'BRTSVM(%)'];
    
    for j = 1:3
        fields{f_idx+2+j}= ['Sig_' value4{i} 'Chan' '_' num2str(j)];
        %fields{f_idx+2+(j-1)*2+2}= [value4{i} 'ChanPct' num2str(j),'(%)'];
    end
end


clear field1 field2 field3 field4 value1 value2 value3 value4


%% Start analyzing
load_wait = waitbar(0,sprintf('Start processing the selected file. It may take a couple of mintues or longer. Please wait...')); % Create the waitbar

%% load processed dump data
dataStruct= load('EcoScope_TechlogChannel_Data');
channelData = dataStruct.data_struct.channel_data;
channelName = dataStruct.data_struct.channel_name;
%     if (size(channelData,2) ~= length(channelName))||(size(channelData,1)<=500)
%         continue
%     end

%waitbar(((k-1)*(length(HealthyDataRef)+1)+1)/(length(files)*(length(HealthyDataRef)+1)),load_wait);

inputFile = dataStruct.data_struct.filename;
if exist(inputFile,'dir')~=7
    mkdir(inputFile);
end
outputSVMFileName = [inputFile '/' 'DataAnalysisResult.txt'];
fid = fopen(outputSVMFileName,'wt');

%outputCSVFileName = [inputFile '/' 'DataAnalysisResult.csv'];


%% Add Statuswords decoding here
% Get status words channel group
% status words decoding

StatusWord_idx = [];
SWChannelName = StatusChannelName.channelName;
 for i=1:length(SWChannelName)
        StatusWord_idx = find(strcmp(channelName,SWChannelName{i})==1);
        Status_channel = channelData(:,StatusWord_idx);
        
        % bit decoding if necessary
        SWbi= dec2bin(Status_channel,16);
        SWbi = SWbi - '0';
        SWbi = fliplr(SWbi);
        
        switch SWChannelName{i}

           case 'PSSW'
       
            PSSW_PNG_idx = find(SWbi(:,10)==1); % downlink received to stop PNG
        end

 end


%% Analysis for individual subsystem

for n = 1: length(HealthyDataRef)
    idx=[];
    selectedChannelName = HealthyDataRef(n).name;
    selectedHealthyData = HealthyDataRef(n).data;
    selectedSVMModel = HealthyDataRef(n).model;
    selectedFileName = HealthyDataRef(n).filename;
    
    values{1,1} = inputFile;
    v_idx = (n-1)*5+1;
    
    
    if (size(channelData, 2)< 196) || (Info.PNGOff == 1)
        
        if strcmp(selectedFileName, 'PNG')|| strcmp(selectedFileName,'NP')|| strcmp(selectedFileName,'NGD')
            
            %% assignvalues to cell array
            values{1, v_idx + 1} = 'N/A';
            values{1, v_idx + 2} = 'N/A';
            %         values{k, v_idx + 3} = num2str(BRT_test_error,'%.2f');
            %         values{k, v_idx + 4} = num2str(BRTSVM_error,'%.2f');
            
            for mm = 1: 3
                values{1, v_idx+2+mm} =  'N/A';
                %values{k, v_idx+2+(mm-1)*2+2} =  num2str(SigPercent(mm),'%.2f');
                
            end
            
            continue;
        end
    end
    %% select subsystem channel group
    for i=1:length(selectedChannelName)
        idx=[idx;find(strcmp(channelName,selectedChannelName{i})==1)];
    end
    
    data=channelData(:,idx);
    
    %% perform limits check for current channel group here
    % no limits check for Resis and Ultra channel groups
    
    
    
    
    %% Calculate the normalized Mahalanobis Distance of the file (PNG on/off)
    FigFileName = strcat(selectedFileName,' Channels');
    TesMD = nmahal(data, selectedHealthyData);
    
        %% SVM evaluation
    [test_error,predicted_test_labels] = EcoScopeSVMPredict(data,selectedSVMModel);
    
    if isempty(PSSW_PNG_idx)
        
        TesMDBins = linspace(percentile(TesMD,0.001),percentile(TesMD,0.999),10); %create 10 equal sized bins from 0.1 to 99.9 percentiles
        Counts = hist(TesMD,TesMDBins); %calculate the number of counts for each bin
        Percents = Counts/length(TesMD)*100; %calculate the fraction of the counts from the whole sample
        MD = percentile(TesMD,0.99);
        
        fisherOutput = (predicted_test_labels+1)/2+1;
        fisherScore = fsFisher(data, fisherOutput);
        normScore = fisherScore.W./sum(fisherScore.W)*100;
        
    else
        PNGOn_idx = setdiff(1:length(TesMD),PSSW_PNG_idx);
        TesMD_PNGOn = TesMD(PNGOn_idx);
        
        TesMDBins = linspace(percentile(TesMD_PNGOn,0.001),percentile(TesMD_PNGOn,0.999),10); %create 10 equal sized bins from 0.1 to 99.9 percentiles
        Counts = hist(TesMD_PNGOn,TesMDBins); %calculate the number of counts for each bin
        Percents = Counts/length(TesMD_PNGOn)*100; %calculate the fraction of the counts from the whole sample
        MD = percentile(TesMD_PNGOn,0.99);
        
        predicted_test_labels_PNGOn = predicted_test_labels(PNGOn_idx);
        test_error = length(find(predicted_test_labels_PNGOn ==ones(size(predicted_test_labels_PNGOn))))/length(predicted_test_labels_PNGOn)*100;
        fisherOutput = (predicted_test_labels_PNGOn+1)/2+1;
        fisherScore = fsFisher(data(PNGOn_idx,:), fisherOutput);
        normScore = fisherScore.W./sum(fisherScore.W)*100;
        
        
    end
    
    %% Open a figure
    
    h=figure('Visible','off');
    
    subplot(2,2,1);
    plot(TesMD);
    title(['MD of ', FigFileName]);
    ylabel('Normalized MD (\sigma)');
    xlabel('Time')
    
    subplot(2,2,2);
    bar(TesMDBins,Percents) %plot
    xlabel({'Normalized MD (\sigma)'; ['99^t^h Percentile = ',num2str(MD)]})
    ylabel('Sample Percentage (%)')
    title(['Histogram MD of ',FigFileName]);
    
    
    subplot(2,2,3);
    plot(predicted_test_labels);
    
    if ~isempty(strfind(FigFileName,'PNG'))
        hold on
        plot(SWbi(:,10),'r','LineWidth',2)
        hold off
        legend('SVM Output','PSSW Bit 9',4)
    end
    ylim([-1.1 1.1]);
    title(['SVM Output of ', FigFileName]);
    xlabel({'Time'; ['Classification Result = ',num2str(floor(test_error)),'%']});
    
    subplot(2,2,4);
    barh(normScore(fisherScore.fList(3:-1:1)));
    x = normScore(fisherScore.fList(3:-1:1))';
    SigPercent = normScore(fisherScore.fList(1:3))';
    labels=selectedChannelName(fisherScore.fList(3:-1:1));
    SigChannel = selectedChannelName(fisherScore.fList(1:3));
    set(gca,'YTick',1:3,'YTickLabel',labels);
    xlabel('Percent (%)');
    if(~isnan(max(x)))
        xlim([0 round(max(x)*1.2)]);
    end
    text(x,(1:3),num2str(floor(x)));
    title([FigFileName ' Significance' ]);
    
    
    
    outputFilename = strcat(inputFile, '/',selectedFileName,'_MD_', num2str(floor(MD)),'_SVM_', num2str(floor(test_error)),'.jpg');
    print(h, '-djpeg', outputFilename);
    
    %          outputFileBRTname = strcat(inputFile, '/',selectedFileName,'_BRTResidue','.jpg');
    %        print(BRT_h, '-djpeg', outputFileBRTname);
    
    
    
    
    %% assignvalues to cell array
    
    
    
    values{1, v_idx + 1} = num2str(MD,'%.2f');
    values{1, v_idx + 2} = num2str(test_error,'%.2f');
    %         values{k, v_idx + 3} = num2str(BRT_test_error,'%.2f');
    %         values{k, v_idx + 4} = num2str(BRTSVM_error,'%.2f');
    
    for mm = 1: 3
        values{1, v_idx+2+mm} =  strcat(SigChannel{mm},'(',num2str(SigPercent(mm),'%.2f'),'%)');
        %values{k, v_idx+2+(mm-1)*2+2} =  num2str(SigPercent(mm),'%.2f');
        
    end
    
    
    
    
    %% write to .txt file
    fprintf(fid,'%s\n', [selectedFileName,' detection 99% MD value: ',num2str(MD,'%.2f')]);
    fprintf(fid,'%s\n', [selectedFileName,' detection SVM result: ',num2str(test_error,'%.2f'),'%']); %[c,': Faulty '];['(Classify Accy: ' accuracy '%)']};
    %         fprintf(fid,'%s\n', [selectedFileName,' detection BRT result: ',num2str(BRT_test_error,'%.2f'),'%']); %[c,': Faulty '];['(Classify Accy: ' accuracy '%)']};
    %         fprintf(fid,'%s\n', [selectedFileName,' detection BRT-SVM result: ',num2str(BRTSVM_error,'%.2f'),'%']); %[c,': Faulty '];['(Classify Accy: ' accuracy '%)']};
    
    fprintf(fid,'Significant channels: %s: %.2f%%; %s: %.2f%%; %s: %.2f%%\n\n', labels{3}, x(3), labels{2}, x(2),labels{1}, x(1));
    
    clear data idx outputFile test_error predicted_test_labels BRT_output residue TesMD SigPercent SigChannel MD x labels
    clear input output fisherOutput PNGOn_idx predict_output predicted_test_labels_PNGOn PSSW_channel smoothresidue TesMD_PNGOn
    
    waitbar(((1-1)*(length(HealthyDataRef)+1)+1+n)/(1*(length(HealthyDataRef)+1)),load_wait);
   
    
end

fclose(fid);


storeCSVData = vertcat(fields,values);
close(load_wait)

% csvFileNameFull = strrep(strcat(csvFileName,'_',strrep(datestr(now),':','_'),'.csv'),' ','_');
%
% if exist(csvFileNameFull,'file')~=0
%     delete(csvFileNameFull);
% end
% cell2csv(csvFileNameFull,storeCSVData,',');
%
% DataSenderPath = getenv('BerData');
% if(~isempty(DataSenderPath))
%     copypath = strcat(DataSenderPath,'\Inbox\');
%     copyfile(csvFileNameFull,copypath,'f');
% else % if the thm data sender doesn't exist then this program creates one and backups the file
%     msgbox('You dont have THM Data Sender installed. Please install Toolscope','THM Data Sender Not Found!');
%     programfiles = 'C:\Program Files (x86)\';
%     if(exist(strcat(programfiles,'Schlumberger'),'dir')==0);
%         mkdir(programfiles,'Schlumberger');
%     end
%     if(exist(strcat(programfiles,'Schlumberger\BER'),'dir')==0);
%         mkdir(strcat(programfiles,'Schlumberger'),'BER');
%     end
%     if(exist(strcat(programfiles,'Schlumberger\BER\Data'),'dir')==0);
%         mkdir(strcat(programfiles,'Schlumberger\BER'),'Data');
%     end
%     if(exist(strcat(programfiles,'Schlumberger\BER\Data\Inboxd'),'dir')==0);
%         mkdir(strcat(programfiles,'Schlumberger\BER\Data'),'Inboxd');
%     end
%
%     setenv('BerData', 'C:\Program Files (x86)\Schlumberger\BER\Data');
%     DataSenderPath = getenv('BerData');
%     copypath = strcat(DataSenderPath,'\Inbox\');
%     copyfile(csvFileNameFull,copypath,'f');
% end



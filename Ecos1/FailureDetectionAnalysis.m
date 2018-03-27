function [storeCSVData]= FailureDetectionAnalysis(files,currentFolder)


% Promp the folder selection GUI

%currentFolder = uigetdir('*.dat','Select the DAT file to load','MultiSelect','off');

% DATFile = strcat(currentFolder, '\*.dat');
% %% find folder name
%
% %currentFolder = pwd;
%
% files=dir(DATFile); % or whatever wildcard makes best match to desired...
%
% if length(files) > 1  % process the folder
%     idx=strfind(currentFolder,'\');
%     currentFolder(1:idx(end))=[];
%     csvFileName = strcat(currentFolder,'_Result');
% else % process one file
%     csvFileName=files.name(1:end-4);
% end

%% load healthy data and models
load('AllChanNameSW.mat');
PNGChannelName = load('PNGOnlyChanName.mat');
B05NNChannelName = load('B05NNOnlyChanName.mat');
B06NGChannelName = load('B06NGOnlyChanName.mat');
B06GGChannelName = load('B06GGOnlyChanName.mat');
PowerChannelName = load('powerChannelName.mat');


PowerHealthyData = load('powerHealthyData');
PNGHealthyData = load('PNGHealthyData');
B05NNHealthyData = load('B05NNHealthyData');
B06NGHealthyData = load('B06NGHealthyData');
B06GGHealthyData = load('B06GGHealthyData');

Power_model = load('Power_model');
PNG_model = load('PNG_model');
B05NN_model = load('B05NN_model');
B06NG_model = load('B06NG_model');
B06GG_model = load('B06GG_model');

Power_BRT_model = load('Power_BRT_model');
PNG_BRT_model = load('PNG_BRT_model');
B05NN_BRT_model = load('B05NN_BRT_model');
B06NG_BRT_model = load('B06NG_BRT_model');
B06GG_BRT_model = load('B06GG_BRT_model');

% Power_BRTSVM_model = load('Power_BRTSVM_model');
% PNG_BRTSVM_model = load('PNG_BRTSVM_model');
% B05NN_BRTSVM_model = load('B05NN_BRTSVM_model');
% B06NG_BRTSVM_model = load('B06NG_BRTSVM_model');
% B06GG_BRTSVM_model = load('B06GG_BRTSVM_model');


ABSENT1 = 65535;


field1 = 'name';
value1 = {PowerChannelName.channelName,PNGChannelName.channelName,B05NNChannelName.channelName, B06NGChannelName.channelName,B06GGChannelName.channelName};
field2 = 'data';
value2 = {PowerHealthyData.data,PNGHealthyData.data, B05NNHealthyData.data,B06NGHealthyData.data, B06GGHealthyData.data};
field3 = 'model';  value3 = {Power_model.SVMModel,PNG_model.SVMModel,B05NN_model.SVMModel,B06NG_model.SVMModel,B06GG_model.SVMModel};
field4 = 'BRTmodel';  value4 = {Power_BRT_model.model,PNG_BRT_model.model,B05NN_BRT_model.model,B06NG_BRT_model.model,B06GG_BRT_model.model};
%field5 = 'BRTSVMmodel';  value5 = {Power_BRTSVM_model.model,PNG_BRTSVM_model.model,B05NN_BRTSVM_model.model,B06NG_BRTSVM_model.model,B06GG_BRTSVM_model.model};

field5 = 'filename';
value5 ={'Power','B-PNG','B05NN','B06NG','B06GG'};

%# choose one channel for each board as an output
% power: AREF; PNG: ICLO; B05NN: MON; B06NG: LDTF; B06GG: SPCD

field6 = 'BRTname';
value6 ={'P333','IFLO','R2V5','ATMP','SPCD'};

HealthyDataRef = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6);

clear PowerChannelName PNGChannelName B05NNChannelName B06NGChannelName B06GGChannelName
clear PowerHealthyData PNGHealthyData B05NNHealthyData B06NGHealthyData B06GGHealthyData
clear Power_model PNG_model B05NN_model B06NG_model B06GG_model
clear Power_BRT_model PNG_BRT_model B05NN_BRT_model B06NG_BRT_model B06GG_BRT_model
%clear Power_BRTSVM_model PNG_BRTSVM_model B05NN_BRTSVM_model B06NG_BRTSVM_model B06GG_BRTSVM_model

%% create cell array for storing all results to csv file
fields = cell(1, 61);
values = cell(length(files),61);
fields{1} = 'FileName';
for i = 1:5
    f_idx = (i-1)* 12+1;
    fields{f_idx + 1} = [value5{i} 'MD'];
    fields{f_idx + 2} = [value5{i} 'SVM(%)'];
    %     fields{f_idx + 3} = [value6{i} 'BRT(%)'];
    %     fields{f_idx + 4} = [value6{i} 'BRTSVM(%)'];
    
    for j = 1:10
        fields{f_idx+2+j}= ['Sig_' value5{i} 'Chan' '_' num2str(j)];
        %fields{f_idx+2+(j-1)*2+2}= [value4{i} 'ChanPct' num2str(j),'(%)'];
    end
end


clear field1 field2 field3 field4 field5 field6 value1 value2 value3 value4 value5 value6



%% Start analyzing
load_wait = waitbar(0,sprintf('Start processing the whole folder. It may take minutes to hours. Please wait...')); % Create the waitbar

for k = 1:length(files)
    
    
    inputFileName = strcat(currentFolder,'\',files(k).name);
    %load (inputFileName);
    
    channelData = PreProcessData(inputFileName);
    
    if (size(channelData,2) ~= length(channelName))||(size(channelData,1)<=500)
        continue
    end
    
    waitbar(((k-1)*(length(HealthyDataRef)+1)+1)/(length(files)*(length(HealthyDataRef)+1)),load_wait);
    
    inputFile = inputFileName(1:end-4);
    if exist(inputFile,'dir')~=7
        mkdir(inputFile);
    end
    outputSVMFileName = [inputFile '/' 'DataAnalysisResult.txt'];
    fid = fopen(outputSVMFileName,'wt');
    
    outputCSVFileName = [inputFile '/' 'DataAnalysisResult.csv'];
    
    
    
    %% Get PSSW information
    PSSW_idx = find(strcmp(channelName,'PSSW')==1);
    PSSW_channel = channelData(:,PSSW_idx);
    
    SWbi = dec2bin(PSSW_channel,16);
    SWbi = SWbi - '0';
    SWbi = fliplr(SWbi);
    
    PSSW_PNG_idx = find(SWbi(:,10)==1); % downlink received to stop PNG
    
    
    
    %% Remove channels not-used.
    
    
    
    
    for n = 1: length(HealthyDataRef)
        idx=[];
        selectedChannelName = HealthyDataRef(n).name;
        selectedHealthyData = HealthyDataRef(n).data;
        selectedSVMModel = HealthyDataRef(n).model;
        selectedFileName = HealthyDataRef(n).filename;
        
        selectedBRTModel = HealthyDataRef(n).BRTmodel;
        %selectedBRTSVMModel = HealthyDataRef(n).BRTSVMmodel;
        selectedBRTChannelName =HealthyDataRef(n).BRTname;
        
        for i=1:length(selectedChannelName)
            idx=[idx;find(strcmp(channelName,selectedChannelName{i})==1)];
        end
        
        data=channelData(:,idx);
        
        
        if n == 5  % for B06GG board
            data(:,[5 17 41])=[];
        end
        
        
        %% choose one channel for BRT output
        
        BRT_idx = find(strcmp(selectedChannelName,selectedBRTChannelName)==1);
        input = data;
        input(:,BRT_idx)=[];
        output=data(:,BRT_idx);
        
        %% BRT prediction
        predict_output = selectedBRTModel.predict(input);
        residue = output-predict_output;
        
        smoothresidue = tsmovavg(residue, 'e',500,1);
        %
        %         deg = atan(predict_output./output)*180/pi;
        %
        %         BRT_output = (deg>43)&(deg<47);
        %% SVM evaluation
        %  [BRTSVM_error,predicted_BRTSVM_labels] = EcoScopeSVMPredict(residue,selectedBRTSVMModel);
        
        
        %inputFile = files(k).name(1:end-11);
        %outputFile = strcat(selectedFileName);
        % save(outputFile,'data')
        
        
        %% Calculate the normalized Mahalanobis Distance of the file (PNG on/off)
        FigFileName = strcat(selectedFileName(end-4:end),' Channels');
        TesMD = nmahalanobis(data, selectedHealthyData);
        
        
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
            
            %  BRT_test_error = length(find(BRT_output ==ones(size(BRT_output))))/length(BRT_output)*100;
            
            %             ResidueBins = linspace(percentile(residue,0.001),percentile(residue,0.999),10);
            %             ResidueCounts = hist(residue,ResidueBins); %calculate the number of counts for each bin
            %             ResiduePercents = ResidueCounts/length(residue)*100; %calculate the fraction of the counts from the whole sample
            %             Residue = percentile(residue,0.80);
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
            
            %             predicted_BRTSVM_labels_PNGOn = predicted_BRTSVM_labels(PNGOn_idx);
            %             BRTSVM_error = length(find(predicted_BRTSVM_labels_PNGOn ==ones(size(predicted_BRTSVM_labels_PNGOn))))/length(predicted_BRTSVM_labels_PNGOn)*100;
            %
            %
            %             residue_PNGOn = residue(PNGOn_idx);
            %             BRT_output_PNGOn = BRT_output(PNGOn_idx);
            %             BRT_test_error = length(find(BRT_output_PNGOn ==ones(size(BRT_output_PNGOn))))/length(BRT_output_PNGOn)*100;
            %
            
            
            %             ResidueBins = linspace(percentile(residue_PNGOn,0.001),percentile(residue_PNGOn,0.999),10);
            %             ResidueCounts = hist(residue_PNGOn,ResidueBins); %calculate the number of counts for each bin
            %             ResiduePercents = ResidueCounts/length(residue_PNGOn)*100; %calculate the fraction of the counts from the whole sample
            %             Residue = percentile(residue_PNGOn,0.80);
            
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
        
        
        
        
        %         barh(normScore(fisherScore.fList(3:-1:1)));
        x = normScore(fisherScore.fList(3:-1:1))';
        SigPercent = normScore(fisherScore.fList(1:10))';
        labels=selectedChannelName(fisherScore.fList(3:-1:1));
        SigChannel = selectedChannelName(fisherScore.fList(1:10));
        %         set(gca,'YTick',1:3,'YTickLabel',labels);
        %         xlabel('Percent (%)');
        %         if(~isnan(max(x)))
        %             xlim([0 round(max(x)*1.2)]);
        %         end
        %         text(x,(1:3),num2str(floor(x)));
        %
        
        %% BRT plotting
        
        
        
        %         subplot(3,2,4);
        %         plot(BRT_output);
        %
        %         ylim([-0.1 1.1]);
        %         title(['BRT Output of ', FigFileName]);
        %         xlabel({'Time'; ['Classification Result = ',num2str(floor(BRT_test_error)),'%']});
        
        %BRT_h=figure('Visible','on');
        
        subplot(2,2,4)
        plot(smoothresidue);
        title('BRT Channel Residue');
        xlabel({'Time'});
        ylabel('Residue')
        
        
        %         subplot(3,2,6)
        %         plot(predicted_BRTSVM_labels);
        %
        %         ylim([-1.1 1.1]);
        %         title(['BRT-SVM Output of ', FigFileName]);
        %         xlabel({'Time'; ['Classification Result = ',num2str(floor(BRTSVM_error)),'%']});
        
        %         plot(residue);
        %         title('BRT Channel Residue');
        %         xlabel({'Time'});
        %         ylabel('Residue')
        
        %         subplot(3,2,6)
        %         bar(ResidueBins,ResiduePercents) %plot
        %         xlabel({'Channel Residue'; ['80^t^h Percentile = ',num2str(Residue,'%.2e')]})
        %         ylabel('Percentage (%)')
        %         title('Residue Histogram');
        
        
        outputFilename = strcat(inputFile, '/',selectedFileName,'_MD_', num2str(floor(MD)),'_SVM_', num2str(floor(test_error)),'.jpg');
        print(h, '-djpeg', outputFilename);
        
        %          outputFileBRTname = strcat(inputFile, '/',selectedFileName,'_BRTResidue','.jpg');
        %        print(BRT_h, '-djpeg', outputFileBRTname);
        
        
        
        
        %% assignvalues to cell array
        fileName = strrep(inputFile,' ','_');
        idx=strfind(fileName,'\');
        fileName(1:idx(end))=[];
        
        values{k,1} = fileName;
        v_idx = (n-1)*12+1;
        values{k, v_idx + 1} = num2str(MD,'%.2f');
        values{k, v_idx + 2} = num2str(test_error,'%.2f');
        %         values{k, v_idx + 3} = num2str(BRT_test_error,'%.2f');
        %         values{k, v_idx + 4} = num2str(BRTSVM_error,'%.2f');
        
        for mm = 1: 10
            values{k, v_idx+2+mm} =  strcat(SigChannel{mm},'(',num2str(SigPercent(mm),'%.2f'),'%)');
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
        
        waitbar(((k-1)*(length(HealthyDataRef)+1)+1+n)/(length(files)*(length(HealthyDataRef)+1)),load_wait);
        
    end
    
    fclose(fid);
    storeFileCSVData = vertcat(fields,values(k,:));
    cell2csv(outputCSVFileName,storeFileCSVData,',');
    
    clear channelData storeFileCSVData
end
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
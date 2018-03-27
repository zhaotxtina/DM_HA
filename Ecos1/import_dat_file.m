function import_dat_file

%
%__________________________________________________________________________
% import_dat_file
% Load channel data in dat format in base workspace
%
% Syntax
% import_dat_file
%
% Description
% import_dat_file: loads log data in dat format to the Matlab workspace.
% dataType input is needed as the function provides a file selection GUI.
% The data is loaded in the base workspace in a structure with the same name as the file
% (without the extension). This structure is made of several fields with the file header content, 
% a matrix with all numeric data for global processing and a specific field
% for each data channel for dedicated processing.
%
% Notes
% Current func only accepts .dat file format.





    
    
    % Promp the file selection GUI
    [datFileName, datPathName] = uigetfile('*.dat','Select the DAT file to load','MultiSelect','off');
    %[dumpRepFileName, dumpRepPathName] = uigetfile('*.dat','Open associated Dump Report','MultiSelect','off');
    
    if size(datFileName,2) > 0 && ischar(datPathName),
        file_num = 1;
        load_wait = waitbar(0,sprintf('Loading DAT file. It may take 5-10 minutes. Please wait...')); % Create the waitbar
        
        % Loop through the file list
        
        fullDataName = [datPathName datFileName];
       % fullDumpRepName = [dumpRepPathName dumpRepFileName];
        
        %******************************************************************
        %******************** Start of the file loading *******************
        %******************************************************************
        %% File Opening and reading
        waitbar(1/30);
        [data,allchannels] = LoadDumpData(filename);
        waitbar(2/10);
        %DumpReportName = strcat(fullDataName(1:end),'_DumpReport.DAT');
        
        % remove first sample from the channel
        idx1= find(channelData(:,2)== -999.250);
        if ~isempty(idx1)
            idxdiff1=find(diff(idx1)>1);
            if ~isempty(idxdiff1)
                index1=idx1(1)+idxdiff1(1);
                
                channelData(1:index1-1,:)=[];
            else
                channelData(1:idx1(end),:)=[];
            end
        end
        
        idx=find(channelData(:,2)== 0);
        if ~isempty(idx);
            idxdiff=find(diff(idx)>1);
            if ~isempty(idxdiff)
                index=idx(1)+idxdiff(1);
                channelData(1:index-1,:)=[];
            else
                channelData(1:idx(end),:)=[];
            end
        end
        waitbar(3/10);
             
        
        
        
        %% Generation of output structure with data channels and headers
        %channel_num = size(channelData,2);
        
        [processDataWithEcho,processChannelName]=PreProcessChannelData(channelData, channelName,NECH_ANT,load_wait);
        load('EchoNameShort.mat'); % load pre-defined Echo channel names
        processChannelName = [EchoName';processChannelName];
        
%         %% process PHA2 channel, use differential value instead of absolute value
%         PHA2Index = strmatch('PHA2',processChannelName);
%         PHA2Data = processDataWithEcho(:, PHA2Index);
%         PHA2Diff = diff(PHA2Data);
%         PHA2Diff = [PHA2Diff(1); PHA2Diff];
%         processDataWithEcho(:,PHA2Index) = PHA2Diff;
        
        %% used for building healthy data class, need to comment out for health analyzer running.
        
%         save processDataWithEcho processDataWithEcho
%         save processChannelName processChannelName
        
        %% Separate Field and Lab data
        if strcmp(dataType,'Lab Data')
            removeChanIndex = [41:42, 49:51, 55:58, 67:72]; % remove some empty channels for lab data
            processDataWithEcho(:,removeChanIndex)=[];
            processChannelName(removeChanIndex)=[];
                      
            
%             %% process first three PRJ elements to remove zeros
%             idx = [];
%             for i = 0:2
%                 idxtmp = find(processDataWithEcho(:,48+i)~=0)';
%                 if isempty(idx)
%                     if ~isempty (idxtmp)
%                         idx = idxtmp;
%                     end
%                 else
%                     if ~isempty (idxtmp)
%                         idx = [idx idxtmp];
%                     end
%                 end
%             end
%             idx = unique(idx);
%             
%             PRJFront = ones(size(processDataWithEcho,1),1);
%             PRJFront(idx,:)=0;
%             processDataWithEcho(:,48)= PRJFront;
%             processDataWithEcho(:,49:50)= [];
%             processChannelName{48}= 'PRJFRT';
%             processChannelName(49:50)= [];
            
           
%             %% separate HT and JST using TMPC channel value
%             TMPC_idx = strmatch('TMPC',processChannelName);
%             temp_data = max(processDataWithEcho(:,TMPC_idx));
%             
%                 
%             
%             if temp_data < 50  % JST
%                         %% process PHA2 channel, use differential value instead of absolute value
%         PHA2Index = strmatch('PHA2',processChannelName);
%         PHA2Data = processDataWithEcho(:, PHA2Index);
%         PHA2Diff = diff(PHA2Data);
%         PHA2Diff = [PHA2Diff(1); PHA2Diff];
%         processDataWithEcho(:,PHA2Index) = PHA2Diff;
%                 
%                             %% process first three PRJ elements to remove zeros
%             idx = [];
%             for i = 0:2
%                 idxtmp = find(processDataWithEcho(:,48+i)~=0)';
%                 if isempty(idx)
%                     if ~isempty (idxtmp)
%                         idx = idxtmp;
%                     end
%                 else
%                     if ~isempty (idxtmp)
%                         idx = [idx idxtmp];
%                     end
%                 end
%             end
%             idx = unique(idx);
%             
%             PRJFront = ones(size(processDataWithEcho,1),1);
%             PRJFront(idx,:)=0;
%             processDataWithEcho(:,48)= PRJFront;
%             processDataWithEcho(:,49:50)= [];
%             processChannelName{48}= 'PRJFRT';
%             processChannelName(49:50)= [];
%                 
%                 %% deal with last three PRJ elements
%                 
%                 idx=[];
%                 for i = 0:2
%                     idxtmp = find(processDataWithEcho(:,end-i)~=0)';
%                     if isempty(idx)
%                         if ~isempty (idxtmp)
%                             idx = idxtmp;
%                         end
%                     else
%                         if ~isempty (idxtmp)
%                             idx = [idx idxtmp];
%                         end
%                     end
%                 end
%                 idx = unique(idx);
%                 PRJEnd = ones(size(processDataWithEcho,1),1);
%                 PRJEnd(idx,:)=0;
%                 processDataWithEcho(:,end)= PRJEnd;
%                 processDataWithEcho(:,end-2:end-1)= [];
%                 processChannelName{end}= 'PRJEND';
%                 processChannelName(end-2:end-1)= [];

%                 %% filter first portion of JST
%                 processDataWithEcho(1:10,:)=[];
%                 HVMA_idx = strmatch('HVMA',processChannelName);
%                 removeJSTIndex = find(processDataWithEcho(:,HVMA_idx)<130);
%                 processDataWithEcho(removeJSTIndex,:)=[];
%                 
%                 % remove TCRM and TMPC for both HT and JST
%                     
%             TCRM_idx = strmatch('TCRM',processChannelName);
%             processDataWithEcho(:,[TMPC_idx,TCRM_idx])=[];
%             processChannelName([TMPC_idx,TCRM_idx])=[];
%                 labTestType = 'JST';
%             else % HT 
% %                 processDataWithEcho(:,end)=[];
% %                 processChannelName(end)=[];
%                 labTestType = 'HT';
%             end
%                         
%             % remove TCRM and TMPC for both HT and JST
%                     
% %             TCRM_idx = strmatch('TCRM',processChannelName);
% %             processDataWithEcho(:,[TMPC_idx,TCRM_idx])=[];
% %             processChannelName([TMPC_idx,TCRM_idx])=[];
            
        else  % field data
            numofData = size(processDataWithEcho,1);
            % remove 6 inch casing
            LP2_idx = strmatch('LP2',processChannelName);
            removeTripIndex = find(processDataWithEcho(:,LP2_idx)<150);
            processDataWithEcho(removeTripIndex,:)=[];
            
            % remove 8 inch casing
            FRQ2_idx = strmatch('FRQ2',processChannelName);
            removeTripIndex8= find(processDataWithEcho(:,FRQ2_idx)>265);
            processDataWithEcho(removeTripIndex8,:)=[];
            
            % check casing time percent
            if length(removeTripIndex)+length(removeTripIndex8) > numofData*0.8
                errordlg('Problematic input file with more than 80% casing time!', 'Error');
                return;
            end
            
            removeChanIndex = [41:42, 69:72]; % remove some empty channels for log data
            processDataWithEcho(:,removeChanIndex)=[];
            processChannelName(removeChanIndex)=[];
            labTestType = 'NA';
            %flag = 1;
        end
        %% used for building healthy data class, need to comment out for health analyzer running.
        
%         save processDataWithEcho processDataWithEcho
%         save processChannelName processChannelName
       
        %% prepare data structure for analysis
        %waitbar(9/10);
        data_struct = struct;
        %             data_struct.whole_header = whole_header_field;
        %             data_struct.version_header = version_info;
        %             data_struct.well_header = well_info;
        data_struct.channel_name = processChannelName;
        data_struct.channel_data = processDataWithEcho;
        data_struct.toolsize = toolsize;
        data_struct.serialNo = serialNo;
        data_struct.datatype = dataType;
        data_struct.labTestType = labTestType;
        data_struct.filename = strrep(datFileName,'.DAT','');
        
        
        
        %******************************************************************
        %******************** End of the file loading *********************
        %******************************************************************
        
        waitbar(10/10);
        close(load_wait)
        save('proVISION_Channel_Data', 'data_struct')
       % h=msgbox('Dump File Loaded.','Success');
       
    else
        h= msgbox('Invalid Dump File.', 'Error','error');
        %flag =0;
    end

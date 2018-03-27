function varargout = EcoScope_HealthAnalyzerBatch(varargin)
%ECOSCOPE_HEALTHANALYZER M-file for EcoScope_HealthAnalyzer.fig
%      ECOSCOPE_HEALTHANALYZER, by itself, creates a new ECOSCOPE_HEALTHANALYZER or raises the existing
%      singleton*.
%
%      H = ECOSCOPE_HEALTHANALYZER returns the handle to a new ECOSCOPE_HEALTHANALYZER or the handle to
%      the existing singleton*.
%
%      ECOSCOPE_HEALTHANALYZER('Property','Value',...) creates a new ECOSCOPE_HEALTHANALYZER using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to EcoScope_HealthAnalyzer_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      ECOSCOPE_HEALTHANALYZER('CALLBACK') and ECOSCOPE_HEALTHANALYZER('CALLBACK',hObject,...) call the
%      local function named CALLBACK in ECOSCOPE_HEALTHANALYZER.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "G  I allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EcoScope_HealthAnalyzer

% Last Modified by GUIDE v2.5 25-Feb-2015 14:24:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @EcoScope_HealthAnalyzerBatch_OpeningFcn, ...
    'gui_OutputFcn',  @EcoScope_HealthAnalyzerBatch_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before EcoScope_HealthAnalyzer is made visible.
function EcoScope_HealthAnalyzerBatch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for EcoScope_HealthAnalyzerBatch
handles.output = hObject;


set(handles.PHM_Analysis,'Enable','on');
%set(handles.PHM_Analysis,'Enable','off');
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes EcoScope_HealthAnalyzer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EcoScope_HealthAnalyzerBatch_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% % --- Executes on button press in Select_File.
% function Select_File_Callback(hObject, eventdata, handles)
% % hObject    handle to Select_File (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% set(handles.PHM_Analysis,'Enable','on');
% set(handles.step2text,'ForegroundColor','k','FontWeight','Normal');
%  %% file to import channel data from .dat file
% % handles.D=load('proVISION_Channel_Data');
% % %handles.D.data_struct
% % % trialD=handles.D.data_struct.POMC;
% % % figure
% % % plot(trialD, 'k-')
% % handles.D.Structname = fieldnames(handles.D.data_struct);
% %var=handles.D.Structname
% % % handles.D = data
% %save('proVISION_Channel_Data');
% % trialD=data.POMC;
% % figure
% % plot(trialD, 'k-')
% %if flag
%     guidata(hObject,handles);
%
% % else
% %     errordlg('Problematic input file with more than 80% casing time!', 'Error');
% %     return;
% % end

% --- Executes on button press in PHM_Analysis.
function totalStatus = Run_Analysis(handles,FileInfo, Info)
%set(handles.PHM_Analysis,'Enable','off');

% if exist('EcoScope_TechlogChannel_Data.mat','file') == 2
%     %% Limits check and anomaly detection function; need to add status words decoding, limits check into this function
%     [storeCSVData]= TechlogDetectionAnalysis(Info);
% else
%     errordlg('Test data cannot be found!', 'Error');
%     return
% end
% %[storeCSVData]= TechlogDetectionAnalysis(files, currentFolder);
% 
% % storing data in key value pair for easy retrieval.
% %preallocate length for key and values
% key = cell(1,length(storeCSVData));
% values = cell(1,length(storeCSVData));
% for k = 1:length(storeCSVData)
%     key{1,k} = storeCSVData{1,k};
% end
% 
% for k = 1:length(storeCSVData)
%     values{1,k} = storeCSVData{2,k};
% end
% %csvFileName = values{1,1};
% dataStruct= load('EcoScope_TechlogChannel_Data');
% csvFileName = dataStruct.data_struct.filename;
% %FileTime = dataStruct.data_struct.filetime;
% %csvFileNameFull = strcat(csvFileName,'_',strrep(strrep(datestr(now),':','_'),' ','_'),'.csv');
% csvFileNameFull = strcat(strrep(csvFileName,'.CSV',''),'_DataAnalytics.xls');
% FileInfo = strsplit(FileInfo,'_');

%storeKeyValueData = containers.Map(key,values);
if exist('EcoScope_TechlogChannel_Data.mat','file') ~= 2
    %% Limits check and anomaly detection function; need to add status words decoding, limits check into this function
 %
    %   [storeCSVData]= TechlogDetectionAnalysis(Info);
%else
    errordlg('Test data cannot be found!', 'Error');
    return
end
%[storeCSVData]= TechlogDetectionAnalysis(files, currentFolder);

% % storing data in key value pair for easy retrieval.
% %preallocate length for key and values
% key = cell(1,length(storeCSVData));
% values = cell(1,length(storeCSVData));
% for k = 1:length(storeCSVData)
%     key{1,k} = storeCSVData{1,k};
% end
% 
% for k = 1:length(storeCSVData)
%     values{1,k} = storeCSVData{2,k};
% end
% csvFileName = values{1,1};
% %csvFileNameFull = strcat(csvFileName,'_',strrep(strrep(datestr(now),':','_'),' ','_'),'.csv');
% %csvFileNameFull = strcat(strrep(csvFileName,'.CSV',''),'_DataAnalytics.xls');
% 
% 
% storeKeyValueData = containers.Map(key,values);

FileInfo = strsplit(FileInfo,'_');
dataStruct= load('EcoScope_TechlogChannel_Data');
csvFileName = dataStruct.data_struct.filename;
%FileTime = dataStruct.data_struct.filetime;

[Handles OutputData] = EcoScope_SubsystemAnalysis(FileInfo,Info,csvFileName);

totalStatus = OutputData;

% xlswrite(csvFileNameFull,storeCSVData,'Analytics');
% %cell2csv(csvFileNameFull,storeCSVData,',');
% %% remove default Sheet 1,2 & 3
% excelFilePath = pwd; % Current working directory.
% sheetName = 'Sheet'; % EN: Sheet, DE: Tabelle, etc. (Lang. dependent)
% 
% % Open Excel file.
% objExcel = actxserver('Excel.Application');
% objExcel.Workbooks.Open(fullfile(excelFilePath, csvFileNameFull)); % Full path is necessary!
% 
% % Delete sheets.
% try
%     % Throws an error if the sheets do not exist.
%     objExcel.ActiveWorkbook.Worksheets.Item([sheetName '1']).Delete;
%     objExcel.ActiveWorkbook.Worksheets.Item([sheetName '2']).Delete;
%     objExcel.ActiveWorkbook.Worksheets.Item([sheetName '3']).Delete;
% catch
%     % Do nothing.
% end
% 
% % Save, close and clean up.
% objExcel.ActiveWorkbook.Save;
% objExcel.ActiveWorkbook.Close;
% objExcel.Quit;
% objExcel.delete;


%% get folder name

folderPathName = getappdata(handles.figure1,'binPathName');
folderName = getappdata(handles.figure1,'folderName');

%fullFolderName = [folderPathName folderName];



%% move result files to the same folder as the chosen .BIN file
if exist(folderName,'dir')==7
    movefile(folderName,folderPathName,'f');
end

files = dir('*.xls');

BatchFile_idx = 0;
for i= 1: length(files)
    if ~isempty(strfind(files(i).name, '_BatchTechlogResults'))
        BatchFile_idx = i;
    end
end
if BatchFile_idx~=0
    files(BatchFile_idx) =[];
end
% %% push to THM server
% % files = dir([folderPathName,'*.csv']);
% DataSenderPath = getenv('ThmData');
% if(~isempty(DataSenderPath))
%     copypath = strcat(DataSenderPath,'\Inbox\');
%     
%     for i = 1: length(files)
%         copyfile(files(i).name,copypath,'f');
%     end
% else % if the thm data sender doesn't exist then this program creates one and backups the file
%     msgbox('You dont have THM Data Sender installed. Please install Toolscope','THM Data Sender Not Found!');
%     programfiles = 'C:\Program Files (x86)\';
%     if(exist(strcat(programfiles,'Schlumberger'),'dir')==0);
%         mkdir(programfiles,'Schlumberger');
%     end
%     if(exist(strcat(programfiles,'Schlumberger\THM'),'dir')==0);
%         mkdir(strcat(programfiles,'Schlumberger'),'THM');
%     end
%     if(exist(strcat(programfiles,'Schlumberger\THM\Data'),'dir')==0);
%         mkdir(strcat(programfiles,'Schlumberger\THM'),'Data');
%     end
%     if(exist(strcat(programfiles,'Schlumberger\THM\Data\Inboxd'),'dir')==0);
%         mkdir(strcat(programfiles,'Schlumberger\THM\Data'),'Inboxd');
%     end
%     
%     setenv('ThmData', 'C:\Program Files (x86)\Schlumberger\THM\Data');
%     DataSenderPath = getenv('ThmData');
%     copypath = strcat(DataSenderPath,'\Inbox\');
%     
%     for i = 1: length(files)
%         copyfile(files(i).name,copypath,'f');
%     end
% end


for i = 1: length(files)
    movefile(files(i).name,folderPathName,'f');
end

% figurefile = dir('*.png');
% for i = 1: length(figurefile)
%     movefile(figurefile(i).name,folderPathName,'f');
% end
close
% set(handles.PHM_Analysis,'Enable','on');


% h = msgbox({'Analysis Completed.','Refer to selected folder for results.'},'Success');
%
%
%
% if exist('*.csv','file') == 2
%         set(handles.PHM_Analysis,'Enable','off');
%
% end
% if exist('proVISION_Channel_Data.mat','file') == 2
%   proVISION_MDCal;
% else
%    errordlg('Test data cannot be found!', 'Error');
%    return
% end


% function Select_Folder_Callback(hObject, eventdata, handles)
% % hObject    handle to Select_Folder (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% currentFolder = uigetdir();
% DATFile = strcat(currentFolder, '\*.*');
% %% find folder name
% 
% %currentFolder = pwd;
% 
% files=dir(DATFile);
% setappdata(handles.figure1,'currentFolder',currentFolder);
% if ~isempty(files)
%     if length(files) > 1  % process the folder
%         idx=strfind(currentFolder,'\');
%         currentFolder(1:idx(end))=[];
%         csvFileName = strcat(currentFolder);
%     else % process one file
%         if ~isempty(strfind(csvFileName,'.BIN'))
%             csvFileName=strrep(strrep(strrep(files.name,'.BIN',''),'.bin',''),' ','_');
%         end
%     end
%     
%     setappdata(handles.figure1,'files',files);
%     setappdata(handles.figure1,'csvFileName',csvFileName);
%     set(handles.PHM_Analysis,'Enable','on');
%     set(handles.step2text,'ForegroundColor','k','FontWeight','Normal');
% else
%     errordlg('NO BIN/CSV file in this folder!', 'Error');
%     return
% end
% guidata(hObject, handles);

% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;



% --- Executes on button press in Select_File.
function PHM_Analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Select_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.PHM_Analysis,'Enable','on');

%delete any previous csv/dat files from conversion folder
%cd('DataConversion');

currentFolder = uigetdir('D:\tooldata\','Select a folder to load');

if ischar(currentFolder)
    
    BINFile = strcat(currentFolder, '\*.BIN');
    CSVFile = strcat(currentFolder, '\*.CSV');
    
    %DATFile = strcat(currentFolder, '\*.BIN');
    binPathName = strcat(currentFolder,'\');
    %% find folder name
    
    %currentFolder = pwd;
    
    files=[dir(BINFile); dir(CSVFile)];
    %setappdata(handles.figure1,'currentFolder',currentFolder);
    if ~isempty(files)
        if length(files) > 1  % process the folder
            idx=strfind(currentFolder,'\');
            currentFolder(1:idx(end))=[];
            csvFileName = strcat(currentFolder);
            
        else % process one file
            if ~isempty(strfind(files.name,'.BIN'))
                csvFileName=strrep(strrep(strrep(files.name,'.BIN',''),'.bin',''),' ','_');
            end
            
            if ~isempty(strfind(files.name,'.CSV'))
                csvFileName=strrep(strrep(strrep(files.name,'.CSV',''),'.csv',''),' ','_');
            end
        end
        
        %     setappdata(handles.figure1,'files',files);
        setappdata(handles.figure1,'csvFileName',csvFileName);
%         if length(files) > 1
%             InitiateXLSFile(handles);
%         end
        %     set(handles.PHM_Analysis,'Enable','on');
        %     set(handles.step2text,'ForegroundColor','k','FontWeight','Normal');
        
        % set(handles.PHM_Analysis,'Enable','off');
        % files = getappdata(handles.figure1,'files');
        %binPathName = strcat(currentFolder,'\');
        
        load_wait = waitbar(0,sprintf('Start batch processing. Please wait...')); % Create the waitbar
        
%         TotalShockCheckData = [];
%         TotalLimitCheckData = [];
%         TotalStatusWordData = [];
%         TotalStatus =  cell(length(files),4);
%         FileNames = cell(length(files),1);
        %% remove .xls file from previous run
        if isdeployed
            
            if exist('TFS_code','dir')~=7
                cd([ctfroot,'\EcoScope_Hea']);
                
            else
                cd([ctfroot,'\TFS_code','\EcoScope']);
            end
            delete('*.xls');
            
            cd(ctfroot);
        else
            delete('*.xls');
        end


        for k = 1:length(files)
            %% clean data from previous file
            if exist('Limit_Check_Data.mat','file')==2
                delete('Limit_Check_Data.mat');
            end
            if exist('Limit_Check_Channel_Data.mat','file')==2
                delete('Limit_Check_Channel_Data.mat');
            end
            if exist('Shock_Check_Data.mat','file')==2
                delete('Shock_Check_Data.mat');
            end
            if exist('Shock_Check_Channel_Data.mat','file')==2
                delete('Shock_Check_Channel_Data.mat');
            end
            if exist('Shock_SubSystem_Check.mat','file')==2
                delete('Shock_SubSystem_Check.mat');
            end
            if exist('Limitcheck_SubSystem_Check.mat','file')==2
                delete('Limitcheck_SubSystem_Check.mat');
            end
            if exist('EcoScope_TechlogChannel_Data.mat','file') == 2
                delete('EcoScope_TechlogChannel_Data.mat');
            end
            
            if exist('StatusWords_Check_Data.mat','file') == 2
                delete('StatusWords_Check_Data.mat');
            end
            
              
                       
            if isdeployed
                
                if exist('TFS_code','dir')~=7
                    cd([ctfroot,'\EcoScope_Hea']);
                    
                else
                    cd([ctfroot,'\TFS_code','\EcoScope']);
                end
                delete('*.csv');
                delete('*.dat');
                %delete('*.xls');
                
                cd(ctfroot);
            else
                delete('*.csv');
                delete('*.dat');
                %delete('*.xls');
            end
            %cd ../;
            
            % Promp the file selection GUI
            
            %[binFileName, binPathName] = uigetfile('*.bin','Select the BIN file to load','MultiSelect','off');
            
            %[datFileName, datPathName] = uigetfile('*.csv','Select the CSV file to load','MultiSelect','off');
            %[dumpRepFileName, dumpRepPathName] = uigetfile('*.dat','Open associated Dump Report','MultiSelect','off');
           
            %% start to process a new file
            binFileName = files(k).name;
            if size(binFileName,2) > 0 && ischar(binPathName),
                
                if ~isempty(regexpi(binFileName, '.BIN'))
                    waitbar((k-1)/length(files)+(1/10)*(1/length(files)));
                    % cd('DataConversion');
                    %%%%%%%
                    %project name for deployed applications gets trucated after 12
                    %characters. We need to take care of it manually here
                    %projectName = 'EcoScope_Hea';
                    if isdeployed
                        
                        %path = ctfroot;
                        %path = [path 'TFS_code\EcoScope\PHMDataFileGeneration.exe'];
                        % path = fullfile(ctfroot,'TFS_code','EcoScope','PHMDataFileGeneration.exe');
                        
                        if exist('TFS_code','dir')~=7
                            cd([ctfroot,'\EcoScope_Hea']);
                            
                        else
                            cd([ctfroot,'\TFS_code','\EcoScope']);
                        end
                        
                        %cd([ctfroot,'\TFS_code','\EcoScope']);
                        %path = [path ' "' binPathName binFileName '" ' cd];
                        %else
                        
                    end
                    %disp(ctfroot);
                    
                    %folder = pwd;
                    
                    %     if exist('PHMDataFileGeneration.exe','file')==2
                    %         disp('Good');
                    %         disp(folder);
                    %
                    %     end
                    %disp(binPathName);
                    
                    %disp(binFileName);
                    
                    path = ['PHMDataFileGeneration.exe' ' "' binPathName binFileName '" ' ' "' cd '"'];
                    
                    % disp(path);
                    waitbar((k-1)/length(files)+(2/10)*(1/length(files)));
                    %%%%%%%
                    % path = ['PHMDataFileGeneration.exe' ' "' binPathName binFileName '" ' cd];
                    system(path);
                    waitbar((k-1)/length(files)+(4/10)*(1/length(files)));
                    
                    %% get converted CSV file
                    file = dir('*.csv');
                    
                    % if no file found then throw error message and return. edit the error
                    % message
                    if isempty(file)
                        errordlg('Unable to process the file. Please make sure you have latest TSDnM configuration file with PHM-ALL timeframe channel group defined. Otherwise, the file may contain invalid tool data.','Process Error');
                        close(load_wait)
                        if isdeployed
                            cd(ctfroot);
                        end
                        return;
                    end
                    fullDataName = [cd '\' file.name];%% file to import channel data from .dat file
                    %datFileName = file.name;
                    %    cd ../
                    FileInfo = file.name;  %% store for GUI purpose
                    datFileName = binFileName; %strrep(strrep(binFileName,'.bin',''),'.BIN','');  %% modified to use original bin file name for results
                   % datFileName = strrep(strrep(datFileName,'.csv',''),'.CSV','');
                    
                    datFileInfo = dir(strcat(binPathName, binFileName));
                    datFileTime = datFileInfo.date;
                    if isdeployed
                        cd(ctfroot);
                    end
                    %waitbar(4/10);
                    % Loop through the file list
                    
                elseif ~isempty(regexpi(binFileName, '.CSV'))
                    fullDataName = strcat(binPathName,binFileName);
                    datFileName = binFileName;
                    FileInfo = binFileName;  %% store for GUI purpose
                else
                    errordlg('Invalid Dump File.', 'Error','error');
                    close(load_wait)
                    return
                end
                
                % for reading .DAT file
                %[channelData,channelName]=LoadDumpData(fullDataName);
                
                % for reading CSV format
                % make sure CSV file doesn't have the fourth row and time is
                % second-based, not 100S
                %    [channelData,text] = xlsread(fullDataName,'');
                %    channelName = text(1,:);
                %    channelName = strrep(channelName,' ', '');
                
                [channelData,channelName] = LoadDumpDataCSV(fullDataName);
                waitbar((k-1)/length(files)+(7/10)*(1/length(files)));
                
                
                %% preprocess steps
                
                %     %% remove  -999.25 Channel value
                %     removeValueIdx=[];
                %     removeChannelIdx = [];
                %     for j = 2: size(channelData,2)
                %
                %         %deal with empty channel column
                %         if mean(channelData(:,j))== -999.25
                %            removeChannelIdx = [removeChannelIdx;j];
                %         else
                %              removeValueIdx =[removeValueIdx; find(channelData(:,j)== -999.25)];
                %         end
                %     end
                %     channelData(:,removeChannelIdx) = []; % remove empty channels
                %     removeValueIdx = unique(removeValueIdx);
                %     channelData(removeValueIdx,:) =[];
                %     channelData(isnan(channelData))= 0; %removing NaN records
                
                %% remove first 5 min after tool start
                %removeTimeIdx=[];
                filterTime = 300; % 2 min or 5 min
                %idx=find(diff(channelData(:,1))>10);
                
                % startTime = channelData(1,1);
                % endTime = startTime + filterTime;
                % if endTime >=channelData(idx(1),1)
                %     removeTimeIdx = [removeTimeIdx 1:idx(1)-1];
                % else
                endIdx = filterTime/2;
                removeTimeIdx = 1:endIdx;
                
                %end
                %removeTimeIdx=unique(removeTimeIdx);
                channelData(removeTimeIdx, :)= [];
                %******************************************************************
                %******************** End of the file loading *********************
                %******************************************************************
                
                %% Environmental Variables Processing before filtering
               % EnvChannelProcess(channelData,channelName);
                %% Filtering only for limits check and anomaly detection
                [ShockSubSystemChecks,shockchecks] = EcoscopeShockChecks(channelData,channelName);
                
                shock_channels = fieldnames(shockchecks);
                shockfilename = repmat({strrep(strrep(datFileName,'.CSV',''),'.BIN','')},length(shock_channels),1);
                totalrecords = length(channelData);
                status = cell(1, length(shock_channels));
                
                for n=1:length(shock_channels)
                    if isfield(shockchecks.(shock_channels{n,1}),'Status') == 1
                        status{n}= shockchecks.(shock_channels{n,1}).Status;
                    else
                        status{n}= 'PASSED';
                    end
                    if isfield(shockchecks.(shock_channels{n,1}),'Condition') == 1
                        condition{n}= shockchecks.(shock_channels{n,1}).Condition;
                    else
                        condition{n}= '';
                    end
                    if isfield(shockchecks.(shock_channels{n,1}),'FailurePercent') == 1
                        failurePercentage{n}= strcat(num2str(shockchecks.(shock_channels{n,1}).FailurePercent,'%.3f'),'%');
                    else
                        failurePercentage{n}= '0.000%';
                    end
                    if isfield(shockchecks.(shock_channels{n,1}),'OutOfRangeTime(min)') == 1
                        timeOverLimit{n} = num2str(shockchecks.(shock_channels{n,1}).OutOfRangeTime,'%.3f');
                    else
                        timeOverLimit{n} = num2str(0,'%.3f');
                    end
                    
                    %         if isfield(shockchecks.(shock_channels{n,1}),'OutOfRangeTime') == 0
                    %             failurePercentage{n}= '0%';
                    %         end
                    %  minimum{n} = num2str(min(shockchecks.(shock_channels{n,1}).data),'%.3f');
                    if isfield(shockchecks.(shock_channels{n,1}),'Maximum') == 1
                        maximum{n} = shockchecks.(shock_channels{n,1}).Maximum;
                    else
                        maximum{n} = num2str(max(shockchecks.(shock_channels{n,1}).data),'%.3f');
                    end
                end
                
                shockCheckData = [shock_channels, status',condition',maximum',timeOverLimit',failurePercentage'];
                shockCheckBatchData = [shockfilename,shock_channels, status',condition',maximum',timeOverLimit',failurePercentage'];
                %TotalShockCheckData = [TotalShockCheckData; shockCheckBatchData];
                clear status condition minimum maximum timeOverLimit failurePercentage
                
                save('Shock_Check_Data','shockCheckData');
                %save ('Shock_Check_Channel_Data','shock_channels');
                save ('Shock_SubSystem_Check','ShockSubSystemChecks');
                clear shockCheckData ShockSubSystemChecks;
                
                channelData = DataFiltering(channelData);
                waitbar((k-1)/length(files)+(9/10)*(1/length(files)));
                
                %******************************************************************
                %******************** Limit Check Calcuations *********************
                %******************************************************************
                [LimitCheckSubSystemChecks,limitchecks,statusWords,SWnames,Info] = EcoScopeLimitChecks(channelData,channelName);
                limitcheck_channels = fieldnames(limitchecks);
                limitfilename = repmat({strrep(strrep(datFileName,'.CSV',''),'.BIN','')},length(limitcheck_channels),1);
                totalrecords = length(channelData);
                for n=1:length(limitcheck_channels)
                    if isfield(limitchecks.(limitcheck_channels{n,1}),'Status') == 1
                        status{n}= limitchecks.(limitcheck_channels{n,1}).Status;
                    else
                        status{n}= 'PASSED';
                    end
                    if isfield(limitchecks.(limitcheck_channels{n,1}),'Condition') == 1
                        condition{n}= limitchecks.(limitcheck_channels{n,1}).Condition;
                    else
                        condition{n}= '';
                    end
                    if isfield(limitchecks.(limitcheck_channels{n,1}),'FailurePercent') == 1
                        if strcmp(num2str(limitchecks.(limitcheck_channels{n,1}).FailurePercent),'N/A')
                            failurePercentage{n} = 'N/A';
                        else
                        failurePercentage{n}= strcat(num2str(limitchecks.(limitcheck_channels{n,1}).FailurePercent,'%.3f'),'%');
                        end
                    else
                        failurePercentage{n}= '0.000%';
                    end
                    if isfield(limitchecks.(limitcheck_channels{n,1}),'Minimum') == 1
                        minimum{n} = num2str(limitchecks.(limitcheck_channels{n,1}).Minimum,'%.3f');
                    else
                        minimum{n} = num2str(min(limitchecks.(limitcheck_channels{n,1}).data),'%.3f');
                    end
                    if isfield(limitchecks.(limitcheck_channels{n,1}),'Maximum') == 1
                        maximum{n} = num2str(limitchecks.(limitcheck_channels{n,1}).Maximum,'%.3f');
                    else
                        maximum{n} = num2str(max(limitchecks.(limitcheck_channels{n,1}).data),'%.3f');
                    end
                    if isfield(limitchecks.(limitcheck_channels{n,1}),'OutOfRangeCount') == 1
                        outagecount{n} = num2str(limitchecks.(limitcheck_channels{n,1}).OutOfRangeCount, '%d');
                    else
                        outagecount{n} = '0';
                    end
                    
                    if isfield(limitchecks.(limitcheck_channels{n,1}),'OutageTime') == 1
                        outageTime{n}= num2str(limitchecks.(limitcheck_channels{n,1}).OutageTime(1),'%d');
                        
                    else
                        outageTime{n}= ' ';
                    end
                    
                end
                
                limitCheckData = [limitcheck_channels, status',condition',minimum',maximum',failurePercentage', outagecount', outageTime'];
                limitCheckBatchData = [limitfilename,limitcheck_channels, status',condition',minimum',maximum',failurePercentage',outagecount', outageTime'];
                
                %TotalLimitCheckData = [TotalLimitCheckData;limitCheckBatchData];
                
                clear status condition minimum maximum failurePercentage outagecount outageTime;
                save('Limit_Check_Data','limitCheckData');
                % save ('Limit_Check_Channel_Data','limitcheck_channels');
                save ('Limitcheck_SubSystem_Check','LimitCheckSubSystemChecks');
                clear limitCheckData LimitCheckSubSystemChecks;
                
                %******************************************************************
                %******************** End of Limit Check Calcuations *********************
                %******************************************************************
                
                
                %******************************************************************
                %******************** Status words Calcuations *********************
                %******************************************************************
                statusWords_channels = fieldnames(statusWords);
                
                for n=1:length(statusWords_channels)
                    for j = 1: length(SWnames)
                        kk = (n-1)* length(SWnames)+j;
                        names{kk} = strcat(statusWords_channels{n,1},'_',SWnames{j});
                        if isfield(statusWords.(statusWords_channels{n,1}).(SWnames{j}),'Status') == 1
                            status{kk}= statusWords.(statusWords_channels{n,1}).(SWnames{j}).Status;
                        else
                            status{kk}= 'PASSED';
                        end
                        if isfield(statusWords.(statusWords_channels{n,1}).(SWnames{j}),'Condition') == 1
                            condition{kk}= statusWords.(statusWords_channels{n,1}).(SWnames{j}).Condition;
                        else
                            condition{kk}= '';
                        end
                        if isfield(statusWords.(statusWords_channels{n,1}).(SWnames{j}),'Description') == 1
                            description{kk}= statusWords.(statusWords_channels{n,1}).(SWnames{j}).Description;
                        else
                            description{kk}= '';
                        end
                        if isfield(statusWords.(statusWords_channels{n,1}).(SWnames{j}),'Activation') == 1
                            activationPercentage{kk}= strcat(num2str(statusWords.(statusWords_channels{n,1}).(SWnames{j}).Activation,'%.3f'),'%');
                        else
                            activationPercentage{kk}= '0.000%';
                        end
                        if isfield(statusWords.(statusWords_channels{n,1}).(SWnames{j}),'OutageTime') == 1
                            outageTime{kk}= num2str(statusWords.(statusWords_channels{n,1}).(SWnames{j}).OutageTime(1),'%d');
                            
                        else
                            outageTime{kk}= ' ';
                        end
                        %             minimum{n} = num2str(min(limitchecks.(limitcheck_channels{n,1}).data),'%.3f');
                        %             maximum{n} = num2str(max(limitchecks.(limitcheck_channels{n,1}).data),'%.3f');
                    end
                end
                statusWordsfilename = repmat({strrep(strrep(datFileName,'.CSV',''),'.BIN','')},length(names),1);
                statusWordsCheckData = [names',status',description',condition',activationPercentage',outageTime'];
                statusWordsCheckBatchData = [statusWordsfilename,names',status',description',condition',activationPercentage',outageTime'];
                %TotalStatusWordData = [TotalStatusWordData; statusWordsCheckBatchData];
                save('StatusWords_Check_Data','statusWordsCheckData');
                clear names status description condition activationPercentage statusWordsCheckData outageTime;
                
                
                
                % waitbar(9/10);
                %% prepare data structure for analysis
                
                data_struct = struct;
                %             data_struct.whole_header = whole_header_field;
                %             data_struct.version_header = version_info;
                %             data_struct.well_header = well_info;
                data_struct.channel_name = channelName;
                data_struct.channel_data = channelData;
                %data_struct.serialNo = serialNo;
                data_struct.filename =  datFileName; %strrep(datFileName,'.CSV','');
 %               data_struct.filetime = datFileTime;
                setappdata(handles.figure1,'binPathName',binPathName);
                setappdata(handles.figure1,'folderName',data_struct.filename);
                
                waitbar(k/length(files));
                %close(load_wait)
                save('EcoScope_TechlogChannel_Data', 'data_struct')
                validfile=1;
            else
                h= errordlg('Invalid Dump File.', 'Error','error');
                validfile =0;
                
            end
            if exist('EcoScope_TechlogChannel_Data.mat','file') == 2
                %set(handles.PHM_Analysis,'Enable','on');
                %    set(handles.step2text,'ForegroundColor','k','FontWeight','Normal');
                % cd('DataConversion');
                if isdeployed
                    %cd([ctfroot,'\TFS_code','\EcoScope']);
                    %cd([ctfroot,'\EcoScope_Hea']);
                    if exist('TFS_code','dir')~=7
                        cd([ctfroot,'\EcoScope_Hea']);
                        
                    else
                        cd([ctfroot,'\TFS_code','\EcoScope']);
                    end
                    delete('*.csv');
                    delete('*.dat');
                    
                    cd(ctfroot);
                else
                    delete('*.csv');
                    delete('*.dat');
                end
                % cd ../;
                if validfile==1  %|| ~isdeployed
                    totalStatus = Run_Analysis(handles,FileInfo, Info);%run analysis
                    %TotalStatus(k,:) = totalStatus;
                    FileNames= strrep(strrep(datFileName,'.CSV',''),'.BIN','');
                    %% update excel output files
                    if length(files) > 1
                        
                        GenerateXLSResults(handles,k, length(files),FileNames, totalStatus, shockCheckBatchData,limitCheckBatchData,statusWordsCheckBatchData);
                    end
                end
            end
            if exist('Limit_Check_Data.mat','file')==2
                delete('Limit_Check_Data.mat');
            end
            if exist('Limit_Check_Channel_Data.mat','file')==2
                delete('Limit_Check_Channel_Data.mat');
            end
            if exist('Shock_Check_Data.mat','file')==2
                delete('Shock_Check_Data.mat');
            end
            if exist('Shock_Check_Channel_Data.mat','file')==2
                delete('Shock_Check_Channel_Data.mat');
            end
            if exist('Shock_SubSystem_Check.mat','file')==2
                delete('Shock_SubSystem_Check.mat');
            end
            if exist('Limitcheck_SubSystem_Check.mat','file')==2
                delete('Limitcheck_SubSystem_Check.mat');
            end
            if exist('EcoScope_TechlogChannel_Data.mat','file') == 2
                delete('EcoScope_TechlogChannel_Data.mat');
            end
            if exist('StatusWords_Check_Data.mat','file') == 2
                delete('StatusWords_Check_Data.mat');
            end
        end
        close(load_wait)
        
        %% get folder name
        
        folderPathName = getappdata(handles.figure1,'binPathName');
        %folderName = getappdata(handles.figure1,'folderName');
        
        %fullFolderName = [folderPathName folderName];
        
                
%% move batch processing result xls
        files = dir('*.xls');
        for i = 1: length(files)
            movefile(files(i).name,folderPathName,'f');
        end
        
        set(handles.PHM_Analysis,'Enable','on');
        h = msgbox({'Analysis Completed.','Refer to selected folder for results.'},'Success');
    else
        errordlg('NO BIN/CSV file in this folder!', 'Error');
        return
    end
else
    %h= errordlg('Invalid File Folder.', 'Error','error');
    validfile =0;
    
end
guidata(hObject, handles);



function GenerateXLSResults(handles,fileNo, totalFiles, fileNames, totalStatus, shockCheckData,limitCheckData,statusWordData)

%% generate XLS file to store results
%TechlogResultfilename = getappdata(handles.figure1,'SummaryXLSFileName');
%% generate XLS file to store results
csvFileName = getappdata(handles.figure1,'csvFileName');
TechlogResultfilename = strcat(csvFileName,'_BatchTechlogResults.xls');

totalStatusHeader = {'File Name', 'Overall Status', 'Limit Checks', 'Environmental', 'Status Words'};

limitcheckheader = {'File Name', 'Channel Name','Status','Condition','Minimum','Maximum','Outage %','Outage Counts', 'Outage Time (Sec)'};

Environmentalheader = {'File Name', 'Channel Name','Status','Condition','Maximum','Time Over Limit (min)','Outage %'};

StatusWordsheader = {'File Name','Channel Name','Status','Description','Condition','Activation %', 'Outage Time (Sec)'};


totalStatus = [fileNames totalStatus];
%overallCheck = vertcat(totalStatusHeader, totalStatus);
%% opens the activex server and checks to see if the file already exists (creates if it doesnt):
excelFilePath = pwd; % Current working directory.
Excel = actxserver ('Excel.Application');
File=fullfile(excelFilePath, TechlogResultfilename);
if ~exist(TechlogResultfilename,'file')
    ExcelWorkbook = Excel.workbooks.Add;
    ExcelWorkbook.SaveAs(File,1);
    ExcelWorkbook.Close(false);
end
invoke(Excel.Workbooks,'Open',File);

%% Append data
warning('off','MATLAB:xlswrite:AddSheet')

offset_overall = 2+(fileNo-1)*1;
range = ['A', num2str(offset_overall)];

offset_limit = 2+(fileNo-1)*length(limitCheckData);
range_limit = ['A',num2str(offset_limit)];

offset_env = 2+(fileNo-1)*length(shockCheckData);
range_env = ['A',num2str(offset_env)];

offset_stat = 2+(fileNo-1)*length(statusWordData);
range_stat = ['A',num2str(offset_stat)];

if fileNo ==1
    
    %% first time, fill header information & results
    xlswrite1(File,totalStatusHeader,'OverallResults','A1');
    xlswrite1(File,limitcheckheader,'LimitChecks','A1');
    xlswrite1(File,Environmentalheader,'Environmental','A1');
    xlswrite1(File,StatusWordsheader,'StatusWords','A1');
    
    xlswrite1(File,totalStatus,'OverallResults',range);
    xlswrite1(File,limitCheckData,'LimitChecks',range_limit);
    xlswrite1(File,shockCheckData,'Environmental',range_env);
    xlswrite1(File,statusWordData,'StatusWords',range_stat);
else
    xlswrite1(File,totalStatus,'OverallResults',range);
    xlswrite1(File,limitCheckData,'LimitChecks',range_limit);
    xlswrite1(File,shockCheckData,'Environmental',range_env);
    xlswrite1(File,statusWordData,'StatusWords',range_stat);
end
%limitcheckfiledata = vertcat(limitcheckheader,limitCheckData);
%limitcheckfilename = strcat(filename{1}(1:end-5),'_Limitchecks.CSV');
%cell2csv(limitcheckfilename,limitcheckfiledata);

%% remove empty sheets when all files are processed
if fileNo == totalFiles
    
DeleteEmptyExcelSheets(Excel);
end
%environmentalfiledata = vertcat(Environmentalheader,shockCheckData);
%environmentalfilename = strcat(filename{1}(1:end-5),'_Environmental.CSV');
%cell2csv(environmentalfilename,environmentalfiledata);

%statuswordfiledata = vertcat(StatusWordsheader,statusWordData);


%% close the activex server
Excel.ActiveWorkbook.Save;
        
Excel.ActiveWorkbook.Close;
        
Excel.Quit;
        
Excel.delete;

clear Excel




function varargout = EcoScope_SubsystemAnalysis(varargin)
%ECOSCOPE_SUBSYSTEMANALYSIS M-file for EcoScope_SubsystemAnalysis.fig
%      ECOSCOPE_SUBSYSTEMANALYSIS, by itself, creates a new ECOSCOPE_SUBSYSTEMANALYSIS or raises the existing
%      singleton*.
%
%      H = ECOSCOPE_SUBSYSTEMANALYSIS returns the handle to a new ECOSCOPE_SUBSYSTEMANALYSIS or the handle to
%      the existing singleton*.
%
%      ECOSCOPE_SUBSYSTEMANALYSIS('Property','Value',...) creates a new ECOSCOPE_SUBSYSTEMANALYSIS using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to EcoScope_SubsystemAnalysis_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      ECOSCOPE_SUBSYSTEMANALYSIS('CALLBACK') and ECOSCOPE_SUBSYSTEMANALYSIS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in ECOSCOPE_SUBSYSTEMANALYSIS.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EcoScope_SubsystemAnalysis

% Last Modified by GUIDE v2.5 19-Jan-2015 17:54:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EcoScope_SubsystemAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @EcoScope_SubsystemAnalysis_OutputFcn, ...
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


% --- Executes just before EcoScope_SubsystemAnalysis is made visible.
function EcoScope_SubsystemAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)


limitcheckdata = load('Limit_Check_Data');
%limitchanneldata =  load('Limit_Check_Channel_Data');
shockcheckdata = load('Shock_Check_Data');
%shockchanneldata = load('Shock_Check_Channel_Data');
shocksubsystem = load ('Shock_SubSystem_Check');
limitsubsystem = load ('Limitcheck_SubSystem_Check');

statusWordsCheckData =  load('StatusWords_Check_Data');


%limitscsvdata = horzcat(limitchanneldata.limitcheck_channels ,limitcheckdata.limitCheckData);
%envcsvdata = horzcat(shockchanneldata.shock_channels ,shockcheckdata.shockCheckData);

limitStatus = limitcheckdata.limitCheckData(:,2);
shockStatus = shockcheckdata.shockCheckData(:,2);
statusword = statusWordsCheckData.statusWordsCheckData(:,2);

if ~isempty(find(strcmp(limitStatus,'FAILED'),1))
    limitTotalStatus = 'FAILED';
elseif ~isempty(find(strcmp(limitStatus,'WARNING'), 1))
    limitTotalStatus = 'WARNING';
else 
    limitTotalStatus = 'PASSED';
end

if ~isempty(find(strcmp(shockStatus,'FAILED'), 1))
    shockTotalStatus = 'FAILED';
elseif ~isempty(find(strcmp(shockStatus,'WARNING'), 1))
    shockTotalStatus = 'WARNING';
else 
    shockTotalStatus = 'PASSED';
end
    
if ~isempty(find(strcmp(statusword,'FAILED'), 1))
    statuswordTotal = 'FAILED';
elseif ~isempty(find(strcmp(statusword,'WARNING'), 1))
    statuswordTotal = 'WARNING';
else 
    statuswordTotal = 'PASSED';
end



if isfield(shocksubsystem.ShockSubSystemChecks  ,'ShockVibrationStatus') == 1
    if strcmp(shocksubsystem.ShockSubSystemChecks.ShockVibrationStatus, 'WARNING')
        
        set(handles.svStatus,'String',shocksubsystem.ShockSubSystemChecks.ShockVibrationStatus,'ForegroundColor',[1 .5 0],'FontWeight','bold');
    else
        set(handles.svStatus,'String',shocksubsystem.ShockSubSystemChecks.ShockVibrationStatus,'ForegroundColor','r','FontWeight','bold');
    end
    %set(handles.status,'String','NoGO','ForegroundColor','k','BackgroundColor','r','FontWeight','bold');
else
    set(handles.svStatus,'String','PASSED','ForegroundColor','k','FontWeight','bold');
end

if isfield(limitsubsystem.LimitCheckSubSystemChecks  ,'PowerStatus') == 1
    if strcmp(limitsubsystem.LimitCheckSubSystemChecks.PowerStatus, 'WARNING')
        set(handles.powerStatus,'String',limitsubsystem.LimitCheckSubSystemChecks.PowerStatus,'ForegroundColor',[1 .5 0],'FontWeight','bold');
    else
        set(handles.powerStatus,'String',limitsubsystem.LimitCheckSubSystemChecks.PowerStatus,'ForegroundColor','r','FontWeight','bold');
    end
    %set(handles.status,'String','NoGO','ForegroundColor','k', 'BackgroundColor','r','FontWeight','bold');
else
    set(handles.powerStatus,'String','PASSED','ForegroundColor','k','FontWeight','bold');
end

if isfield(limitsubsystem.LimitCheckSubSystemChecks  ,'TPHealthStatus') == 1
    if strcmp(limitsubsystem.LimitCheckSubSystemChecks.TPHealthStatus,'WARNING')
        set(handles.tpStatus,'String',limitsubsystem.LimitCheckSubSystemChecks.TPHealthStatus,'ForegroundColor',[1 .5 0],'FontWeight','bold');
    else
        set(handles.tpStatus,'String',limitsubsystem.LimitCheckSubSystemChecks.TPHealthStatus,'ForegroundColor','r','FontWeight','bold');
    end
    %set(handles.status,'String','NoGO','ForegroundColor','k', 'BackgroundColor','r','FontWeight','bold');
else
    set(handles.tpStatus,'String','PASSED','ForegroundColor','k','FontWeight','bold');
end



Info = varargin{2};

if isfield(limitsubsystem.LimitCheckSubSystemChecks  ,'PNGStatus') == 1
    if strcmp(limitsubsystem.LimitCheckSubSystemChecks.PNGStatus, 'WARNING')
        set(handles.pngStatus,'String',limitsubsystem.LimitCheckSubSystemChecks.PNGStatus,'ForegroundColor',[1 .5 0],'FontWeight','bold');
    else
        set(handles.pngStatus,'String',limitsubsystem.LimitCheckSubSystemChecks.PNGStatus,'ForegroundColor','r','FontWeight','bold');
        %set(handles.status,'String','NoGO','ForegroundColor','k', 'BackgroundColor','r','FontWeight','bold');
    end
elseif Info.PNGOff==1
    set(handles.pngStatus,'String','PNG never ON','ForegroundColor',[1 .5 0],'FontWeight','bold');
    %set(handles.status,'String','PASSED','ForegroundColor','k','BackgroundColor','g','FontWeight','bold');
    
    %set(handles.status,'String','PNG never ON','ForegroundColor',[1 .5 0],'FontWeight','bold');
else
    set(handles.pngStatus,'String','PASSED','ForegroundColor','k','FontWeight','bold');
end
% if (~isempty(fieldnames(limitsubsystem.LimitCheckSubSystemChecks)) ||...
%  ~isempty(fieldnames(shocksubsystem.ShockSubSystemChecks)))
% set(handles.status,'String','NoGO','ForegroundColor','k','BackgroundColor','r','FontWeight','bold');
% else
% 
% end

rowNames = statusWordsCheckData.statusWordsCheckData(:,1);
statusData = statusWordsCheckData.statusWordsCheckData(:,2:end);

if ~isempty(find(strcmp(statusData(:,1), 'FAILED'), 1))
   set(handles.statWordStatus,'String','FAILED','ForegroundColor','r','FontWeight','bold');
elseif ~isempty(find(strcmp(statusData(:,1), 'WARNING'), 1))
   set(handles.statWordStatus,'String','WARNING','ForegroundColor',[1 .5 0],'FontWeight','bold');
else
   set(handles.statWordStatus,'String','PASSED','ForegroundColor','k','FontWeight','bold'); 
end       

for n=1:length(statusData)
    if strcmp(statusData{n,1},'FAILED')== 1
        statusData{n,1} = strcat(...
    '<html><span style="color: #FF0000; font-weight: bold;">', ...
    statusData{n,1}, ...
    '</span></html>');
   elseif strcmp( statusData{n,1},'WARNING')== 1
         statusData{n,1}= strcat(...
    '<html><span style="color: #FFA500; font-weight: bold;">', ...
     statusData{n,1}, ...
    '</span></html>');
    end
    
end

pass_idx = find(strcmp(statusData(:,1),'PASSED'));

statusData(pass_idx,:)=[];
rowNames(pass_idx,:)=[];

if strcmp(handles.svStatus.String,'FAILED') || strcmp(handles.powerStatus.String,'FAILED') || strcmp(handles.tpStatus.String,'FAILED') || strcmp(handles.pngStatus.String,'FAILED')|| strcmp(handles.statWordStatus.String,'FAILED')
    set(handles.status,'String','NoGO','ForegroundColor','k', 'BackgroundColor','r','FontWeight','bold');
elseif strcmp(limitTotalStatus,'FAILED')&& ~strcmp(handles.pngStatus.String,'PNG never ON')
    set(handles.status,'String','NoGO','ForegroundColor','k', 'BackgroundColor','r','FontWeight','bold');
elseif strcmp(limitTotalStatus,'FAILED')&& strcmp(handles.pngStatus.String,'PNG never ON')
    set(handles.status,'String','PASSED','ForegroundColor','k','BackgroundColor','g','FontWeight','bold');    
    limitTotalStatus = 'FAILED(PNG never ON)';
else
    set(handles.status,'String','PASSED','ForegroundColor','k','BackgroundColor','g','FontWeight','bold');
end



% if strcmp(handles.svStatus.String,'PASSED') && strcmp(handles.powerStatus.String,'PASSED') && strcmp(handles.tpStatus.String,'PASSED') && strcmp(handles.pngStatus.String,'PASSED')
%     
%     set(handles.status,'String','PASSED','ForegroundColor','k','BackgroundColor','g','FontWeight','bold');
%     
% elseif strcmp(handles.svStatus.String,'PASSED') && strcmp(handles.powerStatus.String,'PASSED') && strcmp(handles.tpStatus.String,'PASSED') && strcmp(handles.pngStatus.String,'PNG never ON')
%     
%     set(handles.status,'String','PASSED','ForegroundColor','k','BackgroundColor','g','FontWeight','bold');
% else
%     set(handles.status,'String','NoGO','ForegroundColor','k', 'BackgroundColor','r','FontWeight','bold');
%     
% end



totalStatus = {handles.status.String limitTotalStatus shockTotalStatus statuswordTotal};
% Choose default command line output for EcoScope_SubsystemAnalysis
handles.output = hObject;
handles.totalstatus = totalStatus;

%resultData = varargin{1};
FileInfo = varargin{1};
csvFileName = varargin{3};

% Update handles structure
Year = FileInfo{2}(1:4);
Month = FileInfo{2}(5:6);
Date = FileInfo{2}(7:8);
Hours = FileInfo{2}(9:10);
Min = FileInfo{2}(11:12);
Sec = FileInfo{2}(13:14);

%% generate XLS file to store results

TechlogResultfilename = strcat(strrep(strrep(strrep(csvFileName,'.CSV',''),'.BIN',''),'.bin',''),'_TechlogResults.xls');
excelFilePath = pwd; % Current working directory.

Excel = actxserver ('Excel.Application');
File=fullfile(excelFilePath, TechlogResultfilename);
if ~exist(TechlogResultfilename,'file')
    ExcelWorkbook = Excel.workbooks.Add;
    ExcelWorkbook.SaveAs(File,1);
    ExcelWorkbook.Close(false);
end
invoke(Excel.Workbooks,'Open',File);


limitcheckheader = {'Channel Name','Status','Condition','Minimum','Maximum','Outage %','Outage Counts','Outage Time (Sec)'};
limitcheckfiledata = vertcat(limitcheckheader,limitcheckdata.limitCheckData);
%limitcheckfilename = strcat(filename{1}(1:end-5),'_Limitchecks.CSV');
%cell2csv(limitcheckfilename,limitcheckfiledata);
warning('off','MATLAB:xlswrite:AddSheet')
%xlswrite(TechlogResultfilename,limitcheckfiledata,'LimitChecks');



Environmentalheader = {'Channel Name','Status','Condition','Maximum','Time Over Limit (min)','Outage %'};
environmentalfiledata = vertcat(Environmentalheader,shockcheckdata.shockCheckData);
%environmentalfilename = strcat(filename{1}(1:end-5),'_Environmental.CSV');
%cell2csv(environmentalfilename,environmentalfiledata);
%xlswrite(TechlogResultfilename,environmentalfiledata,'Environmental');

StatusWordsheader = {'Channel Name','Status','Description','Condition','Activation %', 'Outage Time (Sec)'};
statuswordfiledata = vertcat(StatusWordsheader,statusWordsCheckData.statusWordsCheckData);
%xlswrite(TechlogResultfilename,statuswordfiledata,'StatusWords');

totalStatusHeader = {'File Name', 'Overall Status', 'Limit Checks', 'Environmental', 'Status Words'};
totalStatus = [strrep(strrep(csvFileName,'.CSV',''),'.BIN','') totalStatus];
totalStatusfiledata = vertcat(totalStatusHeader,totalStatus);

%% first time, fill header information & results
xlswrite1(File,totalStatusfiledata,'OverallResults','A1');
xlswrite1(File,limitcheckfiledata,'LimitChecks','A1');
xlswrite1(File,environmentalfiledata,'Environmental','A1');
xlswrite1(File,statuswordfiledata,'StatusWords','A1');

DeleteEmptyExcelSheets(Excel);

%% close the activex server
Excel.ActiveWorkbook.Save;

Excel.ActiveWorkbook.Close;

Excel.Quit;

Excel.delete;

clear Excel




%% for GUI display
for n=1:length(shockcheckdata.shockCheckData)
    if strcmp(shockcheckdata.shockCheckData{n,2},'WARNING')== 1
        shockcheckdata.shockCheckData{n,2} = strcat(...
    '<html><span style="color: #FFA500; font-weight: bold;">', ...
    shockcheckdata.shockCheckData{n,2}, ...
    '</span></html>');
    end
end

for n=1:length(limitcheckdata.limitCheckData)
    if strcmp(limitcheckdata.limitCheckData{n,2},'FAILED')== 1
        limitcheckdata.limitCheckData{n,2} = strcat(...
    '<html><span style="color: #FF0000; font-weight: bold;">', ...
    limitcheckdata.limitCheckData{n,2}, ...
    '</span></html>');
    elseif strcmp(limitcheckdata.limitCheckData{n,2},'WARNING')== 1
        limitcheckdata.limitCheckData{n,2} = strcat(...
    '<html><span style="color: #FFA500; font-weight: bold;">', ...
    limitcheckdata.limitCheckData{n,2}, ...
    '</span></html>');
    end
end





% if length(FileInfo)==5
%  filename = strcat(FileInfo(1),'_',FileInfo(2),'_',FileInfo(3),'_',FileInfo(4),'_',FileInfo(5));
% else

% filename = FileInfo(1);
%     for i=2:length(FileInfo)
%         filename = strcat(filename,FileInfo(i),'_');
%     end
% end
datestring = [Year '-' Month '-' Date ' ' Hours ':' Min ':' Sec];

datetime = datestr(datenum(datestring),0);

set(handles.txtJobNumber,'String',FileInfo{1});
set(handles.txtJobDate,'String',datetime);
set(handles.txtFileName,'String',csvFileName);
%set(handles.txtFileDate,'String',varargin{4});

if length(FileInfo)==5
 set(handles.txtToolSerialNo,'String',FileInfo{4});
else
  set(handles.txtToolSerialNo,'String','');  
end
set(handles.limitchecktable,'data',limitcheckdata.limitCheckData(:,2:end-1),'RowName',limitcheckdata.limitCheckData(:,1),'ColumnName',{'Status','Condition','Minimum','Maximum','Outage %','Outage Counts'});
set(handles.svtable,'data',shockcheckdata.shockCheckData(:, 2:end),'RowName',shockcheckdata.shockCheckData(:, 1),'ColumnName',{'Status','Condition','Maximum','Time Over Limit (min)','Outage %'});

set(handles.statuswordtable,'data',statusData(:,1:end-1),'RowName',rowNames,'ColumnName',{'Status','Description','Condition','Activation %'});



% %% remove default Sheet 1,2 & 3
% excelFilePath = pwd; % Current working directory.
%
% sheetName = 'Sheet'; % EN: Sheet, DE: Tabelle, etc. (Lang. dependent)
%
% % Open Excel file.
%
% objExcel = actxserver('Excel.Application');
%
% objExcel.Workbooks.Open(fullfile(excelFilePath, TechlogResultfilename)); % Full path is necessary!
%
% % Delete sheets.
%
% try
%
%       % Throws an error if the sheets do not exist.
%
%       objExcel.ActiveWorkbook.Worksheets.Item([sheetName '1']).Delete;
%
%       objExcel.ActiveWorkbook.Worksheets.Item([sheetName '2']).Delete;
%
%       objExcel.ActiveWorkbook.Worksheets.Item([sheetName '3']).Delete;
%
% catch
%
%        % Do nothing.
%
% end
%
% % Save, close and clean up.
%
% objExcel.ActiveWorkbook.Save;
%
% objExcel.ActiveWorkbook.Close;
%
% objExcel.Quit;
%
% objExcel.delete;

%outputFilename = strcat(strrep(csvFileName,'.CSV',''),'_TechlogResults');
%print(hObject, '-dpng', outputFilename);
guidata(hObject, handles);


% UIWAIT makes EcoScope_SubsystemAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EcoScope_SubsystemAnalysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.totalstatus;


% --- Executes on button press in Back_Menu.
function Back_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Back_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close_Callback;

function close_Callback(hObject, eventdata, handles)

close;


% --- Executes on button press in Save_Result.
function Save_Result_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName, PathName] = uiputfile('*.bmp;*.png;*.jpg;*.tif','Save As'); %# <-- dot
if PathName==0, return;
else
    Name = fullfile(PathName,FileName);  %# <--- reverse the order of arguments
    %saveas(handles.MD_Evaluation_fig, Name)
    if ~isempty(strfind(Name, '.bmp'))
        hgexport(handles.EcoScope_SubSystemAnalysis, Name, hgexport('factorystyle'), 'Format', 'bmp');
    elseif ~isempty(strfind(Name, '.png'))
        hgexport(handles.EcoScope_SubSystemAnalysis, Name, hgexport('factorystyle'), 'Format', 'png');
    elseif ~isempty(strfind(Name, '.jpg'))
        hgexport(handles.EcoScope_SubSystemAnalysis, Name, hgexport('factorystyle'), 'Format', 'jpeg');
    elseif ~isempty(strfind(Name, '.tif'))
        hgexport(handles.EcoScope_SubSystemAnalysis, Name, hgexport('factorystyle'), 'Format', 'tiff');
    else
        warndlg('Unacceptable File Format','Warning');
    end
end


% --- Executes on button press in statusword.
function statusword_Callback(hObject, eventdata, handles)
% hObject    handle to statusword (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DisplayStatusWords()

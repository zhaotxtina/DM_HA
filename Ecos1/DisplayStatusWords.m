function varargout = DisplayStatusWords(varargin)
% DISPLAYSTATUSWORDS MATLAB code for DisplayStatusWords.fig
%      DISPLAYSTATUSWORDS, by itself, creates a new DISPLAYSTATUSWORDS or raises the existing
%      singleton*.
%
%      H = DISPLAYSTATUSWORDS returns the handle to a new DISPLAYSTATUSWORDS or the handle to
%      the existing singleton*.
%
%      DISPLAYSTATUSWORDS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAYSTATUSWORDS.M with the given input arguments.
%
%      DISPLAYSTATUSWORDS('Property','Value',...) creates a new DISPLAYSTATUSWORDS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DisplayStatusWords_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DisplayStatusWords_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DisplayStatusWords

% Last Modified by GUIDE v2.5 10-Feb-2015 13:19:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DisplayStatusWords_OpeningFcn, ...
                   'gui_OutputFcn',  @DisplayStatusWords_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before DisplayStatusWords is made visible.
function DisplayStatusWords_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DisplayStatusWords (see VARARGIN)

% Choose default command line output for DisplayStatusWords

statusWordsCheckData =  load('StatusWords_Check_Data');
handles.output = hObject;
rowNames = statusWordsCheckData.statusWordsCheckData(:,1);
data = statusWordsCheckData.statusWordsCheckData(:,2:end);

for n=1:length(data)
    if strcmp(data{n,1},'FAILED')== 1
        data{n,1} = strcat(...
    '<html><span style="color: #FF0000; font-weight: bold;">', ...
    data{n,1}, ...
    '</span></html>');
    elseif strcmp( data{n,1},'WARNING')== 1
         data{n,1}= strcat(...
    '<html><span style="color: #FFA500; font-weight: bold;">', ...
     data{n,1}, ...
    '</span></html>');
    end
end

set(handles.statuswordtable,'data',data,'RowName',rowNames,'ColumnName',{'Description','Status','Condition','Activation %'});
%set(handles.svtable,'data',shockcheckdata.shockCheckData,'RowName',shockchanneldata.shock_channels,'ColumnName',{'Status','Condition','Minimum','Maximum','Time Over Limit (min)','Outage %'});


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DisplayStatusWords wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DisplayStatusWords_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in closebutton.
function closebutton_Callback(hObject, eventdata, handles)
% hObject    handle to closebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

%S&V formats limit checks
%SHKX, SHKZ,SHKR can't be over 100G for 30 min (1800 sec)
function [LimitCheckSubSystemChecks, LimitChecks,StatusWords,SWnames,Info] = EcoScopeLimitChecks(channeldata, channelname)

TotalRecords = length(channeldata);

%Status Words techlog channels
StatusChannelName = load('StatusFormatsChannel');
SWChannelName = StatusChannelName.channelName;


[StatusWords,SWnames]=EcoScopeStatusWordsCheck(channeldata, channelname,SWChannelName);

timeData = channeldata(:,1);

LimitCheckSubSystemChecks = struct;

PSSW.OffIndex = find(StatusWords.PSSW.data ~= 51399 );% when not firing
PSSW.OnIndex = find(StatusWords.PSSW.data == 51399 );% when firing
Info.PNGOff = 0;
if isempty(PSSW.OnIndex) %|| (size(channeldata,2)~=199)
    Info.PNGOff = 1;
end

filterPNGTime = 300; % 2 min or 5 min
skipNo = filterPNGTime/2;

PSSWOnFilterIdx = PNGOnOffFiltering(PSSW.OnIndex,skipNo);
PSSWOffFilterIdx = PNGOnOffFiltering(PSSW.OffIndex,skipNo);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%LIMIT CHECK CALCULATIONS%%%%%%%%%

%% Temperature and Pressure Formats
%ATMP = DTMP = GXTP +/- 10

% ATMP_Index = find(ATMP.data);
% OutOfRangeIndex = find(VPWR.data(VLTB_Index)< VLTB.data(VLTB_Index)-1 | (VPWR.data(VLTB_Index) > VLTB.data(VLTB_Index)+1));
% VPWR.OutOfRangeCount = length(OutOfRangeIndex);
%  if VPWR.OutOfRangeCount>0
%      VPWR.Status = 'FAILED';
%  end

%temperature techlog channels
LimitChecks.ATMP.idx = find(strcmp(channelname,'ATMP')==1);
LimitChecks.DTMP.idx = find(strcmp(channelname,'DTMP')==1);
LimitChecks.GXTP.idx = find(strcmp(channelname,'GXTP')==1);

LimitChecks.ATMP.data = channeldata(:, LimitChecks.ATMP.idx);
LimitChecks.DTMP.data = channeldata(:, LimitChecks.DTMP.idx);
LimitChecks.GXTP.data = channeldata(:, LimitChecks.GXTP.idx);

ATDTGXData = {LimitChecks.ATMP.data,LimitChecks.DTMP.data,LimitChecks.GXTP.data};

LimitChecks.ATMP.OutOfRangeIndex = find(((ATDTGXData{1}< ATDTGXData{2}+10) & (ATDTGXData{1}> ATDTGXData{2}-10) & (ATDTGXData{2}< ATDTGXData{3}+10) & (ATDTGXData{2}> ATDTGXData{3}-10))~=1);
LimitChecks.ATMP.OutOfRangeCount = length(LimitChecks.ATMP.OutOfRangeIndex);
LimitChecks.ATMP.Condition = 'ATMP = DTMP = GXTP +/- 10';
if LimitChecks.ATMP.OutOfRangeCount>0
    LimitChecks.ATMP.FailurePercent = LimitChecks.ATMP.OutOfRangeCount*100/TotalRecords;
    if LimitChecks.ATMP.FailurePercent>1
        LimitChecks.ATMP.Status = 'FAILED';
        LimitCheckSubSystemChecks.TPHealthStatus = 'FAILED';
        LimitChecks.ATMP.OutageTime = timeData(LimitChecks.ATMP.OutOfRangeIndex);
    elseif LimitChecks.ATMP.FailurePercent>0
        LimitChecks.ATMP.Status = 'WARNING';
        if ~isfield(LimitCheckSubSystemChecks,'TPHealthStatus')
            LimitCheckSubSystemChecks.TPHealthStatus = 'WARNING';
        end
    end
end

LimitChecks.DTMP.OutOfRangeIndex = find(((ATDTGXData{1}< ATDTGXData{2}+10) & (ATDTGXData{1}> ATDTGXData{2}-10) & (ATDTGXData{2}< ATDTGXData{3}+10) & (ATDTGXData{2}> ATDTGXData{3}-10))~=1);
LimitChecks.DTMP.OutOfRangeCount = length(LimitChecks.DTMP.OutOfRangeIndex);
LimitChecks.DTMP.Condition = 'ATMP = DTMP = GXTP +/- 10';

if LimitChecks.DTMP.OutOfRangeCount>0
    LimitChecks.DTMP.FailurePercent = LimitChecks.DTMP.OutOfRangeCount*100/TotalRecords;
    
    if LimitChecks.DTMP.FailurePercent>1
        LimitChecks.DTMP.Status = 'FAILED';
        LimitCheckSubSystemChecks.TPHealthStatus = 'FAILED';
        LimitChecks.DTMP.OutageTime = timeData(LimitChecks.DTMP.OutOfRangeIndex);

    elseif LimitChecks.DTMP.FailurePercent>0
        LimitChecks.DTMP.Status = 'WARNING';
        if ~isfield(LimitCheckSubSystemChecks,'TPHealthStatus')
            LimitCheckSubSystemChecks.TPHealthStatus = 'WARNING';
        end
    end
end

LimitChecks.GXTP.OutOfRangeIndex = find(((ATDTGXData{1}< ATDTGXData{2}+10) & (ATDTGXData{1}> ATDTGXData{2}-10) & (ATDTGXData{2}< ATDTGXData{3}+10) & (ATDTGXData{2}> ATDTGXData{3}-10))~=1);
LimitChecks.GXTP.OutOfRangeCount = length(LimitChecks.GXTP.OutOfRangeIndex);
LimitChecks.GXTP.Condition = 'ATMP = DTMP = GXTP +/- 10';

if LimitChecks.GXTP.OutOfRangeCount>0
    LimitChecks.GXTP.FailurePercent = LimitChecks.GXTP.OutOfRangeCount*100/TotalRecords;
    if LimitChecks.GXTP.FailurePercent>1
        LimitChecks.GXTP.Status = 'FAILED';
        LimitCheckSubSystemChecks.TPHealthStatus = 'FAILED';
        LimitChecks.GXTP.OutageTime = timeData(LimitChecks.GXTP.OutOfRangeIndex);
    elseif LimitChecks.GXTP.FailurePercent>0
        LimitChecks.GXTP.Status = 'WARNING';
        if ~isfield(LimitCheckSubSystemChecks,'TPHealthStatus')
            LimitCheckSubSystemChecks.TPHealthStatus = 'WARNING';
        end
    end
end

%APRS,APMN,APMX should be <20 kpsi Downhole and 0-50 psi Surface . for now ignoring the status
%(Dowhole or surface)

% LimitChecks.APRS.OutOfRangeIndex = find(LimitChecks.APRS.data>20000); %psi
% LimitChecks.APRS.OutOfRangeCount = length(LimitChecks.APRS.OutOfRangeIndex);
% LimitChecks.APRS.Condition = 'APRS<20 kpsi';
% if LimitChecks.APRS.OutOfRangeCount>0
%     LimitChecks.APRS.Status = 'FAILED';
%     LimitChecks.APRS.FailurePercent = (LimitChecks.APRS.OutOfRangeCount)*100/TotalRecords;
%     LimitCheckSubSystemChecks.TPHealthStatus = 'FAILED';
% end
%
% LimitChecks.APMN.OutOfRangeIndex = find(LimitChecks.APMN.data>20000); %psi
% LimitChecks.APMN.OutOfRangeCount = length(LimitChecks.APMN.OutOfRangeIndex);
% LimitChecks.APMN.Condition = 'APMN<20 kpsi';
% if LimitChecks.APMN.OutOfRangeCount>0
%     LimitChecks.APMN.Status = 'FAILED';
%     LimitChecks.APMN.FailurePercent = (LimitChecks.APMN.OutOfRangeCount)*100/TotalRecords;
%     LimitCheckSubSystemChecks.TPHealthStatus = 'FAILED';
% end
%
% LimitChecks.APMX.OutOfRangeIndex = find(LimitChecks.APMX.data>20000); %psi
% LimitChecks.APMX.OutOfRangeCount = length(LimitChecks.APMX.OutOfRangeIndex);
% LimitChecks.APMX.Condition = 'APMX<20 kpsi';
% if LimitChecks.APMX.OutOfRangeCount>0
%     LimitChecks.APMX.Status = 'FAILED';
%     LimitChecks.APMX.FailurePercent = (LimitChecks.APMX.OutOfRangeCount)*100/TotalRecords;
%     LimitCheckSubSystemChecks.TPHealthStatus = 'FAILED';
% end



%% Power Formats

LimitChecks.P333.idx = find(strcmp(channelname,'P333')==1);
LimitChecks.P332.idx = find(strcmp(channelname,'P332')==1);
LimitChecks.P503.idx = find(strcmp(channelname,'P503')==1);
LimitChecks.P502.idx = find(strcmp(channelname,'P502')==1);
LimitChecks.P132.idx = find(strcmp(channelname,'P132')==1);
LimitChecks.P203.idx = find(strcmp(channelname,'P203')==1);

LimitChecks.M503.idx = find(strcmp(channelname,'M503')==1);
LimitChecks.M502.idx = find(strcmp(channelname,'M502')==1);
LimitChecks.M132.idx = find(strcmp(channelname,'M132')==1);

LimitChecks.I012.idx = find(strcmp(channelname,'I012')==1);
LimitChecks.I013.idx = find(strcmp(channelname,'I013')==1);

LimitChecks.AREF.idx = find(strcmp(channelname,'AREF')==1);
LimitChecks.VLTB.idx = find(strcmp(channelname,'VLTB')==1);
LimitChecks.VPWR.idx = find(strcmp(channelname,'VPWR')==1);
LimitChecks.PRPM.idx = find(strcmp(channelname,'PRPM')==1);


%% positive  voltage techlog channels

LimitChecks.P333.data = channeldata(:, LimitChecks.P333.idx);
LimitChecks.P332.data = channeldata(:, LimitChecks.P332.idx);
LimitChecks.P503.data = channeldata(:, LimitChecks.P503.idx);
LimitChecks.P502.data = channeldata(:, LimitChecks.P502.idx);
LimitChecks.P132.data = channeldata(:, LimitChecks.P132.idx);
LimitChecks.P203.data = channeldata(:, LimitChecks.P203.idx);


time_PSSWOn = timeData(PSSWOnFilterIdx);
time_PSSWOff = timeData(PSSWOffFilterIdx);



% Get conditions
PRPM_nonzero_idx = find(channeldata(:, LimitChecks.PRPM.idx)>=1 & channeldata(:, LimitChecks.PRPM.idx)<=20000);
time_PRPM = timeData(PRPM_nonzero_idx);

VLTB_idx = find(channeldata(:, LimitChecks.VLTB.idx)>=22.5);
time_VLTB = timeData(VLTB_idx);



%P333/P332: 3.3V to 3.6V
LimitChecks.P333.OutOfRangeIndex = find(LimitChecks.P333.data<3.3 | LimitChecks.P333.data>3.6 );
LimitChecks.P333.OutOfRangeCount = length(LimitChecks.P333.OutOfRangeIndex);
LimitChecks.P333.Condition = 'P333 is  3.3V to 3.6V';
if LimitChecks.P333.OutOfRangeCount>0
    LimitChecks.P333.FailurePercent = (LimitChecks.P333.OutOfRangeCount)*100/length(LimitChecks.P333.data);
    if  LimitChecks.P333.FailurePercent > 1
        LimitChecks.P333.Status = 'FAILED';
        LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
        LimitChecks.P333.OutageTime = timeData(LimitChecks.P333.OutOfRangeIndex);
    else
        LimitChecks.P333.Status = 'WARNING';
        if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
            LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
        end
    end
    
end

LimitChecks.P332.OutOfRangeIndex = find(LimitChecks.P332.data(VLTB_idx)<3.3 | LimitChecks.P332.data(VLTB_idx)>3.6 );
LimitChecks.P332.OutOfRangeCount = length(LimitChecks.P332.OutOfRangeIndex);
LimitChecks.P332.Condition = 'P332 is  3.3V to 3.6V';
LimitChecks.P332.Minimum = min(LimitChecks.P332.data(VLTB_idx));
LimitChecks.P332.Maximum = max(LimitChecks.P332.data(VLTB_idx));

if LimitChecks.P332.OutOfRangeCount>0
    LimitChecks.P332.FailurePercent = (LimitChecks.P332.OutOfRangeCount)*100/length(LimitChecks.P332.data(VLTB_idx));
    if  LimitChecks.P332.FailurePercent > 1
        LimitChecks.P332.Status = 'FAILED';
        LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
        LimitChecks.P332.OutageTime = time_VLTB(LimitChecks.P332.OutOfRangeIndex);

    else
        LimitChecks.P332.Status = 'WARNING';
        if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
            LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
        end
    end
    
end

% if LimitChecks.P332.OutOfRangeCount>0
%     LimitChecks.P332.Status = 'FAILED';
%     LimitChecks.P332.FailurePercent = (LimitChecks.P332.OutOfRangeCount)*100/length(LimitChecks.P332.data(VLTB_idx));
%     LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
% end

%P503/P502: 4.75V to 5.25V
LimitChecks.P503.OutOfRangeIndex = find(LimitChecks.P503.data<4.75 | LimitChecks.P503.data>5.25 );
LimitChecks.P503.OutOfRangeCount = length(LimitChecks.P503.OutOfRangeIndex);
LimitChecks.P503.Condition = 'P503 is  4.75V to 5.25V';

if LimitChecks.P503.OutOfRangeCount>0
    LimitChecks.P503.FailurePercent = (LimitChecks.P503.OutOfRangeCount)*100/length(LimitChecks.P503.data);
    
    if  LimitChecks.P503.FailurePercent > 1
        LimitChecks.P503.Status = 'FAILED';
        LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
        LimitChecks.P503.OutageTime = timeData(LimitChecks.P503.OutOfRangeIndex);

    else
        LimitChecks.P503.Status = 'WARNING';
        if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
            LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
        end
    end
    
end
% if LimitChecks.P503.OutOfRangeCount>0
%     LimitChecks.P503.Status = 'FAILED';
%     LimitChecks.P503.FailurePercent = (LimitChecks.P503.OutOfRangeCount)*100/length(LimitChecks.P503.data);
%     LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
% end

LimitChecks.P502.OutOfRangeIndex = find(LimitChecks.P502.data(VLTB_idx)<4.75 | LimitChecks.P502.data(VLTB_idx)>5.25 );
LimitChecks.P502.OutOfRangeCount = length(LimitChecks.P502.OutOfRangeIndex);
LimitChecks.P502.Condition = 'P502 is  4.75V to 5.25V';
LimitChecks.P502.Minimum = min(LimitChecks.P502.data(VLTB_idx));
LimitChecks.P502.Maximum = max(LimitChecks.P502.data(VLTB_idx));

if LimitChecks.P502.OutOfRangeCount>0
    LimitChecks.P502.FailurePercent = (LimitChecks.P502.OutOfRangeCount)*100/length(LimitChecks.P502.data(VLTB_idx));
    
    if  LimitChecks.P502.FailurePercent > 1
        LimitChecks.P502.Status = 'FAILED';
        LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
        LimitChecks.P502.OutageTime = time_VLTB(LimitChecks.P502.OutOfRangeIndex);

    else
        LimitChecks.P502.Status = 'WARNING';
        if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
            LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
        end
    end
    
end
% if LimitChecks.P502.OutOfRangeCount>0
%     LimitChecks.P502.Status = 'FAILED';
%     LimitChecks.P502.FailurePercent = (LimitChecks.P502.OutOfRangeCount)*100/length(LimitChecks.P502.data(VLTB_idx));
%     LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
% end

%P132: 12.7V to 13.3V
LimitChecks.P132.OutOfRangeIndex = find(LimitChecks.P132.data(VLTB_idx)<12.7 | LimitChecks.P132.data(VLTB_idx)>13.3 );
LimitChecks.P132.OutOfRangeCount = length(LimitChecks.P132.OutOfRangeIndex);
LimitChecks.P132.Condition = 'P132 is  12.7V to 13.3V';
LimitChecks.P132.Minimum = min(LimitChecks.P132.data(VLTB_idx));
LimitChecks.P132.Maximum = max(LimitChecks.P132.data(VLTB_idx));
if LimitChecks.P132.OutOfRangeCount>0
    LimitChecks.P132.FailurePercent = (LimitChecks.P132.OutOfRangeCount)*100/length(LimitChecks.P132.data(VLTB_idx));
    
    if  LimitChecks.P132.FailurePercent > 1
        LimitChecks.P132.Status = 'FAILED';
        LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
        LimitChecks.P132.OutageTime = time_VLTB(LimitChecks.P132.OutOfRangeIndex);

    else
        LimitChecks.P132.Status = 'WARNING';
        if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
            LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
        end
    end
    
end

%P203: 19.5V to 20.5V
LimitChecks.P203.OutOfRangeIndex = find(LimitChecks.P203.data<19.5 | LimitChecks.P203.data>20.5 );
LimitChecks.P203.OutOfRangeCount = length(LimitChecks.P203.OutOfRangeIndex);

LimitChecks.P203.Condition = 'P203 is  19.5V to 20.5V';
if LimitChecks.P203.OutOfRangeCount>0
    LimitChecks.P203.FailurePercent = (LimitChecks.P203.OutOfRangeCount)*100/length(LimitChecks.P203.data);
    
    if  LimitChecks.P203.FailurePercent > 1
        LimitChecks.P203.Status = 'FAILED';
        LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
        LimitChecks.P203.OutageTime = timeData(LimitChecks.P203.OutOfRangeIndex);

    else
        LimitChecks.P203.Status = 'WARNING';
        if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
            LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
        end
    end
end

%% negative  voltage techlog channels

LimitChecks.M503.data = channeldata(:, LimitChecks.M503.idx);
LimitChecks.M502.data = channeldata(:, LimitChecks.M502.idx);
LimitChecks.M132.data = channeldata(:, LimitChecks.M132.idx);


%M502/M503: -5.25V to -4.75V
LimitChecks.M502.OutOfRangeIndex = find(LimitChecks.M502.data(VLTB_idx)<-5.25 | LimitChecks.M502.data(VLTB_idx)>-4.75 );
LimitChecks.M502.OutOfRangeCount = length(LimitChecks.M502.OutOfRangeIndex);
LimitChecks.M502.Minimum = min(LimitChecks.M502.data(VLTB_idx));
LimitChecks.M502.Maximum = max(LimitChecks.M502.data(VLTB_idx));
LimitChecks.M502.Condition = 'M502 is -5.25V to -4.75V';
if LimitChecks.M502.OutOfRangeCount>0
    LimitChecks.M502.FailurePercent = (LimitChecks.M502.OutOfRangeCount)*100/length(LimitChecks.M502.data(VLTB_idx));

    if  LimitChecks.M502.FailurePercent > 1
        LimitChecks.M502.Status = 'FAILED';
        LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
        LimitChecks.P502.OutageTime = time_VLTB(LimitChecks.P502.OutOfRangeIndex);

    else
        LimitChecks.M502.Status = 'WARNING';
        if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
            LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
        end
    end
end

LimitChecks.M503.OutOfRangeIndex = find(LimitChecks.M503.data<-5.25 | LimitChecks.M503.data>-4.75 );
LimitChecks.M503.OutOfRangeCount = length(LimitChecks.M503.OutOfRangeIndex);
LimitChecks.M503.Minimum = min(LimitChecks.M503.data);
LimitChecks.M503.Maximum = max(LimitChecks.M503.data);
LimitChecks.M503.Condition = 'M503 is -5.25V to -4.75V';
if LimitChecks.M503.OutOfRangeCount>0
    LimitChecks.M503.FailurePercent = (LimitChecks.M503.OutOfRangeCount)*100/length(LimitChecks.M503.data);
    if  LimitChecks.M503.FailurePercent > 1
        LimitChecks.M503.Status = 'FAILED';
        LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
        LimitChecks.M503.OutageTime = timeData(LimitChecks.M503.OutOfRangeIndex);
    else
        LimitChecks.M503.Status = 'WARNING';
        if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
            LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
        end
    end
end
%M132: -13.3V to -12.6V
LimitChecks.M132.OutOfRangeIndex = find(LimitChecks.M132.data(VLTB_idx)<-13.3 | LimitChecks.M132.data(VLTB_idx)>-12.6 );
LimitChecks.M132.OutOfRangeCount = length(LimitChecks.M132.OutOfRangeIndex);
LimitChecks.M132.Minimum = min(LimitChecks.M132.data(VLTB_idx));
LimitChecks.M132.Maximum = max(LimitChecks.M132.data(VLTB_idx));

LimitChecks.M132.Condition = 'M132 is -13.3V to -12.6V';
if LimitChecks.M132.OutOfRangeCount>0
    LimitChecks.M132.FailurePercent = (LimitChecks.M132.OutOfRangeCount)*100/length(LimitChecks.M132.data(VLTB_idx));

    if  LimitChecks.M132.FailurePercent > 1
        LimitChecks.M132.Status = 'FAILED';
        LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
        LimitChecks.M132.OutageTime = time_VLTB(LimitChecks.M132.OutOfRangeIndex);
    else
        LimitChecks.M132.Status = 'WARNING';
        if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
            LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
        end
    end
end

%% LTB current techlog channels



I001.idx = find(strcmp(channelname,'I001')==1 );
I003.idx = find(strcmp(channelname,'I003')==1);
I001.data = channeldata(:, I001.idx);
I003.data = channeldata(:, I003.idx);




%I012: 0.15A to 0.35A
LimitChecks.I012.data = channeldata(:, LimitChecks.I012.idx);
LimitChecks.I012.OutOfRangeIndex = find(LimitChecks.I012.data(VLTB_idx)<0.15 | LimitChecks.I012.data(VLTB_idx)>0.35 );
LimitChecks.I012.Minimum = min(LimitChecks.I012.data(VLTB_idx));
LimitChecks.I012.Maximum = max(LimitChecks.I012.data(VLTB_idx));


LimitChecks.I012.OutOfRangeCount = length(LimitChecks.I012.OutOfRangeIndex);
LimitChecks.I012.Condition = 'I012 is 0.15A to 0.35A';
if LimitChecks.I012.OutOfRangeCount>0
    LimitChecks.I012.FailurePercent = (LimitChecks.I012.OutOfRangeCount)*100/length(LimitChecks.I012.data(VLTB_idx));

    if  LimitChecks.I012.FailurePercent > 1
        LimitChecks.I012.Status = 'FAILED';
        LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
        LimitChecks.I012.OutageTime = time_VLTB(LimitChecks.I012.OutOfRangeIndex);
    else
        LimitChecks.I012.Status = 'WARNING';
        if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
            LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
        end
    end
    
end

%I013:  0.2A to 0.6A
LimitChecks.I013.data = channeldata(:, LimitChecks.I013.idx);
LimitChecks.I013.OutOfRangeIndex = find(LimitChecks.I013.data<0.2 | LimitChecks.I013.data>0.6 );
LimitChecks.I013.Minimum = min(LimitChecks.I013.data);
LimitChecks.I013.Maximum = max(LimitChecks.I013.data);

LimitChecks.I013.OutOfRangeCount = length(LimitChecks.I013.OutOfRangeIndex);
LimitChecks.I013.Condition = 'I013 is 0.2A to 0.6A';
if LimitChecks.I013.OutOfRangeCount>0
   LimitChecks.I013.FailurePercent = (LimitChecks.I013.OutOfRangeCount)*100/length(LimitChecks.I013.data);

   if  LimitChecks.I013.FailurePercent > 1
        LimitChecks.I013.Status = 'FAILED';
        LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
        LimitChecks.I013.OutageTime = timeData(LimitChecks.I013.OutOfRangeIndex);
   else
        LimitChecks.I013.Status = 'WARNING';
        if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
            LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
        end
    end
    
end

%I001/I003: 0A to 0.001A PNG Off
LimitChecks.I001_OFF.Condition = 'PNG Off:I001 is 0A to 0.05A';
LimitChecks.I001_OFF.data = I001.data(PSSWOffFilterIdx);
LimitChecks.I001_OFF.Minimum = min(LimitChecks.I001_OFF.data);
LimitChecks.I001_OFF.Maximum = max(LimitChecks.I001_OFF.data);

if ~isempty(LimitChecks.I001_OFF.data)
    LimitChecks.I001_OFF.OutOfRangeIndex = find(LimitChecks.I001_OFF.data<0 | LimitChecks.I001_OFF.data > 0.05);
    LimitChecks.I001_OFF.OutOfRangeCount = length(LimitChecks.I001_OFF.OutOfRangeIndex);
    
    if LimitChecks.I001_OFF.OutOfRangeCount>0
        LimitChecks.I001_OFF.FailurePercent = (LimitChecks.I001_OFF.OutOfRangeCount)*100/length(LimitChecks.I001_OFF.data);
        
        if  LimitChecks.I001_OFF.FailurePercent > 1
            LimitChecks.I001_OFF.Status = 'FAILED';
            LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
            LimitChecks.I001_OFF.OutageTime = time_PSSWOff(LimitChecks.I001_OFF.OutOfRangeIndex);

        else
            LimitChecks.I001_OFF.Status = 'WARNING';
            if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
                LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
            end
        end
        
    end
end

LimitChecks.I003_OFF.Condition = 'PNG Off:I003 is 0A to 0.05A';
LimitChecks.I003_OFF.data = I003.data(PSSWOffFilterIdx);
LimitChecks.I003_OFF.Minimum = min(LimitChecks.I003_OFF.data);
LimitChecks.I003_OFF.Maximum = max(LimitChecks.I003_OFF.data);

if ~isempty(LimitChecks.I003_OFF.data)
    LimitChecks.I003_OFF.OutOfRangeIndex = find(LimitChecks.I003_OFF.data<0 | LimitChecks.I003_OFF.data >= 0.05);
    LimitChecks.I003_OFF.OutOfRangeCount = length(LimitChecks.I003_OFF.OutOfRangeIndex);
       
    if LimitChecks.I003_OFF.OutOfRangeCount>0
        LimitChecks.I003_OFF.FailurePercent = (LimitChecks.I003_OFF.OutOfRangeCount)*100/length(LimitChecks.I003_OFF.data);

        if  LimitChecks.I003_OFF.FailurePercent > 1
            LimitChecks.I003_OFF.Status = 'FAILED';
            LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
            LimitChecks.I003_OFF.OutageTime = time_PSSWOff(LimitChecks.I003_OFF.OutOfRangeIndex);

        else
            LimitChecks.I003_OFF.Status = 'WARNING';
            if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
                LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
            end
        end
        
    end
end

%I001: 0.2A-0.32A PNG On
LimitChecks.I001_ON.Condition = 'PNG On:I001 is 0.25A to 0.60A';
LimitChecks.I001_ON.data = I001.data(PSSWOnFilterIdx);
LimitChecks.I001_ON.Minimum = min(LimitChecks.I001_ON.data);
LimitChecks.I001_ON.Maximum = max(LimitChecks.I001_ON.data);


if ~isempty(LimitChecks.I001_ON.data)
    LimitChecks.I001_ON.OutOfRangeIndex = find(LimitChecks.I001_ON.data<0.25 | LimitChecks.I001_ON.data > 0.60);
    LimitChecks.I001_ON.OutOfRangeCount = length(LimitChecks.I001_ON.OutOfRangeIndex);
    
    if LimitChecks.I001_ON.OutOfRangeCount>0
        LimitChecks.I001_ON.FailurePercent = (LimitChecks.I001_ON.OutOfRangeCount)*100/length(LimitChecks.I001_ON.data);

        if  LimitChecks.I001_ON.FailurePercent > 1
            LimitChecks.I001_ON.Status = 'FAILED';
            LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
            LimitChecks.I001_ON.OutageTime = time_PSSWOn(LimitChecks.I001_ON.OutOfRangeIndex);

        else
            LimitChecks.I001_ON.Status = 'WARNING';
            if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
                LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
            end
        end
        
    end
end

%I003: 04A to 0.65A PNG On
LimitChecks.I003_ON.Condition = 'PNG On:I003 is 0.30A to 0.65A';
LimitChecks.I003_ON.data = I003.data(PSSWOnFilterIdx);
LimitChecks.I003_ON.Minimum = min(LimitChecks.I003_ON.data);
LimitChecks.I003_ON.Maximum = max(LimitChecks.I003_ON.data);

if ~isempty(LimitChecks.I003_ON.data)
    LimitChecks.I003_ON.OutOfRangeIndex = find(LimitChecks.I003_ON.data<0.3 | LimitChecks.I003_ON.data > 0.65);
    LimitChecks.I003_ON.OutOfRangeCount = length(LimitChecks.I003_ON.OutOfRangeIndex);
    
    if LimitChecks.I003_ON.OutOfRangeCount>0
        LimitChecks.I003_ON.FailurePercent = (LimitChecks.I003_ON.OutOfRangeCount)*100/length(LimitChecks.I003_ON.data);

        if  LimitChecks.I003_ON.FailurePercent > 1
            LimitChecks.I003_ON.Status = 'FAILED';
            LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
            LimitChecks.I003_ON.OutageTime = time_PSSWOn(LimitChecks.I003_ON.OutOfRangeIndex);
        else
            LimitChecks.I003_ON.Status = 'WARNING';
            if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
                LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
            end
        end
        
    end
end

%% LTB voltage techlog channels


%AREF 2.45V to 2.55V
LimitChecks.AREF.data = channeldata(:, LimitChecks.AREF.idx);
LimitChecks.AREF.OutOfRangeIndex = find(LimitChecks.AREF.data<2.45 | LimitChecks.AREF.data>2.55 );
LimitChecks.AREF.OutOfRangeCount = length(LimitChecks.AREF.OutOfRangeIndex);
LimitChecks.AREF.Condition = 'AREF is 2.45V to 2.55V';
LimitChecks.AREF.Minimum = min(LimitChecks.AREF.data);
LimitChecks.AREF.Maximum = max(LimitChecks.AREF.data);

if LimitChecks.AREF.OutOfRangeCount>0
   LimitChecks.AREF.FailurePercent = (LimitChecks.AREF.OutOfRangeCount)*100/length(LimitChecks.AREF.data);

        if  LimitChecks.AREF.FailurePercent > 1
            LimitChecks.AREF.Status = 'FAILED';
            LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
            LimitChecks.AREF.OutageTime = timeData(LimitChecks.AREF.OutOfRangeIndex);

        else
            LimitChecks.AREF.Status = 'WARNING';
            if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
                LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
            end
        end
end

%VLTB 26V to 32V
LimitChecks.VLTB.Condition = 'VLTB is 24V to 32V';
LimitChecks.VLTB.data = channeldata(:, LimitChecks.VLTB.idx);
LimitChecks.VLTB.Minimum = min(LimitChecks.VLTB.data(PRPM_nonzero_idx));
LimitChecks.VLTB.Maximum = max(LimitChecks.VLTB.data(PRPM_nonzero_idx));

LimitChecks.VLTB.OutOfRangeIndex = find(LimitChecks.VLTB.data(PRPM_nonzero_idx)<24 | LimitChecks.VLTB.data(PRPM_nonzero_idx)>32 );
LimitChecks.VLTB.OutOfRangeCount = length(LimitChecks.VLTB.OutOfRangeIndex);

if LimitChecks.VLTB.OutOfRangeCount>0
    LimitChecks.VLTB.FailurePercent = LimitChecks.VLTB.OutOfRangeCount*100/length(LimitChecks.VLTB.data(PRPM_nonzero_idx));
    if  LimitChecks.VLTB.FailurePercent > 1
        LimitChecks.VLTB.Status = 'FAILED';
        LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
        LimitChecks.VLTB.OutageTime = time_PRPM(LimitChecks.VLTB.OutOfRangeIndex);

    else
        LimitChecks.VLTB.Status = 'WARNING';
        if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
            LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
        end
    end
end
%VPWR=VLTB+/-1V
LimitChecks.VPWR.Condition = 'VPWR=VLTB+/-1V';
LimitChecks.VPWR.data = channeldata(:, LimitChecks.VPWR.idx);
LimitChecks.VPWR.Minimum = min(LimitChecks.VPWR.data(PRPM_nonzero_idx));
LimitChecks.VPWR.Maximum = max(LimitChecks.VPWR.data(PRPM_nonzero_idx));

if ~isempty(LimitChecks.VPWR.data)
    %LimitChecks.VLTB.index = find(LimitChecks.VLTB.data);
    LimitChecks.VPWR.OutOfRangeIndex = find(LimitChecks.VPWR.data(PRPM_nonzero_idx)< LimitChecks.VLTB.data(PRPM_nonzero_idx)-1 | (LimitChecks.VPWR.data(PRPM_nonzero_idx) > LimitChecks.VLTB.data(PRPM_nonzero_idx)+1));
    LimitChecks.VPWR.OutOfRangeCount = length(LimitChecks.VPWR.OutOfRangeIndex);
    
    if LimitChecks.VPWR.OutOfRangeCount>0
        LimitChecks.VPWR.FailurePercent = LimitChecks.VPWR.OutOfRangeCount*100/length(LimitChecks.VPWR.data(PRPM_nonzero_idx));

        if LimitChecks.VPWR.FailurePercent >0.5
            LimitChecks.VPWR.Status = 'FAILED';
            LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
            LimitChecks.VPWR.OutageTime = time_PRPM(LimitChecks.VPWR.OutOfRangeIndex);

        else
            
            LimitChecks.VPWR.Status = 'WARNING';
            if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
            LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
            end
            
        end
    end
end

LimitChecks.PRPM.Condition = 'PRPM is 300 to 10000';
LimitChecks.PRPM.data = channeldata(PSSWOnFilterIdx, LimitChecks.PRPM.idx);
LimitChecks.PRPM.Minimum = min(LimitChecks.PRPM.data);
LimitChecks.PRPM.Maximum = max(LimitChecks.PRPM.data);

%APRSIdx = find(LimitChecks.APRS.data <100);
%LimitChecks.PRPM.data(APRSIdx)=[];
if ~isempty(LimitChecks.PRPM.data)
    
    LimitChecks.PRPM.OutOfRangeIndex = find(LimitChecks.PRPM.data<300 | LimitChecks.PRPM.data > 10000);
    LimitChecks.PRPM.OutOfRangeCount = length(LimitChecks.PRPM.OutOfRangeIndex);
    if LimitChecks.PRPM.OutOfRangeCount>0
        LimitChecks.PRPM.FailurePercent = LimitChecks.PRPM.OutOfRangeCount*100/length(LimitChecks.PRPM.data);

        if LimitChecks.PRPM.FailurePercent > 1
            LimitChecks.PRPM.Status = 'FAILED';
            LimitCheckSubSystemChecks.PowerStatus = 'FAILED';
            LimitChecks.PRPM.OutageTime = time_PSSWOn(LimitChecks.PRPM.OutOfRangeIndex);

        else
            LimitChecks.PRPM.Status = 'WARNING';
            if isfield(LimitCheckSubSystemChecks,'PowerStatus') ~= 1
                LimitCheckSubSystemChecks.PowerStatus = 'WARNING';
            end
        end
        
    end
end

%% PNG Formats

%PNG FNP Interlock techlog channels
LimitChecks.MON.idx = find(strcmp(channelname,'MON')==1);
%LimitChecks.DMS2.idx = find(strcmp(channelname,'DMS2')==1);
LimitChecks.FNPP.idx = find(strcmp(channelname,'FNPP')==1);
%PNG techlog1 channels
LimitChecks.BLD.idx = find(strcmp(channelname,'BLD')==1);
LimitChecks.BEAM.idx = find(strcmp(channelname,'BEAM')==1);

%PNG techlog2 channels
LimitChecks.IGRD.idx = find(strcmp(channelname,'IGRD')==1);
LimitChecks.VGRD.idx = find(strcmp(channelname,'VGRD')==1);
LimitChecks.ICAT.idx = find(strcmp(channelname,'ICAT')==1);
LimitChecks.IFIL.idx = find(strcmp(channelname,'IFIL')==1);

%PNG sparking channels
LimitChecks.ARGR.idx = find(strcmp(channelname,'ARGR')==1);
LimitChecks.PNGA.idx = find(strcmp(channelname,'PNGA')==1);






%LimitChecks.MON.time = channeldata(PSSWOnFilterIdx, 1);
%LimitChecks.DMS2.data = channeldata(:, LimitChecks.DMS2.idx);


%%PNG FNP Interlock techlog channels

%MON 100 +/-20 when png is on
LimitChecks.MON.Condition = 'MON is 100 +/-20 when png is on';
LimitChecks.MON.data = channeldata(PSSWOnFilterIdx, LimitChecks.MON.idx);
LimitChecks.MON.Minimum = min(LimitChecks.MON.data);
LimitChecks.MON.Maximum = max(LimitChecks.MON.data);

if ~isempty(LimitChecks.MON.data)
    %     LimitChecks.MON.OutOfRangeIndex = find(LimitChecks.MON.data(PSSW.OffIndex)>= 100);
    %     LimitChecks.MON.OutOfRangeCount = length(LimitChecks.MON.OutOfRangeIndex);
    %     LimitChecks.MON.Condition = 'MON is 100 +/-20 when png is on';
    %     if LimitChecks.MON.OutOfRangeCount > 0
    %         LimitChecks.MON.Status = 'FAILED';
    %         LimitChecks.MON.FailurePercent = (LimitChecks.MON.OutOfRangeCount)*100/TotalRecords;
    %         LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
    %     end
    
    LimitChecks.MON.OutOfRangeIndex = find(LimitChecks.MON.data< 80 | LimitChecks.MON.data > 120);
    LimitChecks.MON.OutOfRangeCount = length(LimitChecks.MON.OutOfRangeIndex);
    if LimitChecks.MON.OutOfRangeCount > 0
        LimitChecks.MON.FailurePercent = LimitChecks.MON.OutOfRangeCount*100/length(LimitChecks.MON.data);
        if  LimitChecks.MON.FailurePercent > 1
            LimitChecks.MON.Status = 'FAILED';
            LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
            LimitChecks.MON.OutageTime = time_PSSWOn(LimitChecks.MON.OutOfRangeIndex);

        else
            LimitChecks.MON.Status = 'WARNING';
            if isfield(LimitCheckSubSystemChecks,'PNGStatus') ~= 1
            LimitCheckSubSystemChecks.PNGStatus = 'WARNING';
            end
        end
            
    end
end

%BEAM: <100mA, max 150 mA when png is on
LimitChecks.BEAM.Condition = 'BEAM is 40 uA to 150 uA when png is on; Warning: > 145 uA';
LimitChecks.BEAM.data = channeldata(PSSWOnFilterIdx, LimitChecks.BEAM.idx);
LimitChecks.BEAM.Minimum = min(LimitChecks.BEAM.data);
LimitChecks.BEAM.Maximum = max(LimitChecks.BEAM.data);

if ~isempty(LimitChecks.BEAM.data)
    %     LimitChecks.BEAM.OutOfRangeIndex = find(LimitChecks.BEAM.data(PSSW.OffIndex)>= 100);
    %     LimitChecks.BEAM.OutOfRangeCount = length(LimitChecks.BEAM.OutOfRangeIndex);
    %     LimitChecks.BEAM.Condition = 'BEAM is <100mA max 150 mA when png is on';
    %     if LimitChecks.BEAM.OutOfRangeCount > 0
    %         LimitChecks.BEAM.Status = 'FAILED';
    %         LimitChecks.BEAM.FailurePercent = (LimitChecks.BEAM.OutOfRangeCount)*100/TotalRecords;
    %         LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
    %
    %     end
    
    LimitChecks.BEAM.OutOfRangeIndex = find(LimitChecks.BEAM.data< 40 | LimitChecks.BEAM.data > 145);
    LimitChecks.BEAM.OutOfRangeCount = length(LimitChecks.BEAM.OutOfRangeIndex);
    if LimitChecks.BEAM.OutOfRangeCount > 0
        LimitChecks.BEAM.FailurePercent = LimitChecks.BEAM.OutOfRangeCount*100/length(LimitChecks.BEAM.data);
        if  (LimitChecks.BEAM.FailurePercent > 0.5) || ((length(find(LimitChecks.BEAM.data > 150))*100/length(LimitChecks.BEAM.data))>0.1)
            LimitChecks.BEAM.Status = 'FAILED';
            LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
            LimitChecks.BEAM.OutageTime = time_PSSWOn(LimitChecks.BEAM.OutOfRangeIndex);
 
        elseif LimitChecks.BEAM.FailurePercent >0.1
            LimitChecks.BEAM.Status = 'WARNING';
            if isfield(LimitCheckSubSystemChecks,'PNGStatus') ~= 1
                LimitCheckSubSystemChecks.PNGStatus = 'WARNING';
            end
        end
        
    end
end

%BLD: 69 to 78kV (78kv means replacement, InTouch ID 4649255) when png is on
LimitChecks.BLD.Condition = 'BLD is 69 to 80kV when png is on; Warning: >78kV; Failed: >80kV';
LimitChecks.BLD.data = channeldata(PSSWOnFilterIdx, LimitChecks.BLD.idx);
LimitChecks.BLD.Minimum = min(LimitChecks.BLD.data);
LimitChecks.BLD.Maximum = max(LimitChecks.BLD.data);

if ~isempty(LimitChecks.BLD.data)
    LimitChecks.BLD.OutOfRangeIndex = find(LimitChecks.BLD.data<69 | LimitChecks.BLD.data > 78);
    LimitChecks.BLD.OutOfRangeCount = length(LimitChecks.BLD.OutOfRangeIndex);
    
    if LimitChecks.BLD.OutOfRangeCount > 0
        LimitChecks.BLD.FailurePercent = LimitChecks.BLD.OutOfRangeCount*100/length(LimitChecks.BLD.data);
        if  ~isempty(find(LimitChecks.BLD.data > 80))
            LimitChecks.BLD.Status = 'FAILED';
            LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
            LimitChecks.BLD.OutageTime = time_PSSWOn(LimitChecks.BLD.OutOfRangeIndex);

        else
            if LimitChecks.BLD.FailurePercent >0.5
                LimitChecks.BLD.Status = 'FAILED';
                LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
            elseif LimitChecks.BLD.FailurePercent >0.1
                LimitChecks.BLD.Status = 'WARNING';
                if isfield(LimitCheckSubSystemChecks,'PNGStatus') ~= 1
                    LimitCheckSubSystemChecks.PNGStatus = 'WARNING';
                end
            end
        end
    end
end

%IGRD: 40 to 50mA 
LimitChecks.IGRD.Condition = 'IGRD is 40 to 50mA';
LimitChecks.IGRD.data = channeldata(PSSWOnFilterIdx, LimitChecks.IGRD.idx);
LimitChecks.IGRD.Minimum = min(LimitChecks.IGRD.data);
LimitChecks.IGRD.Maximum = max(LimitChecks.IGRD.data);

if ~isempty(LimitChecks.IGRD.data)
    LimitChecks.IGRD.OutOfRangeIndex = find(LimitChecks.IGRD.data<40 | LimitChecks.IGRD.data > 50);
    LimitChecks.IGRD.OutOfRangeCount = length(LimitChecks.IGRD.OutOfRangeIndex);
    
    if LimitChecks.IGRD.OutOfRangeCount > 0
        LimitChecks.IGRD.FailurePercent = LimitChecks.IGRD.OutOfRangeCount*100/length(LimitChecks.IGRD.data);
        if  LimitChecks.IGRD.FailurePercent > 0.5
            LimitChecks.IGRD.Status = 'FAILED';
            LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
            LimitChecks.IGRD.OutageTime = time_PSSWOn(LimitChecks.IGRD.OutOfRangeIndex);

        elseif LimitChecks.IGRD.FailurePercent > 0.1
            LimitChecks.IGRD.Status = 'WARNING';
            if isfield(LimitCheckSubSystemChecks,'PNGStatus') ~= 1
                LimitCheckSubSystemChecks.PNGStatus = 'WARNING';
            end
            
        end
    end
end

%VGRD: 185 to 205V 
LimitChecks.VGRD.Condition = 'VGRD is 185 to 205V';
LimitChecks.VGRD.data = channeldata(PSSWOnFilterIdx, LimitChecks.VGRD.idx);
LimitChecks.VGRD.Minimum = min(LimitChecks.VGRD.data);
LimitChecks.VGRD.Maximum = max(LimitChecks.VGRD.data);

if ~isempty(LimitChecks.VGRD.data)
    LimitChecks.VGRD.OutOfRangeIndex = find(LimitChecks.VGRD.data<185 | LimitChecks.VGRD.data > 205);
    LimitChecks.VGRD.OutOfRangeCount = length(LimitChecks.VGRD.OutOfRangeIndex);
    
    if LimitChecks.VGRD.OutOfRangeCount > 0
        LimitChecks.VGRD.FailurePercent = LimitChecks.VGRD.OutOfRangeCount*100/length(LimitChecks.VGRD.data);
        if LimitChecks.VGRD.FailurePercent > 0.5
            LimitChecks.VGRD.Status = 'FAILED';
            LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
            LimitChecks.VGRD.OutageTime = time_PSSWOn(LimitChecks.VGRD.OutOfRangeIndex);

        elseif LimitChecks.VGRD.FailurePercent > 0.1
            LimitChecks.VGRD.Status = 'WARNING';
            if isfield(LimitCheckSubSystemChecks,'PNGStatus') ~= 1
                LimitCheckSubSystemChecks.PNGStatus = 'WARNING';
            end
            
        end
    end
end

%ICAT: 1.5 to 3A 
LimitChecks.ICAT.Condition = 'ICAT is 1.5 to 3A';
LimitChecks.ICAT.data = channeldata(PSSWOnFilterIdx, LimitChecks.ICAT.idx);
LimitChecks.ICAT.Minimum = min(LimitChecks.ICAT.data);
LimitChecks.ICAT.Maximum = max(LimitChecks.ICAT.data);

if ~isempty(LimitChecks.ICAT.data)
    LimitChecks.ICAT.OutOfRangeIndex = find(LimitChecks.ICAT.data<1.5 | LimitChecks.ICAT.data> 3);
    LimitChecks.ICAT.OutOfRangeCount = length(LimitChecks.ICAT.OutOfRangeIndex);
    
    if LimitChecks.ICAT.OutOfRangeCount > 0
        LimitChecks.ICAT.FailurePercent = LimitChecks.ICAT.OutOfRangeCount*100/length(LimitChecks.ICAT.data);
        if  LimitChecks.ICAT.FailurePercent > 0.5
            LimitChecks.ICAT.Status = 'FAILED';
            LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
            LimitChecks.ICAT.OutageTime = time_PSSWOn(LimitChecks.ICAT.OutOfRangeIndex);

        elseif  LimitChecks.ICAT.FailurePercent > 0.1
            LimitChecks.ICAT.Status = 'WARNING';
            if isfield(LimitCheckSubSystemChecks,'PNGStatus') ~= 1
                LimitCheckSubSystemChecks.PNGStatus = 'WARNING';
            end
        end
    end
end

%IFIL: -3.4 to -1.0A 
LimitChecks.IFIL.Condition = 'IFIL is -3.4 to -1.0A';
LimitChecks.IFIL.data = channeldata(PSSWOnFilterIdx, LimitChecks.IFIL.idx);
LimitChecks.IFIL.Minimum = min(LimitChecks.IFIL.data);
LimitChecks.IFIL.Maximum = max(LimitChecks.IFIL.data);

if ~isempty(LimitChecks.IFIL.data)
    LimitChecks.IFIL.OutOfRangeIndex = find(LimitChecks.IFIL.data < -3.4 | LimitChecks.IFIL.data> -1.0);
    LimitChecks.IFIL.OutOfRangeCount = length(LimitChecks.IFIL.OutOfRangeIndex);
    
    if LimitChecks.IFIL.OutOfRangeCount > 0
        LimitChecks.IFIL.FailurePercent = LimitChecks.IFIL.OutOfRangeCount*100/length(LimitChecks.IFIL.data);
        if LimitChecks.IFIL.FailurePercent > 0.5
            LimitChecks.IFIL.Status = 'FAILED';
            LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
            LimitChecks.IFIL.OutageTime = time_PSSWOn(LimitChecks.IFIL.OutOfRangeIndex);

        elseif  LimitChecks.IFIL.FailurePercent > 0.1
            LimitChecks.IFIL.Status = 'WARNING';
            if isfield(LimitCheckSubSystemChecks,'PNGStatus') ~= 1
                LimitCheckSubSystemChecks.PNGStatus = 'WARNING';
            end
        end
    end
end
%ARGR<40  PNGA<40
%% deal with wrong reading from this channel
% ARGR_diff_counts = sum(diff(LimitChecks.ARGR.data)~=0);
% 
% maxValue = max(LimitChecks.ARGR.data);
% maxIdx = find(LimitChecks.ARGR.data == maxValue);
% LimitChecks.ARGR.data(maxIdx) = ARGR_diff_counts;
% %%%%
% 
% LimitChecks.ARGR.OutOfRangeIndex = find(ARGR_diff_counts>40);
% LimitChecks.ARGR.OutOfRangeCount = length(LimitChecks.ARGR.OutOfRangeIndex);
% LimitChecks.ARGR.Condition = 'ARGR<40';
% 
% %if LimitChecks.ARGR.OutOfRangeCount>0
% if ARGR_diff_counts > 40
%     LimitChecks.ARGR.Status = 'FAILED';
%     LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
%     %LimitChecks.ARGR.FailurePercent = 'N/A';  %LimitChecks.ARGR.OutOfRangeCount*100/TotalRecords;
% end
% 
% PNGA_diff_counts = sum(diff(LimitChecks.PNGA.data)~=0);
% maxValue = max(LimitChecks.PNGA.data);
% maxIdx = find(LimitChecks.PNGA.data == maxValue);
% LimitChecks.PNGA.data(maxIdx) = PNGA_diff_counts;
% 
% LimitChecks.PNGA.OutOfRangeIndex = find(PNGA_diff_counts>40);
% LimitChecks.PNGA.OutOfRangeCount = length(LimitChecks.PNGA.OutOfRangeIndex);
% LimitChecks.PNGA.Condition = 'PNGA<40';
% 
% %if LimitChecks.PNGA.OutOfRangeCount>0
% if PNGA_diff_counts > 40
%     LimitChecks.PNGA.Status = 'FAILED';
%     %LimitChecks.PNGA.FailurePercent = 'N/A'; %LimitChecks.PNGA.OutOfRangeCount*100/TotalRecords;
%     LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
% end
% 

%ARGR > 4 over 20 min

%LimitChecks.ARGR.OutOfRangeTime= sum((LimitChecks.ARGR.data>4))*2/60; %in min

% need to get SHOCK channels for cross-check
SHKXData=  channeldata(:, find(strcmp(channelname,'SHKX')==1));
SHKZData = channeldata(:, find(strcmp(channelname,'SHKZ')==1));
SHKRData = channeldata(:, find(strcmp(channelname,'SHKR')==1));

idx_150G = find((SHKXData>150)| (SHKZData>150) | (SHKRData >150));

LimitChecks.ARGR.Condition = 'ARGR spike counting > 4 over 20 min';
if ~isempty(LimitChecks.ARGR.idx)
    LimitChecks.ARGR.data = channeldata(:, LimitChecks.ARGR.idx);
end
LimitChecks.ARGR.OutOfRangeCount = 'N/A';
LimitChecks.ARGR.FailurePercent = 'N/A';
if isfield(LimitChecks.ARGR,'data') == 1
    %LimitChecks.ARGR.FailurePercent = strcat(num2str((LimitChecks.ARGR.OutOfRangeTime)*100/(TotalRecords*2/60), '%2.3f'));
    %ARGRSpike = diff(LimitChecks.ARGR.data);
    %ARGRSpikeIdx = find(diff(LimitChecks.ARGR.data)>0);
    ARGRData = [0; diff(LimitChecks.ARGR.data)>0];
    ARGRData(idx_150G)= 0;
    ARGRSpikeIdx = find(ARGRData>0);
    LimitChecks.ARGR.Minimum = 0;
    LimitChecks.ARGR.Maximum = length(ARGRSpikeIdx);
    for i=1:length(ARGRSpikeIdx)
        endIdx = ARGRSpikeIdx(i) + (20*60/2);
        if length(find(ARGRSpikeIdx(i:end) <= endIdx))>4
            %if (ARGRSpikeIdx(i+3)-ARGRSpikeIdx(i)) < (20*60/2)
            LimitChecks.ARGR.Status = 'FAILED';
            LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
            
        end
        
    end
else
    LimitChecks.ARGR.Minimum = 'N/A';
    LimitChecks.ARGR.Maximum = 'N/A';
    LimitChecks.ARGR.Status = 'N/A';
    
    
end
    
% 
% 
% if LimitChecks.ARGR.OutOfRangeTime>20
%     LimitChecks.ARGR.Status = 'FAILED';
%     LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
%    
% end

%PNGA > 4 over 20 min
%LimitChecks.PNGA.OutOfRangeTime= sum((LimitChecks.PNGA.data>4))*2/60; %in min
LimitChecks.PNGA.Condition = 'PNGA spike counting > 4 over 20 min';
LimitChecks.PNGA.data = channeldata(:, LimitChecks.PNGA.idx);
%PNGASpike = diff(LimitChecks.PNGA.data);

PNGAData = [0; diff(LimitChecks.PNGA.data)>0];
PNGAData(idx_150G)= 0;
%PNGASpikeIdx = find(diff(LimitChecks.PNGA.data)>0);
PNGASpikeIdx = find(PNGAData>0);
LimitChecks.PNGA.Minimum = 0;
LimitChecks.PNGA.Maximum = length(PNGASpikeIdx);
LimitChecks.PNGA.OutOfRangeCount = 'N/A';
LimitChecks.PNGA.FailurePercent = 'N/A';


for i=1:length(PNGASpikeIdx)
    endIdx = PNGASpikeIdx(i) + (20*60/2);
    if length(find(PNGASpikeIdx(i:end) <= endIdx))>4
        LimitChecks.PNGA.Status = 'FAILED';
        LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
    end
    
end


% LimitChecks.PNGA.FailurePercent = strcat(num2str((LimitChecks.PNGA.OutOfRangeTime)*100/(TotalRecords*2/60), '%2.3f'));
% if LimitChecks.PNGA.OutOfRangeTime>20
%     LimitChecks.PNGA.Status = 'FAILED';
%     LimitCheckSubSystemChecks.PNGStatus = 'FAILED';
%    
% end


%FNPP:1023 (Normal)	FNPP:1-1022 (lntermitt.)	FNPP:0 (loss of contact
%>30s) %appears like status word. below check may not neccessary

%% PSSW bit decoding 
SWbi= dec2bin(StatusWords.PSSW.data,16);
SWbi = SWbi - '0';
SWbi = fliplr(SWbi);
twoBitIdx_1 = intersect(find(SWbi(:,2)==1),find(SWbi(:,12)==1));
time_twoBit = timeData(twoBitIdx_1);

LimitChecks.FNPP.Condition = 'Warning: <1023; Failed: =0';
if ~isempty(LimitChecks.FNPP.idx)
    LimitChecks.FNPP.data = channeldata(:, LimitChecks.FNPP.idx);
end

%idx = find(LimitChecks.FNPP.data~=0);
if isfield(LimitChecks.FNPP,'data')==1
    LimitChecks.FNPP.Minimum = min(LimitChecks.FNPP.data(twoBitIdx_1));
    LimitChecks.FNPP.Maximum = max(LimitChecks.FNPP.data(twoBitIdx_1));
    
    % if isempty(idx)
    %     LimitChecks.FNPP.Status = 'FAILED';
    % else
    LimitChecks.FNPP.OutOfRangeCount = length(find(LimitChecks.FNPP.data(twoBitIdx_1)<1023));
    LimitChecks.FNPP.FailurePercent = LimitChecks.FNPP.OutOfRangeCount*100/length(LimitChecks.FNPP.data(twoBitIdx_1));
    
    if LimitChecks.FNPP.OutOfRangeCount > 0
        if ~isempty(find(LimitChecks.FNPP.data(twoBitIdx_1)== 0))
           LimitChecks.FNPP.OutageTime = time_twoBit(find(LimitChecks.FNPP.data(twoBitIdx_1)== 0));
           LimitChecks.FNPP.Status = 'FAILED';
        else
            LimitChecks.FNPP.Status = 'WARNING';
        end
    end
else
    LimitChecks.FNPP.Minimum = 'N/A';
    LimitChecks.FNPP.Maximum = 'N/A';
    %end
    
    LimitChecks.FNPP.OutOfRangeCount = 'N/A';
    LimitChecks.FNPP.FailurePercent = 'N/A';
    
    LimitChecks.FNPP.Status = 'N/A';
    
    
end
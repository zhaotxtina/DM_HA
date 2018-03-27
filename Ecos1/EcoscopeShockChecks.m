function [ShockSubSystemChecks, ShockCheckData ] = EcoscopeShockChecks( channeldata, channelname )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

TotalRecords = length(channeldata);

timeData = channeldata(:,1);
%Shock peak techlog
ShockCheckData.SHKX.idx = find(strcmp(channelname,'SHKX')==1);
ShockCheckData.SHKZ.idx = find(strcmp(channelname,'SHKZ')==1);
ShockCheckData.SHKR.idx = find(strcmp(channelname,'SHKR')==1);

ShockCheckData.ATMP.idx = find(strcmp(channelname,'ATMP')==1);
ShockCheckData.DTMP.idx = find(strcmp(channelname,'DTMP')==1);
ShockCheckData.GXTP.idx = find(strcmp(channelname,'GXTP')==1);

ShockCheckData.APRS.idx = find(strcmp(channelname,'APRS')==1);
ShockCheckData.APMX.idx = find(strcmp(channelname,'APMX')==1);


ShockSubSystemChecks = struct;


%50G Shocks Techlog
ShockCheckData.SHKL.idx = find(strcmp(channelname,'SHKL')==1);


%Equivalent 50G shocks techlog
ShockCheckData.ESKL.idx = find(strcmp(channelname,'ESKL')==1);


%vibrations techlog
ShockCheckData.VBRX.idx = find(strcmp(channelname,'VBRX')==1);
ShockCheckData.VBRL.idx = find(strcmp(channelname,'VBRL')==1);
ShockCheckData.VBRR.idx = find(strcmp(channelname,'VBRR')==1);




%% Shock Calucations

%ATMP, DTMP, GXTP <150 degC 
%ShockCheckData.ATMP.OutOfRangeCount= length(find(ShockCheckData.ATMP.data>150));
ShockCheckData.ATMP.data = channeldata(:, ShockCheckData.ATMP.idx);
ShockCheckData.ATMP.OutOfRangeTime= sum((ShockCheckData.ATMP.data>150))*2/60; %in min
ShockCheckData.ATMP.Condition = 'ATMP > 150 degC';

if ShockCheckData.ATMP.OutOfRangeTime>0
    ShockCheckData.ATMP.FailurePercent = (ShockCheckData.ATMP.OutOfRangeTime)*100/(TotalRecords*2/60);
    ShockCheckData.ATMP.OutageTime = timeData(find(ShockCheckData.ATMP.data>150));
    ShockCheckData.ATMP.Status = 'WARNING';
    ShockSubSystemChecks.ShockVibrationStatus = 'WARNING';
    
end

%DTMP <150 degC
ShockCheckData.DTMP.data = channeldata(:, ShockCheckData.DTMP.idx);
ShockCheckData.DTMP.OutOfRangeTime= sum((ShockCheckData.DTMP.data>150))*2/60; %in min
ShockCheckData.DTMP.Condition = 'DTMP > 150 degC';

if ShockCheckData.DTMP.OutOfRangeTime>0
    ShockCheckData.DTMP.FailurePercent = (ShockCheckData.DTMP.OutOfRangeTime)*100/(TotalRecords*2/60);
    ShockCheckData.DTMP.OutageTime = timeData(find(ShockCheckData.DTMP.data>150));
    ShockCheckData.DTMP.Status = 'WARNING';
    ShockSubSystemChecks.ShockVibrationStatus = 'WARNING';
   
end

%GXTP <150 degC
ShockCheckData.GXTP.data = channeldata(:, ShockCheckData.GXTP.idx);
ShockCheckData.GXTP.OutOfRangeTime= sum((ShockCheckData.GXTP.data>150))*2/60; %in min
ShockCheckData.GXTP.Condition = 'GXTP > 150 degC';

if ShockCheckData.GXTP.OutOfRangeTime>0
    ShockCheckData.GXTP.FailurePercent = (ShockCheckData.GXTP.OutOfRangeTime)*100/(TotalRecords*2/60);
    ShockCheckData.GXTP.OutageTime = timeData(find(ShockCheckData.GXTP.data>150));
    ShockCheckData.GXTP.Status = 'WARNING';
    ShockSubSystemChecks.ShockVibrationStatus = 'WARNING';
   
end

%APRS < 20 kpsi
ShockCheckData.APRS.data = channeldata(:, ShockCheckData.APRS.idx);
ShockCheckData.APRS.OutOfRangeTime= sum((ShockCheckData.APRS.data>20000))*2/60; %in min
ShockCheckData.APRS.Condition = 'APRS > 20 kpsi';

if ShockCheckData.APRS.OutOfRangeTime>0
    ShockCheckData.APRS.FailurePercent = (ShockCheckData.APRS.OutOfRangeTime)*100/(TotalRecords*2/60);
    ShockCheckData.APRS.OutageTime = timeData(find(ShockCheckData.APRS.data>20000));
    ShockCheckData.APRS.Status = 'WARNING';
    ShockSubSystemChecks.ShockVibrationStatus = 'WARNING';
   
end

%APMX < 20 kpsi
ShockCheckData.APMX.data = channeldata(:, ShockCheckData.APMX.idx);
ShockCheckData.APMX.OutOfRangeTime= sum((ShockCheckData.APMX.data>20000))*2/60; %in min
ShockCheckData.APMX.Condition = 'APMX > 20 kpsi';

if ShockCheckData.APMX.OutOfRangeTime>0
    ShockCheckData.APMX.FailurePercent = (ShockCheckData.APMX.OutOfRangeTime)*100/(TotalRecords*2/60);
    ShockCheckData.APMX.OutageTime = timeData(find(ShockCheckData.APMX.data>20000));
    ShockCheckData.APMX.Status = 'WARNING';
    ShockSubSystemChecks.ShockVibrationStatus = 'WARNING';
    
end

ShockCheckData.SHKX.data = channeldata(:, ShockCheckData.SHKX.idx);
ShockCheckData.SHKZ.data = channeldata(:, ShockCheckData.SHKZ.idx);
ShockCheckData.SHKR.data = channeldata(:, ShockCheckData.SHKR.idx);

ShockCheckData.SHKX.OutOfRangeTime= sum((ShockCheckData.SHKX.data>100))*2/60; %in min
ShockCheckData.SHKZ.OutOfRangeTime= sum((ShockCheckData.SHKZ.data>100))*2/60; %in min
ShockCheckData.SHKR.OutOfRangeTime= sum((ShockCheckData.SHKR.data>100))*2/60; %in min

ShockCheckData.SHKX.Condition = '>100G for 30 mins or > 200G';
ShockCheckData.SHKZ.Condition = '>100G for 30 mins or > 200G';
ShockCheckData.SHKR.Condition = '>100G for 30 mins or > 200G';
    


%<100G for 30 mins
if ShockCheckData.SHKX.OutOfRangeTime> 30 || max(ShockCheckData.SHKX.data)>200
   ShockCheckData.SHKX.FailurePercent = (ShockCheckData.SHKX.OutOfRangeTime)*100/(TotalRecords*2/60);
   ShockCheckData.SHKX.OutageTime = timeData(find(ShockCheckData.SHKX.data>100));

    ShockCheckData.SHKX.Status = 'WARNING';
     ShockSubSystemChecks.ShockVibrationStatus = 'WARNING';
end


if ShockCheckData.SHKZ.OutOfRangeTime> 30 || max(ShockCheckData.SHKZ.data)>200
    ShockCheckData.SHKZ.FailurePercent = (ShockCheckData.SHKZ.OutOfRangeTime)*100/(TotalRecords*2/60);
    ShockCheckData.SHKZ.OutageTime = timeData(find(ShockCheckData.SHKZ.data>100));

    ShockCheckData.SHKZ.Status = 'WARNING';
     ShockSubSystemChecks.ShockVibrationStatus = 'WARNING';
end

if ShockCheckData.SHKR.OutOfRangeTime> 30|| max(ShockCheckData.SHKR.data)>200
    ShockCheckData.SHKR.FailurePercent = (ShockCheckData.SHKR.OutOfRangeTime)*100/(TotalRecords*2/60);
    ShockCheckData.SHKR.OutageTime = timeData(find(ShockCheckData.SHKR.data>100));
    ShockCheckData.SHKR.Status = 'WARNING';
     ShockSubSystemChecks.ShockVibrationStatus = 'WARNING';
end

%SHKL = 3 for 30 mins
%ESKL = 3 for 30 mins

ShockCheckData.SHKL.Condition = 'SHKL > 3 for 30 mins';
ShockCheckData.SHKL.data = channeldata(:, ShockCheckData.SHKL.idx);
ShockCheckData.SHKL.OutOfRangeTime= sum((ShockCheckData.SHKL.data>=3))*2/60; %in min
if ShockCheckData.SHKL.OutOfRangeTime> 30
   ShockCheckData.SHKL.FailurePercent = (ShockCheckData.SHKL.OutOfRangeTime)*100/(TotalRecords*2/60);
     ShockCheckData.SHKL.OutageTime = timeData(find(ShockCheckData.SHKL.data>=3));

    ShockCheckData.SHKL.Status = 'WARNING';
    ShockSubSystemChecks.ShockVibrationStatus = 'WARNING';
end


ShockCheckData.ESKL.Condition = 'ESKL > 3 for 30 mins';
if ~isempty(ShockCheckData.ESKL.idx)
    ShockCheckData.ESKL.data = channeldata(:, ShockCheckData.ESKL.idx);
end
if isfield(ShockCheckData.ESKL,'data')==1
    ShockCheckData.ESKL.OutOfRangeTime= sum((ShockCheckData.ESKL.data>=3))*2/60; %in min
    if ShockCheckData.ESKL.OutOfRangeTime> 30
        ShockCheckData.ESKL.FailurePercent = (ShockCheckData.ESKL.OutOfRangeTime)*100/(TotalRecords*2/60);
        ShockCheckData.ESKL.OutageTime = timeData(find(ShockCheckData.ESKL.data>=3));
         ShockCheckData.ESKL.Status = 'WARNING';
        ShockSubSystemChecks.ShockVibrationStatus = 'WARNING';
    end
else
    ShockCheckData.ESKL.OutOfRangeTime= 'N/A'; %in min
    ShockCheckData.ESKL.FailurePercent = 'N/A';
    ShockCheckData.ESKL.OutageTime = 'N/A';
    ShockCheckData.ESKL.Maximum = 'N/A';
    ShockCheckData.ESKL.Status = 'N/A';
    
    
end
    
%VBRX<2  VBRL<3
ShockCheckData.VBRX.data = channeldata(:, ShockCheckData.VBRX.idx);
ShockCheckData.VBRX.OutOfRangeIndex = find(ShockCheckData.VBRX.data>4);
%ShockCheckData.VBRX.OutOfRangeCount = length(ShockCheckData.VBRX.OutOfRangeIndex);
ShockCheckData.VBRX.OutOfRangeTime = length(ShockCheckData.VBRX.OutOfRangeIndex)*2/60;
ShockCheckData.VBRX.Condition = 'VBRX>4 for 30 min';


if ShockCheckData.VBRX.OutOfRangeTime>30
    ShockCheckData.VBRX.FailurePercent = (ShockCheckData.VBRX.OutOfRangeTime)*100/(TotalRecords*2/60);
    ShockCheckData.VBRX.OutageTime = timeData(ShockCheckData.VBRX.OutOfRangeIndex);
    ShockCheckData.VBRX.Status = 'WARNING';
     ShockSubSystemChecks.ShockVibrationStatus = 'WARNING';
end

ShockCheckData.VBRL.data = channeldata(:, ShockCheckData.VBRL.idx);
ShockCheckData.VBRL.OutOfRangeIndex = find(ShockCheckData.VBRL.data>6);
ShockCheckData.VBRL.OutOfRangeTime = length(ShockCheckData.VBRL.OutOfRangeIndex)*2/60;
ShockCheckData.VBRL.Condition = 'VBRL>6 for 30 min';

if ShockCheckData.VBRL.OutOfRangeTime >30
    ShockCheckData.VBRL.FailurePercent = (ShockCheckData.VBRL.OutOfRangeTime)*100/(TotalRecords*2/60);
    ShockCheckData.VBRL.OutageTime = timeData(ShockCheckData.VBRL.OutOfRangeIndex);
    ShockCheckData.VBRL.Status = 'WARNING';
     ShockSubSystemChecks.ShockVibrationStatus = 'WARNING';
end

ShockCheckData.VBRR.data = channeldata(:, ShockCheckData.VBRR.idx);
ShockCheckData.VBRR.OutOfRangeIndex = find(ShockCheckData.VBRR.data>4.6);
ShockCheckData.VBRR.OutOfRangeTime = length(ShockCheckData.VBRR.OutOfRangeIndex)*2/60;
ShockCheckData.VBRR.Condition = 'VBRR>4.6 for 30 min';

if ShockCheckData.VBRR.OutOfRangeTime >30
    ShockCheckData.VBRR.FailurePercent = (ShockCheckData.VBRR.OutOfRangeTime)*100/(TotalRecords*2/60);
    ShockCheckData.VBRR.OutageTime = timeData(ShockCheckData.VBRR.OutOfRangeIndex);
    ShockCheckData.VBRR.Status = 'WARNING';
    ShockSubSystemChecks.ShockVibrationStatus = 'WARNING';
end

end


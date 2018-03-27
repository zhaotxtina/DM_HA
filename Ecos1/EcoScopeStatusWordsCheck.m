function [StatusWords,SWnames]=StatusWordsCheck(channeldata, channelname,SWChannelName)


TotalRecords = length(channeldata);
SWnames = cell(17,1);
condition = cell(17,1);
StatusWords = struct;

for i = 0:16
    name = strcat('Bit',num2str(i));
    if i == 16
        SWnames{i+1} = strcat('Bit',num2str(i-2),num2str(i-1));
    else
        SWnames{i+1} = name;
    end
end

LimitChecks.ATMP.idx = find(strcmp(channelname,'ATMP')==1);
LimitChecks.DTMP.idx = find(strcmp(channelname,'DTMP')==1);
LimitChecks.GXTP.idx = find(strcmp(channelname,'GXTP')==1);

X4A52_data = channeldata(:, find(strcmp(channelname,'4A52')==1));
CasingIndex = find(X4A52_data < 100);% when casing


timeData  = channeldata(:,1);

for i=1:length(SWChannelName)
    StatusWord_idx = find(strcmp(channelname,SWChannelName{i})==1);
    Status_channel = channeldata(:,StatusWord_idx);
    
    % bit decoding if necessary
    SWbi= dec2bin(Status_channel,16);
    SWbi = SWbi - '0';
    SWbi = fliplr(SWbi);
    
    % Two conditions:
    twoBitIdx_0 = intersect(find(SWbi(:,end)==0),find(SWbi(:,end-1)==0)); % Bit 14& 15 ==0
    timeData_twoBit0 = timeData(twoBitIdx_0);
    
    twoBitIdx = intersect(find(SWbi(:,end)==1),find(SWbi(:,end-1)==1)); % Bit 14&15 ==1
    timeData_twoBit1 = timeData(twoBitIdx);
    
    switch SWChannelName{i}
        
        case 'DMST'
            StatusWords.DMST.data = Status_channel;
            StatusWords.DMST.SWbi = SWbi;
            StatusWords.DMST.(SWnames{end}).Status = 'PASSED';
   %         condition = {'one';'two';'three';'one';'two';'three';'one';'two';'three';'one';'two';'three';'one';'two';'three';'one'};
            for ii= 1: size(SWbi,2)
                StatusWords.DMST.(SWnames{ii}).Activation = length(find(SWbi(:,ii)==1))/TotalRecords*100;
    %             StatusWords.DMST.(SWnames{ii}).Condition = condition{ii};
    %             StatusWords.DMST.(SWnames{ii}).Status = 'FAILED';
             
            end
            
            
        case 'PTSW'
            StatusWords.PTSW.data = Status_channel;
            StatusWords.PTSW.SWbi = SWbi;
            
            condition([1:2 5 8:11])={'Warning: > 0%; Failed: >1%'};
            condition([3:4])={'Warning: > 0%; Failed: >3%'};
            condition([6:7 12:13]) = {'Warning: > 1%'};
            condition(16) = {'Warning: > 0.1%; Failed: >3%'};
            condition(17) = {'Warning: > 0.1%; Failed: >1%'};
            description = {'RAM self test status'; 'CAN RX buf overflow err';'DAC chips status';'ADC chips status:3';...
                'System Registers Error';'Reserve Mode status';'PNG End of Life status';'FPGA status';...
                'Beam or Filament timer';'HV over voltage timer';'Grid or Cathode timer';'PNG under pressure timer';...
                'IGrid too low timer';'PNG Fire state:13';'Board state (low bit)';'Board state (high bit)'; 'Error mode'}; 
            StatusWords.PTSW.(SWnames{end}).Status = 'PASSED';
            
%             twoBitIdx_0 = intersect(find(SWbi(:,end)==0),find(SWbi(:,end-1)==0));
%             timeData_twoBit0 = timeData(twoBitIdx_0);
            for ii= 1: size(SWbi,2)
                if ii < 15
                    %% Bit 14 & 15  == 0
                    activation = length(find(SWbi(twoBitIdx_0,ii)==1))/size(SWbi(twoBitIdx_0,ii),1)*100;
                else
                    %% Bit 14 & 15
                    activation = length(find(SWbi(:,ii)==1))/TotalRecords*100;
                end
                StatusWords.PTSW.(SWnames{ii}).Activation = activation;
                StatusWords.PTSW.(SWnames{ii}).Condition = condition{ii};
                StatusWords.PTSW.(SWnames{ii}).Description = description{ii};
                if any(ii == [1:2 5 8:11])
                    if activation > 1
                        StatusWords.PTSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.PTSW.(SWnames{ii}).OutageTime = timeData_twoBit0(find(SWbi(twoBitIdx_0,ii)==1));
                    elseif activation > 0
                        StatusWords.PTSW.(SWnames{ii}).Status = 'WARNING';
                        
                    end
                elseif any(ii==[3:4])
                     if activation > 3
                        StatusWords.PTSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.PTSW.(SWnames{ii}).OutageTime = timeData_twoBit0(find(SWbi(twoBitIdx_0,ii)==1));
                   elseif activation > 0
                        StatusWords.PTSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii==[6:7 12:13])
                    if activation > 1
                        StatusWords.PTSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii ==16)
                    if activation > 3
                        StatusWords.PTSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.PTSW.(SWnames{ii}).OutageTime = timeData(find(SWbi(:,ii)==1));
                    elseif activation > 0.1
                        StatusWords.PTSW.(SWnames{ii}).Status = 'WARNING';
                    end
                    
                    activation2 = length(twoBitIdx)/TotalRecords*100;
                    if activation2 > 1
                        StatusWords.PTSW.(SWnames{ii+1}).Status = 'FAILED';
                       StatusWords.PTSW.(SWnames{ii}).OutageTime = timeData_twoBit1;

                    elseif activation2 > 0.1
                        StatusWords.PTSW.(SWnames{ii+1}).Status = 'WARNING';
                    end
                    StatusWords.PTSW.(SWnames{ii+1}).Activation = activation2;
                end
                
            end
            StatusWords.PTSW.(SWnames{ii+1}).Condition = condition{ii+1};
            StatusWords.PTSW.(SWnames{ii+1}).Description = description{ii+1};
            
        case 'PNSW'
            StatusWords.PNSW.data = Status_channel;
            StatusWords.PNSW.SWbi = SWbi;
            condition = cell(16,1);
            condition([1:5 14])={'Warning: > 0%; Failed: >1%'};
            condition([6:11]) = {'Warning: > 1%'};
            condition(16) = {'Warning: > 0.1%; Failed: >3%'};
            condition(17) = {'Warning: > 0.1%; Failed: >1%'};
            description = {'SRAM self test status'; 'CAN RX buf overflow err';'ADC Self-Test Failure';'DAC Self-Test Failure';...
                'DPSRAM Self-Test Failure';'Test Pulse Seq Failure';'Nmon Counter Overflow';'DPSRAM Counter Overflow';...
                'Azimuth Line RX Error';'Acq or Processing Overrun';'Acquisition Clock Timeout';'Tool in air detected';...
                'Neutrons ON';'HV Monitor Error';'Board state (low bit)';'Board state (high bit)'; 'Error mode'}; 
            StatusWords.PNSW.(SWnames{end}).Status = 'PASSED';
            
            for ii= 1: size(SWbi,2)
                if ii < 15
                    activation = length(find(SWbi(twoBitIdx_0,ii)==1))/size(SWbi(twoBitIdx_0,ii),1)*100;
                else
                    activation = length(find(SWbi(:,ii)==1))/TotalRecords*100;
                end
                
                StatusWords.PNSW.(SWnames{ii}).Activation = activation;
                StatusWords.PNSW.(SWnames{ii}).Condition = condition{ii};
                StatusWords.PNSW.(SWnames{ii}).Description = description{ii};
                
                if any(ii == [1:5 14])
                    if activation > 1
                        StatusWords.PNSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.PNSW.(SWnames{ii}).OutageTime = timeData_twoBit0(find(SWbi(twoBitIdx_0,ii)==1));
                    elseif activation > 0
                        StatusWords.PNSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii==[6:11])
                    if activation > 1
                        StatusWords.PNSW.(SWnames{ii}).Status = 'WARNING';
                    end
               elseif any(ii ==16)
                    if activation > 3
                        StatusWords.PNSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.PNSW.(SWnames{ii}).OutageTime = timeData(find(SWbi(:,ii)==1));
                    elseif activation > 0.1
                        StatusWords.PNSW.(SWnames{ii}).Status = 'WARNING';
                    end
                    activation2 = length(twoBitIdx)/TotalRecords*100;
                    if activation2 > 1
                        StatusWords.PNSW.(SWnames{ii+1}).Status = 'FAILED';
                        StatusWords.PNSW.(SWnames{ii}).OutageTime = timeData_twoBit1;
                   elseif activation2 > 0.1
                        StatusWords.PNSW.(SWnames{ii+1}).Status = 'WARNING';
                    end
                    StatusWords.PNSW.(SWnames{ii+1}).Activation = activation2;
                end
                
            end
            StatusWords.PNSW.(SWnames{ii+1}).Condition = condition{ii+1};
            StatusWords.PNSW.(SWnames{ii+1}).Description = description{ii+1};
        case 'PSSW'
            StatusWords.PSSW.data = Status_channel;
            StatusWords.PSSW.SWbi = SWbi;
            condition = cell(16,1);
            condition([11 13:14])={'Warning: > 0%; Failed: >1%'};
            condition([4]) = {'Warning: > 1%'};
            %condition(16) = {'Warning: > 3%'};
            
            description = {'SAFETY ROP status'; 'password status:1';'24V threshold status';'21V threshold status';...
                'Temperature status';'Stop acquisition status';'Not in the air status';'Turbine powering status';...
                'password disabled or not';'downlink command status';'Voltage on capacitor bank';'Pressure threshold';...
                'Reference Pressure';'Pressure sub-sytem';'PNG state (low bit)';'PNG state (high bit)'}; 
            StatusWords.PSSW.(SWnames{end}).Status = 'PASSED';
            for ii= 1: size(SWbi,2)
                activation = length(find(SWbi(:,ii)==1))/TotalRecords*100;
                StatusWords.PSSW.(SWnames{ii}).Activation = activation;
                StatusWords.PSSW.(SWnames{ii}).Condition = condition{ii};
                StatusWords.PSSW.(SWnames{ii}).Description = description{ii};
                if any(ii == [11 13:14])
                    if activation > 1
                        StatusWords.PSSW.(SWnames{ii}).Status = 'FAILED';
                       StatusWords.PSSW.(SWnames{ii}).OutageTime = timeData(find(SWbi(:,ii)==1));
                    elseif activation > 0
                        StatusWords.PSSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii==[4])
                    if activation > 1
                        StatusWords.PSSW.(SWnames{ii}).Status = 'WARNING';
                    end
%                 elseif any(ii ==16)
%                     if activation > 3
%                         StatusWords.PSSW.(SWnames{ii}).Status = 'WARNING';
%                     end
                end
            end
            %StatusWords.PSSW.(SWnames{ii+1}).Description = description{ii+1};
        case 'DRSW'
%             Status_channel(CasingIndex)=[];
%             SWbi(CasingIndex,:)=[];
            StatusWords.DRSW.data = Status_channel;
            StatusWords.DRSW.SWbi = SWbi;
            condition = cell(16,1);
            condition([1:2 4 10:12 14])={'Warning: > 0%; Failed: >1%'};
            condition([3]) = {'Warning: > 1%'};
            condition([5:9]) = {'Warning: > 5%'};
            condition(16) = {'Warning: > 0.1%; Failed: >3%'};
            condition(17) = {'Warning: > 0.1%; Failed: >1%'};
            description = {'SRAM Self test';'CAN RX buf overflow err'; 'DDS Self test';'Receptors Self test';'Transmitter 1 status';...
                'Transmitter 2 status'; 'Transmitter 3 status';'Transmitter 4 status'; 'Transmitter 5 status';...
                'Receptors ADC status'; 'Slow Channels ADC status'; 'VDD Voltage status';'Undefined'; '20 status';...
                'Board state (low bit)';'Board state (high bit)'; 'Error mode'};
            StatusWords.DRSW.(SWnames{end}).Status = 'PASSED';
            
                                   
            for ii= 1: size(SWbi,2)
                if ii < 15
                    activation = length(find(SWbi(twoBitIdx_0,ii)==1))/size(SWbi(twoBitIdx_0,ii),1)*100;
                else
                    activation = length(find(SWbi(:,ii)==1))/TotalRecords*100;
                end
                StatusWords.DRSW.(SWnames{ii}).Activation = activation;
                StatusWords.DRSW.(SWnames{ii}).Condition = condition{ii};
                StatusWords.DRSW.(SWnames{ii}).Description = description{ii};
                if any(ii == [1:2 4 10:12 14])
                    if activation > 1
                        StatusWords.DRSW.(SWnames{ii}).Status = 'FAILED';
                       StatusWords.DRSW.(SWnames{ii}).OutageTime = timeData_twoBit0(find(SWbi(twoBitIdx_0,ii)==1));
                    elseif activation > 0
                        StatusWords.DRSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii ==[5:9])
                    cSWbi= SWbi;
                    cSWbi(CasingIndex,:)=[];
                    activation = length(find(cSWbi(:,ii)==1))/(TotalRecords-length(CasingIndex))*100;
                    StatusWords.DRSW.(SWnames{ii}).Activation = activation;
                    if activation > 5
                       StatusWords.DRSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii==3)
                    if activation > 1
                        StatusWords.DRSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii ==16)
                    if activation > 3
                        StatusWords.DRSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.DRSW.(SWnames{ii}).OutageTime = timeData(find(SWbi(:,ii)==1));
                    elseif activation > 0.1
                        StatusWords.DRSW.(SWnames{ii}).Status = 'WARNING';
                    end
                    
                    activation2 = length(twoBitIdx)/TotalRecords*100;
                    if activation2 > 1
                        StatusWords.DRSW.(SWnames{ii+1}).Status = 'FAILED';
                        StatusWords.DRSW.(SWnames{ii}).OutageTime = timeData_twoBit1;
                    elseif activation2 > 0.1
                        StatusWords.DRSW.(SWnames{ii+1}).Status = 'WARNING';
                    end
                    StatusWords.DRSW.(SWnames{ii+1}).Activation = activation2;
                end
            end
            StatusWords.DRSW.(SWnames{ii+1}).Condition = condition{ii+1};
            StatusWords.DRSW.(SWnames{ii+1}).Description = description{ii+1};
        case 'DGSW'
            StatusWords.DGSW.data = Status_channel;
            StatusWords.DGSW.SWbi = SWbi;
            condition = cell(16,1);
            condition([1:9 12])={'Warning: > 0%; Failed: >1%'};
            condition([10 11]) = {'Warning: > 1%'};
            condition(16) = {'Warning: > 0%; Failed: >3%'};
            condition(17) = {'Warning: > 0%; Failed: >1%'};
            description = {'SRAM Self-Test Failure';'CAN RX buf overflow err'; 'ADC Self-Test Failure';'DAC Self-Test Failure';'DPSRAM Self-Test Failure';...
                'Test Pulse Seq Failure'; 'Counts lost by FPGA bit';'Azimuth Line RX Error'; 'HV Monitor Error';...
                'Acq or Processing Overrun'; 'Acquisition Clock Timeout'; 'Densitiy Coef Error';'Undefined'; 'Board ID';...
                'Board state (low bit)';'Board state (high bit)'; 'Error mode'};
            StatusWords.DGSW.(SWnames{end}).Status = 'PASSED';
            
            
                      
            for ii= 1: size(SWbi,2)
                if ii < 15
                    activation = length(find(SWbi(twoBitIdx_0,ii)==1))/size(SWbi(twoBitIdx_0,ii),1)*100;
                else
                    activation = length(find(SWbi(:,ii)==1))/TotalRecords*100;
                end
                StatusWords.DGSW.(SWnames{ii}).Activation = activation;
                StatusWords.DGSW.(SWnames{ii}).Condition = condition{ii};
                StatusWords.DGSW.(SWnames{ii}).Description = description{ii};
                if any(ii == [1:9 12])
                    if activation > 1
                        StatusWords.DGSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.DGSW.(SWnames{ii}).OutageTime = timeData_twoBit0(find(SWbi(twoBitIdx_0,ii)==1));
                    elseif activation > 0
                        StatusWords.DGSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii==[10, 11])
                    if activation > 1
                        StatusWords.DGSW.(SWnames{ii}).Status = 'WARNING';
                    end
               elseif any(ii ==16)
                    if activation > 3
                        StatusWords.DGSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.DGSW.(SWnames{ii}).OutageTime = timeData(find(SWbi(:,ii)==1));
                    elseif activation > 0
                        StatusWords.DGSW.(SWnames{ii}).Status = 'WARNING';
                    end
                    activation2 = length(twoBitIdx)/TotalRecords*100;
                    if activation2 > 1
                        StatusWords.DGSW.(SWnames{ii+1}).Status = 'FAILED';
                        StatusWords.DGSW.(SWnames{ii}).OutageTime = timeData_twoBit1;
                    elseif activation2 > 0
                        StatusWords.DGSW.(SWnames{ii+1}).Status = 'WARNING';
                    end
                     StatusWords.DGSW.(SWnames{ii+1}).Activation = activation2;
                end
            end
            StatusWords.DGSW.(SWnames{ii+1}).Condition = condition{ii+1};
            StatusWords.DGSW.(SWnames{ii+1}).Description = description{ii+1};
        case 'PGSW'
            StatusWords.PGSW.data = Status_channel;
            StatusWords.PGSW.SWbi = SWbi;
            condition = cell(16,1);
            condition([1:6 9])={'Warning: > 0%; Failed: >1%'};
            condition([7:8 10:11]) = {'Warning: > 1%'};
            condition(16) = {'Warning: > 0.1%; Failed: >3%'};
            condition(17) = {'Warning: > 0.1%; Failed: >1%'};
            description = {'SRAM self test status'; 'CAN RX buf overflow err';'ADC Self-Test Failure';'DAC Self-Test Failure';...
                'DPSRAM Self-Test Failure';'Test Pulse Seq Failure';'Counts lost by FPGA bit';'Azimuth Line RX Error';...
                'HV Monitor Error';'Acq or Processing Overrun';'Acquisition Clock Timeout';'Undefined';...
                'Neutrons ON';'Board ID';'Board state (low bit)';'Board state (high bit)'; 'Error mode'}; 
            StatusWords.PGSW.(SWnames{end}).Status = 'PASSED';
            
                       
            for ii= 1: size(SWbi,2)
                if ii < 15
                    activation = length(find(SWbi(twoBitIdx_0,ii)==1))/size(SWbi(twoBitIdx_0,ii),1)*100;
                else
                    activation = length(find(SWbi(:,ii)==1))/TotalRecords*100;
                end
                StatusWords.PGSW.(SWnames{ii}).Activation = activation;
                StatusWords.PGSW.(SWnames{ii}).Condition = condition{ii};
                StatusWords.PGSW.(SWnames{ii}).Description = description{ii};
                
                if any(ii == [1:6 9])
                    if activation > 1
                        StatusWords.PGSW.(SWnames{ii}).Status = 'FAILED';
                       StatusWords.PGSW.(SWnames{ii}).OutageTime = timeData_twoBit0(find(SWbi(twoBitIdx_0,ii)==1));
                    elseif activation > 0
                        StatusWords.PGSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii==[7:8 10:11])
                    if activation > 1
                        StatusWords.PGSW.(SWnames{ii}).Status = 'WARNING';
                    end
               elseif any(ii ==16)
                    if activation > 3
                        StatusWords.PGSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.PGSW.(SWnames{ii}).OutageTime = timeData(find(SWbi(:,ii)==1));
                    elseif activation > 0.1
                        StatusWords.PGSW.(SWnames{ii}).Status = 'WARNING';
                    end
                    activation2 = length(twoBitIdx)/TotalRecords*100;
                    if activation2 > 1
                        StatusWords.PGSW.(SWnames{ii+1}).Status = 'FAILED';
                        StatusWords.PGSW.(SWnames{ii}).OutageTime = timeData_twoBit1;
                    elseif activation2 > 0.1
                        StatusWords.PGSW.(SWnames{ii+1}).Status = 'WARNING';
                    end
                     StatusWords.PGSW.(SWnames{ii+1}).Activation = activation2;
                end
                
            end
            StatusWords.PGSW.(SWnames{ii+1}).Condition = condition{ii+1};
            StatusWords.PGSW.(SWnames{ii+1}).Description = description{ii+1};
        case 'CSSW'
            StatusWords.CSSW.data = Status_channel;
            StatusWords.CSSW.SWbi = SWbi;
            condition = cell(16,1);
            condition([1:2 4:5 10])={'Warning: > 0%; Failed: >1%'};
            condition([3 8]) = {'Warning: > 1%'};
            condition(16) = {'Warning: > 0%; Failed: >3%'};
            condition(17) = {'Warning: > 0%; Failed: >1%'};
            description = {'SRAM self tests status';'CAN RX buf overflow err'; 'RTC access status';'SPI Communication Error';...
                'LookUp Table Error'; 'LTB Self-Tests Error';'Logging Memory Error'; 'Near Bit Inclination stat';...
                'Undefined'; 'NGR HV monitor Error'; 'Mode for WDP jobs';'Undefined'; 'Undefined';'Steady sub state';...
                'Board state (low bit)';'Board state (high bit)'; 'Error mode'};

            StatusWords.CSSW.(SWnames{end}).Status = 'PASSED';
            
                       
            for ii= 1: size(SWbi,2)
                if ii < 15
                    activation = length(find(SWbi(twoBitIdx_0,ii)==1))/size(SWbi(twoBitIdx_0,ii),1)*100;
                else
                    activation = length(find(SWbi(:,ii)==1))/TotalRecords*100;
                end
                StatusWords.CSSW.(SWnames{ii}).Activation = activation;
                StatusWords.CSSW.(SWnames{ii}).Condition = condition{ii};
                StatusWords.CSSW.(SWnames{ii}).Description = description{ii};
                if any(ii == [1:2 4:5 10])
                    if activation > 1
                        StatusWords.CSSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.CSSW.(SWnames{ii}).OutageTime = timeData_twoBit0(find(SWbi(twoBitIdx_0,ii)==1));
                    elseif activation > 0
                        StatusWords.CSSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii==[3, 8])
                    if activation > 1
                        StatusWords.CSSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii ==16)
                    if activation > 3
                        StatusWords.CSSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.CSSW.(SWnames{ii}).OutageTime = timeData(find(SWbi(:,ii)==1));
                    elseif activation > 0
                        StatusWords.CSSW.(SWnames{ii}).Status = 'WARNING';
                    end
                    activation2 = length(twoBitIdx)/TotalRecords*100;
                    if activation2 > 1
                        StatusWords.CSSW.(SWnames{ii+1}).Status = 'FAILED';
                        StatusWords.CSSW.(SWnames{ii}).OutageTime = timeData_twoBit1;
                    elseif activation2 > 0
                        StatusWords.CSSW.(SWnames{ii+1}).Status = 'WARNING';
                    end
                     StatusWords.CSSW.(SWnames{ii+1}).Activation = activation2;
                end
                
            end
            StatusWords.CSSW.(SWnames{ii+1}).Condition = condition{ii+1};
            StatusWords.CSSW.(SWnames{ii+1}).Description = description{ii+1};
        case 'DSSW'
            StatusWords.DSSW.data = Status_channel;
            StatusWords.DSSW.SWbi = SWbi;
            condition = cell(16,1);
            condition([1:2])={'Warning: > 0%; Failed: >1%'};
            condition([12]) = {'Warning: > 1%'};
            condition(16) = {'Warning: > 0%; Failed: >3%'};
            condition(17) = {'Warning: > 0%; Failed: >1%'};
            description = {'SRAM Self test status';'CAN RX buf overflow err'; 'SSn HV control loop stat';'Calibration mode';'Mg option set in conf.';...
                'Undefined'; 'Undefined';'Undefined'; 'Undefined';...
                'Undefined'; 'Undefined'; 'Computed In Time';'Undefined'; 'Undefined';...
                'Board state (low bit)';'Board state (high bit)'; 'Error mode'};
            StatusWords.DSSW.(SWnames{end}).Status = 'PASSED';
            
                       
            for ii= 1: size(SWbi,2)
                if ii < 15
                    activation = length(find(SWbi(twoBitIdx_0,ii)==1))/size(SWbi(twoBitIdx_0,ii),1)*100;
                else
                    activation = length(find(SWbi(:,ii)==1))/TotalRecords*100;
                end
                StatusWords.DSSW.(SWnames{ii}).Activation = activation;
                StatusWords.DSSW.(SWnames{ii}).Condition = condition{ii};
                StatusWords.DSSW.(SWnames{ii}).Description = description{ii};
            
                
                if any(ii==[1:2])
                    
                    if activation > 1
                        StatusWords.DSSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.DSSW.(SWnames{ii}).OutageTime = timeData_twoBit0(find(SWbi(twoBitIdx_0,ii)==1));
                    elseif activation > 0
                        StatusWords.DSSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii==[12])
                   
                    if activation > 1
                        StatusWords.DSSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii ==16)
                    if activation > 3
                        StatusWords.DSSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.DSSW.(SWnames{ii}).OutageTime = timeData(find(SWbi(:,ii)==1));
                    elseif activation > 0
                        StatusWords.DSSW.(SWnames{ii}).Status = 'WARNING';
                    end
                    activation2 = length(twoBitIdx)/TotalRecords*100;
                    if activation2 > 1
                        StatusWords.DSSW.(SWnames{ii+1}).Status = 'FAILED';
                        StatusWords.DSSW.(SWnames{ii}).OutageTime = timeData_twoBit1;
                    elseif activation2 > 0
                        StatusWords.DSSW.(SWnames{ii+1}).Status = 'WARNING';
                    end
                     StatusWords.DSSW.(SWnames{ii+1}).Activation = activation2;
                end
                
                
            end
            StatusWords.DSSW.(SWnames{ii+1}).Condition = condition{ii+1};
            StatusWords.DSSW.(SWnames{ii+1}).Description = description{ii+1};
        case 'MBSW'
            StatusWords.MBSW.data = Status_channel;
            StatusWords.MBSW.SWbi = SWbi;
            condition = cell(16,1);
            condition([1 2 4])={'Warning: > 0%; Failed: >1%'};
            condition([5 6 7 8]) = {'Warning: > 1%'};
            condition(16) = {'Warning: > 0%; Failed: >3%'};
            condition(17) = {'Warning: > 0%; Failed: >1%'};
            description = {'RAM self test status';'CAN RX buf overflow err'; 'Undefined';'CAN bus Error logging';...
                'Nb damaged chips bit 0'; 'Nb damaged chips bit 1';'Nb damaged chips bit 2'; 'Nb damaged chips bit 3';...
                'Memory usage lower bit'; 'Memory usage higher bit'; 'Recording data status';'RS format status'; 'Dump mode status';'Surface mode status';...
                'Board state (low bit)';'Board state (high bit)'; 'Error mode'};
            StatusWords.MBSW.(SWnames{end}).Status = 'PASSED';
            
                       
            for ii= 1: size(SWbi,2)
                if ii < 15
                    activation = length(find(SWbi(twoBitIdx_0,ii)==1))/size(SWbi(twoBitIdx_0,ii),1)*100;
                else
                    activation = length(find(SWbi(:,ii)==1))/TotalRecords*100;
                end
                StatusWords.MBSW.(SWnames{ii}).Activation = activation;
                StatusWords.MBSW.(SWnames{ii}).Condition = condition{ii};
                StatusWords.MBSW.(SWnames{ii}).Description = description{ii};
                if any(ii==[1 2 4])
                    
                    if activation > 1
                        StatusWords.MBSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.MBSW.(SWnames{ii}).OutageTime = timeData_twoBit0(find(SWbi(twoBitIdx_0,ii)==1));
                    elseif activation > 0
                        StatusWords.MBSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii==[5 6 7 8])
                    
                    if activation > 1
                        StatusWords.MBSW.(SWnames{ii}).Status = 'WARNING';
                    end
               elseif any(ii ==16)
                    if activation > 3
                        StatusWords.MBSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.MBSW.(SWnames{ii}).OutageTime = timeData(find(SWbi(:,ii)==1));
                    elseif activation > 0
                        StatusWords.MBSW.(SWnames{ii}).Status = 'WARNING';
                    end
                    activation2 = length(twoBitIdx)/TotalRecords*100;
                    if activation2 > 1
                        StatusWords.MBSW.(SWnames{ii+1}).Status = 'FAILED';
                        StatusWords.MBSW.(SWnames{ii}).OutageTime = timeData_twoBit1;
                    elseif activation2 > 0
                        StatusWords.MBSW.(SWnames{ii+1}).Status = 'WARNING';
                    end
                    StatusWords.MBSW.(SWnames{ii+1}).Activation = activation2;
                end
                
            end
            StatusWords.MBSW.(SWnames{ii+1}).Condition = condition{ii+1};
            StatusWords.MBSW.(SWnames{ii+1}).Description = description{ii+1};
        case 'DUSW'
            StatusWords.DUSW.data = Status_channel;
            StatusWords.DUSW.SWbi = SWbi;
            condition = cell(16,1);
            condition([1:5 7])={'Warning: > 0%; Failed: >1%'};
            condition([11:13]) = {'Warning: > 1%'};
            condition(16) = {'Warning: > 0%; Failed: >3%'};
            condition(17) = {'Warning: > 0%; Failed: >1%'};
            description = {'SRAM Self test status';'CAN RX buf overflow err'; 'Acq SRAM Self test';'US1 Sensor status';'US2 Sensor status';...
                'Undefined'; 'High-Voltage status';'Azimuth status'; 'Sliding or Rotating';...
                'Undefined'; 'US1 Detection/Fire ratio'; 'US2 Detection/Fire ratio';'Double Det/Fire ratio'; 'Undefined';...
                'Board state (low bit)';'Board state (high bit)'; 'Error mode'};
            StatusWords.DUSW.(SWnames{end}).Status = 'PASSED';
                        
            for ii= 1: size(SWbi,2)
                if ii < 15
                    activation = length(find(SWbi(twoBitIdx_0,ii)==1))/size(SWbi(twoBitIdx_0,ii),1)*100;
                else
                    activation = length(find(SWbi(:,ii)==1))/TotalRecords*100;
                end
                StatusWords.DUSW.(SWnames{ii}).Activation = activation;
                StatusWords.DUSW.(SWnames{ii}).Condition = condition{ii};
                StatusWords.DUSW.(SWnames{ii}).Description = description{ii};
                
                if any(ii==[1:5 7])
                    
                    if activation > 1
                        StatusWords.DUSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.DUSW.(SWnames{ii}).OutageTime = timeData_twoBit0(find(SWbi(twoBitIdx_0,ii)==1));

                    elseif activation > 0
                        StatusWords.DUSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii==[11:13])
                   
                    if activation > 1
                        StatusWords.DUSW.(SWnames{ii}).Status = 'WARNING';
                    end
                elseif any(ii ==16)
                    if activation > 3
                        StatusWords.DUSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.DUSW.(SWnames{ii}).OutageTime = timeData(find(SWbi(:,ii)==1));
                    elseif activation > 0
                        StatusWords.DUSW.(SWnames{ii}).Status = 'WARNING';
                    end
                    activation2 = length(twoBitIdx)/TotalRecords*100;
                    if activation2 > 1
                        StatusWords.DUSW.(SWnames{ii+1}).Status = 'FAILED';
                        StatusWords.DUSW.(SWnames{ii}).OutageTime = timeData_twoBit1;
                    elseif activation2 > 0
                        StatusWords.DUSW.(SWnames{ii+1}).Status = 'WARNING';
                    end
                     StatusWords.DUSW.(SWnames{ii+1}).Activation = activation2;
                end
                
            end
            StatusWords.DUSW.(SWnames{ii+1}).Condition = condition{ii+1};
            StatusWords.DUSW.(SWnames{ii+1}).Description = description{ii+1};
        case 'DDSW'
            StatusWords.DDSW.data = Status_channel;
            StatusWords.DDSW.SWbi = SWbi;
            condition = cell(16,1);
            condition([1:12])={'Warning: > 0%; Failed: >1%'};
            %condition([10 11]) = {'Warning: > 1%'};
            condition(16) = {'Warning: > 0%; Failed: >3%'};
            condition(17) = {'Warning: > 0%; Failed: >1%'};
            description = {'RAM Self test status';'CAN RX buf overflow err'; 'DPSRAM Self-Test Failure';'ADC Self-Test Failure';'Acc ampli Self-Test Fail';...
                'Azimuth Self-Test Failure'; 'DVME023 self-Test Failure';'DVME023 Calib not found'; 'Processing Overrun';...
                'Acc XYZ Self-test Failure'; 'Acc N Self-test Failure'; 'DAC Self-test Failure';'Pumps ON/OFF'; 'Board Hw Version';...
                'Board state (low bit)';'Board state (high bit)'; 'Error mode'};
            StatusWords.DDSW.(SWnames{end}).Status = 'PASSED';
             
                       
            for ii= 1: size(SWbi,2)
                if ii < 15
                    activation = length(find(SWbi(twoBitIdx_0,ii)==1))/size(SWbi(twoBitIdx_0,ii),1)*100;
                else
                    activation = length(find(SWbi(:,ii)==1))/TotalRecords*100;
                end
                StatusWords.DDSW.(SWnames{ii}).Activation = activation;
                StatusWords.DDSW.(SWnames{ii}).Condition = condition{ii};
                StatusWords.DDSW.(SWnames{ii}).Description = description{ii};
            
                
                if any(ii == [1:12])
                    if activation > 1
                        StatusWords.DDSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.DDSW.(SWnames{ii}).OutageTime = timeData_twoBit0(find(SWbi(twoBitIdx_0,ii)==1));
                    elseif activation > 0
                        StatusWords.DDSW.(SWnames{ii}).Status = 'WARNING';
                    end
%                 elseif any(ii==[10, 11])
%                     if activation > 1
%                         StatusWords.DDSW.(SWnames{ii}).Status = 'WARNING';
%                    end
                elseif any(ii ==16)
                    if activation > 3
                        StatusWords.DDSW.(SWnames{ii}).Status = 'FAILED';
                        StatusWords.DDSW.(SWnames{ii}).OutageTime = timeData(find(SWbi(:,ii)==1));
                    elseif activation > 0
                        StatusWords.DDSW.(SWnames{ii}).Status = 'WARNING';
                    end
                    activation2 = length(twoBitIdx)/TotalRecords*100;
                    if activation2 > 1
                        StatusWords.DDSW.(SWnames{ii+1}).Status = 'FAILED';
                        StatusWords.DDSW.(SWnames{ii}).OutageTime = timeData_twoBit1;
                    elseif activation2 > 0
                        StatusWords.DDSW.(SWnames{ii+1}).Status = 'WARNING';
                    end
                     StatusWords.DDSW.(SWnames{ii+1}).Activation = activation2;
                end
                
            end
            StatusWords.DDSW.(SWnames{ii+1}).Condition = condition{ii+1};
            StatusWords.DDSW.(SWnames{ii+1}).Description = description{ii+1};
    end
    
end
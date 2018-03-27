function channelData = DataFiltering(channelData)

%% use time jump to filter data
idx=find(diff(channelData(:,1))>10);

i=1;
removeTimeIdx=[];
removeValueIdx =[];
filterTime = 300; % 2 min or 5 min
while (i<=length(idx))
    
    %% filtering
    startTime = channelData(idx(i)+1,1);
    endTime = startTime + filterTime;
    
    if i == length(idx)
        if channelData(end,1)<= endTime
            removeTimeIdx = [removeTimeIdx idx(i)+1:size(channelData,1)];
            i = i+1;
        else
            endIdx = find(channelData(:,1)>endTime, 1 );
            removeTimeIdx = [removeTimeIdx idx(i)+1:endIdx];
            i=i+1;
        end
    else
        if endTime >=channelData(idx(i+1),1)
            removeTimeIdx = [removeTimeIdx idx(i)+1:idx(i+1)];
            i = i+1;
        else
            endIdx = find(channelData(:,1)>endTime, 1 );
            removeTimeIdx = [removeTimeIdx idx(i)+1:endIdx];
            i=i+1;
        end
        
    end
end
removeTimeIdx=unique(removeTimeIdx);
channelData(removeTimeIdx, :)= [];







function PNGIdx = PNGOnOFFFiltering(PNGIdx,idxno)
 % filter both sides
if length(PNGIdx)>2*idxno
    PNGOn_idx = find(diff(PNGIdx)>1);
    removePNGOnTimeIdx=[];
    if ~isempty(PNGOn_idx)
        
        if 2*idxno> PNGOn_idx(1)
            removePNGOnTimeIdx = 1: PNGOn_idx(1);
        else
            removePNGOnTimeIdx = [1:idxno PNGOn_idx(1)-idxno+1: PNGOn_idx(1)];
        end
        for jj = 1: length(PNGOn_idx)
            
            if jj == length(PNGOn_idx)
                if PNGOn_idx(jj)+2*idxno >= length(PNGIdx)
                    removePNGOnTimeIdx = [removePNGOnTimeIdx PNGOn_idx(jj)+1:length(PNGIdx)];
                    
                else
                    removePNGOnTimeIdx = [removePNGOnTimeIdx PNGOn_idx(jj)+1:PNGOn_idx(jj)+idxno];
                    removePNGOnTimeIdx = [removePNGOnTimeIdx length(PNGIdx)-idxno+1:length(PNGIdx)];
            
                end
            else
                if PNGOn_idx(jj)+2*idxno > PNGOn_idx(jj+1)
                    removePNGOnTimeIdx = [removePNGOnTimeIdx PNGOn_idx(jj)+1:PNGOn_idx(jj+1)];
                else
                    removePNGOnTimeIdx = [removePNGOnTimeIdx PNGOn_idx(jj)+1:PNGOn_idx(jj)+idxno];
                    removePNGOnTimeIdx = [removePNGOnTimeIdx PNGOn_idx(jj+1)-idxno+1:PNGOn_idx(jj+1)];
                end
            end
        end
        removePNGOnTimeIdx = unique(removePNGOnTimeIdx);
        
    else
        % no more on/off, so filter the first and last of the idx
        removePNGOnTimeIdx = [1:idxno length(PNGIdx)-idxno+1:length(PNGIdx)];
    end
    PNGIdx(removePNGOnTimeIdx)=[];
else
    % data is too short
    PNGIdx = [];
end


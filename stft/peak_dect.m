function peak=peak_dect(diff,c1,c2)
frame_num=size(diff,1);
max_diff=max(diff);
init_threshold=c1*max_diff;
peak=zeros(frame_num,1);
for k=2:frame_num-1
    %     find a peak
    if diff(k)>=diff(k-1) && diff(k)>=diff(k+1)
        peak(k)=diff(k);
    end
    
    if peak(k)==0
        continue;
    end
    %     get the threshold
    if k>10 && k<frame_num-10
        temp_peak=median(diff(k-10:k+10));
    else if k<10
            temp_peak=median(diff(1:10));
        else
            temp_peak=median(diff(frame_num-10:frame_num));
        end
    end
    threshold=init_threshold+c2*temp_peak;
    if peak(k)<threshold
        peak(k)=0;
    else
        peak(k)=diff(k);
    end
end
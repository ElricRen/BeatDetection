% EXAMPLE Simple demo of the MFCC function usage.
%
%   This script is a step by step walk-through of computation of the
%   mel frequency cepstral coefficients (MFCCs) from a speech signal
%   using the MFCC routine.
%
%   See also MFCC, COMPARE.

%   Author: Kamil Wojcicki, September 2011


% Clean-up MATLAB's environment
clear;clc;clf;

for train_num=1:20
    % Define variables
    Tw = 4;                % analysis frame duration (ms)25
    Ts = 2;                % analysis frame shift (ms)10
    alpha = 0.97;           % preemphasis coefficient
    M = 20;                 % number of filterbank channels
    C = 12;                 % number of cepstral coefficients
    L = 22;                 % cepstral sine lifter parameter
    LF = 300;               % lower frequency limit (Hz)
    HF = 22050;              % upper frequency limit (Hz)3700
    wav_file = ['E:/毕设/train_beat/train',num2str(train_num),'.wav'];  % input audio filename
    
    
    % Read speech samples, sampling rate and precision from file
    [ speech, fs ] = audioread( wav_file );
    speech=speech(44100*0+1:44100*30);%fs=44100
    speech=decimate(speech,10);   %降采样
    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] = ...
        mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    
    
    % Generate data needed for plotting
    [ Nw, NF ] = size( frames );                % frame length and number of frames
    time_frames = [0:NF-1]*Ts*0.001+0.5*Nw/fs;  % time vector (s) for frames
    time = [ 0:length(speech)-1 ]/fs;           % time vector (s) for signal samples
    logFBEs = 20*log10( FBEs );                 % compute log FBEs for plotting
    logFBEs_floor = max(logFBEs(:))-50;         % get logFBE floor 50 dB below max
    logFBEs( logFBEs<logFBEs_floor ) = logFBEs_floor; % limit logFBE dynamic range
    
    %
    % %     Generate plots
    %         figure('Position', [30 30 800 600], 'PaperPositionMode', 'auto', ...
    %                   'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' );
    %
    %         subplot( 311 );
    %         plot( time, speech, 'k' );
    %         xlim( [ min(time_frames) max(time_frames) ] );
    %         xlabel( 'Time (s)' );
    %         ylabel( 'Amplitude' );
    %         title( 'Speech waveform');
    %
    %         subplot( 312 );
    %         imagesc( time_frames, [1:M], logFBEs );
    %         axis( 'xy' );
    %         xlim( [ min(time_frames) max(time_frames) ] );
    %         xlabel( 'Time (s)' );
    %         ylabel( 'Channel index' );
    %         title( 'Log (mel) filterbank energies');
    %
    %         subplot( 313 );
    %
    %         imagesc( time_frames, [1:C], MFCCs(2:end,:) ); % HTK's TARGETKIND: MFCC
    %         %imagesc( time_frames, [1:C+1], MFCCs );       % HTK's TARGETKIND: MFCC_0
    %         axis( 'xy' );
    %         xlim( [ min(time_frames) max(time_frames) ] );
    %         xlabel( 'Time (s)' );
    %         ylabel( 'Cepstrum index' );
    %         title( 'Mel frequency cepstrum' );
    %
    %         % Set color map to grayscale
    %         colormap( 1-colormap('gray') );
    %
    %         % Print figure to pdf and png files
    %         print('-dpdf', sprintf('%s.pdf', mfilename));
    %         print('-dpng', sprintf('%s.png', mfilename));
    diff_c = zeros(NF,1);
    temp_c = zeros(C,1);
    for i=1:NF
        for j=1:C
            temp_c(j) = j*MFCCs(j,i);      
        end
        diff_c(i) = abs(sum(temp_c));
    end
    
%     diff_cc = zeros(NF,1);
%     temp_cc = zeros(C,1);
%     for i=1:NF-2
%         for j=1:C
%             temp_cc(j) = ((MFCCs(j,i+1)) - (MFCCs(j,i)));
%             %  temp_cc(j)=MFCCs(j,i+2)+2*MFCCs(j,i)-MFCCs(j,i+1);
%             %             不计算当前帧较上一帧能量衰减的部分   还有问题
%             if temp_cc(j)<0
%                 disp(sprintf('get it：%f-%f=%f',MFCCs(j+1,i+1),MFCCs(j+1,i),temp_cc(j)));
%                 temp_cc(j)=0;
%                 %              temp_cc(j)=(abs(temp_cc(j)));
%             end
%             
%         end
%         diff_cc(i+1) = sum(temp_cc);
%     end
    
    
    
    
    % plot(speech);
    % hold on;
    % beatIndex = [0.852	2.245	3.464	4.764	6.181	7.603	8.973	10.320	11.765	13.193	14.302	15.602	16.943	18.261...
    %     19.544	20.763	22.023	23.404	24.652	26.011	27.293	28.634	29.970];
    % beat=zeros(NF,1);
    % beat(round(beatIndex.*fs/(Ts*44.1*10))) = max(diff_cc)/2;
    % plot(beat,'*');
    
    %节拍位置标注
    beat=zeros(NF,1);
    beat_index=txt_read(['E:/毕设/train_beat/train',num2str(train_num),'.txt'],100);
    for i=1:100
        index=round(beat_index{i,1}*fs/(Ts*44.1*10));
        beat(index)=max(diff_c);
    end
    
    
    
%     frame_num=NF;
%     max_diff=max(diff_cc);
%     init_threshold=0.24*max_diff;
%     %     init_threshold=0.1;
%     peak=zeros(frame_num,1);
%     for k=2:frame_num-1
%         %     find a peak
%         if diff_cc(k)>=diff_cc(k-1) && diff_cc(k)>=diff_cc(k+1)
%             peak(k)=diff_cc(k);
%         end
%         
%         if peak(k)==0
%             continue;
%         end
%         %     get the threshold
%         if k>10 && k<frame_num-10
%             temp_peak=median(diff_cc(k-10:k+10));
%         else if k<10
%                 temp_peak=median(diff_cc(1:10));
%             else
%                 temp_peak=median(diff_cc(frame_num-10:frame_num));
%             end
%         end
%         threshold=init_threshold+1.2*temp_peak;
%         if peak(k)<threshold
%             peak(k)=0;
%         else
%             peak(k)=max(diff_cc);
%         end
%     end
    figure(1);
    plot(diff_c);
    % plot(MFCCs);
    title(['MFCC of train',num2str(train_num),'.wav']);
    hold on;
    plot(beat,'r');
%     hold on;
%     plot(peak,'o');
    set(1,'position',[0,0,1900,800]);
    A=getframe(1);
    imwrite(A.cdata,['E:\毕设\result\mfcc\1_train',num2str(train_num),'.jpg']);
    clc;clear;clf;
end
% EOF

clc;clear;close all



% figure
color_list=[52  148 186;
            236 112 22;
            58, 191, 153]/255;
xlabe_list={'A','B','C','D'};
Fs=128;

%%                                      ||Plot Psd of Observed signal ||
ax(1)=subplot(2,2,1);
for k=1:3
    for i=1:20
        if k==1
            data = eegdata{i};
        elseif k==2
            data =mcs{i};
        else
            data =uws{i};
        end
        data2=[];
        for j=1:size(data,1)
            data2=[data2 data(j,:)];
        end
        data2=zscore(data2-mean(data2));
        [pxx, f] = pwelch(data2,  hamming(128),56, Fs/0.1, Fs);  % 使用 pwelch 估计 PSD
        f2=f(f>=2 & f<=20);
        pxx=pxx(f>=2  & f<=20);
        psd(i,:)=pxx/sum(pxx);
    end
    [h1(k), h2]=plot_erroryst(psd,f2,color_list(k,:));
    hold on
    clear psd
end
title('Observed data')
xlabel('Frequency(Hz)')
ylabel({'Normalised power'})
ylim([0 0.05])
xlim([2 20])
text(-0.2, 1.05, xlabe_list{1}, 'Units', 'normalized');

%%                                      ||Plot Psd of Fitted signal ||
ax(2)=subplot(2,2,2);
for k=1:3
    for sub=1:20
        data2=[];
        for i=1:20
            if k==1
                load(['D:\nmm\result_hc\data_JR_hc_' num2str(sub) '_' num2str(i)])
            elseif k==2
                load(['D:\nmm\result_doc\data_JR_mcs_' num2str(sub) '_' num2str(i)])
            else
                load(['D:\nmm\result_doc\data_JR_uws_' num2str(sub) '_' num2str(i)])
            end
            b=gen_data_JR(Pos);
            data=zscore(b-mean(b));
            data2=[data2 data];
        end
        [pxx, f] = pwelch(data2,  hamming(128),56, Fs/0.1, Fs);  % 使用 pwelch 估计 PSD
        f2=f(f>=2 & f<=20);
        pxx=pxx(f>=2  & f<=20);
        psd(sub,:)=pxx/sum(pxx);
    end
    [h1(k), h2]=plot_erroryst(psd,f2,color_list(k,:));
    hold on
    clear psd
end
title('Fitted data')
% set(gca, 'YTick', []);
xlabel('Frequency(Hz)')
ylabel({'Normalised power'})
ylim([0 0.05])
xlim([2 20])
text(-0.2, 1.05, xlabe_list{2}, 'Units', 'normalized');
legend(h(1:6),{'HC mean','MCS mean','UWS mean','HC std','MCS std','UWS std'},'NumColumns', 6,'Box', 'on')

%%                                      ||Plot Power proportion of Observed signal ||
freqRanges = [1 4;4 8;8 13;13 30;30 45];  % δ、θ、α、β、γ 波段频率范围
ax(3)=subplot(2,2,3);

for k=1:3
    for i=1:20
        if k==1
            data = eegdata{i};
        elseif k==2
            data =mcs{index_mcs(i)};
        else
            data =uws{index_uws(i)};
        end
        data2=[];
        for j=1:size(data,1)
            data2=[data2 data(j,:)];
        end
        data2=zscore(data2-mean(data2));
        [pxx, f] = pwelch(data2,  hamming(128),56, Fs/0.1, Fs);  % 使用 pwelch 估计 PSD
        for j = 1:size(freqRanges, 1)
            freqIdx = (f >= freqRanges(j, 1)) & (f <= freqRanges(j, 2));
            Power(k,i,j) = sum(pxx(freqIdx))/sum(pxx((1 <= f) & (f <= 45)));
            clear freqIdx
        end
    end
end
data_mean=squeeze(mean(Power,2))';
data_std =squeeze(std(Power,0,2))';
b=bar({'Delta','Theta','Alpha','Beta','Gamma'},data_mean,'FaceColor','flat');box off
for i = 1 : size(data_mean,1)
    for j = 1 : size(data_mean,2)
        b(1, j).FaceColor  = 'flat';
        b(1, j).CData(i,:) = color_list(j,:);
        b(1, j).EdgeColor  = 'flat';
    end
end

% 获取误差线 x 值
xx = zeros(size(data_mean,1), size(data_mean,2));
for i = 1 : size(data_mean,2)
    xx(:, i) = b(1, i).XEndPoints';
end
% 绘制误差线
hold on
errorbar(xx, data_mean, data_std, data_std, 'LineStyle', 'none', 'Color', 'k', 'LineWidth', 1);
ylim([0 1])
ylabel('Power proportion')
legend('HC','MCS','UWS','Box','off')
text(-0.2, 1.05, xlabe_list{3}, 'Units', 'normalized');

%%                                      ||Plot Power proportion of Fitted signal ||
freqRanges = [1 4;4 8;8 13;13 30;30 45];  % δ、θ、α、β、γ 波段频率范围
ax(4)=subplot(2,2,4);

for k=1:3
    for sub=1:20
        data2=[];
        for i=1:20
            if k==1
                load(['D:\nmm\result_hc\data_JR_hc_' num2str(sub) '_' num2str(i)])
            elseif k==2
                load(['D:\nmm\result_doc\data_JR_mcs_' num2str(sub) '_' num2str(i)])
            else
                load(['D:\nmm\result_doc\data_JR_uws_' num2str(sub) '_' num2str(i)])
            end
            b=gen_data_JR(Pos);
            data=zscore(b-mean(b));
            data2=[data2 data];
        end
        [pxx, f] = pwelch(data2,  hamming(128),56, Fs/0.1, Fs);  % 使用 pwelch 估计 PSD
        for j = 1:size(freqRanges, 1)
            freqIdx = (f >= freqRanges(j, 1)) & (f <= freqRanges(j, 2));
            Power(k,sub,j) = sum(pxx(freqIdx))/sum(pxx((1 <= f) & (f <= 45)));
            clear freqIdx
        end
    end
end
data_mean=squeeze(mean(Power,2))';
data_std =squeeze(std(Power,0,2))';
b=bar({'Delta','Theta','Alpha','Beta','Gamma'},data_mean,'FaceColor','flat');box off

for i = 1 : size(data_mean,1)
    for j = 1 : size(data_mean,2)
        b(1, j).FaceColor  = 'flat';
        b(1, j).CData(i,:) = color_list(j,:);
        b(1, j).EdgeColor  = 'flat';
    end
end

% 获取误差线 x 值
xx = zeros(size(data_mean,1), size(data_mean,2));
for i = 1 : size(data_mean,2)
    xx(:, i) = b(1, i).XEndPoints';
end
% 绘制误差线
hold on
errorbar(xx, data_mean, data_std, data_std, 'LineStyle', 'none', 'Color', 'k', 'LineWidth', 1);
ylim([0 1])
ylabel('Power proportion')
legend('HC','MCS','UWS','Box','off')
text(-0.2, 1.05, xlabe_list{4}, 'Units', 'normalized');

%%  全局属性
axesHandles = findall(gcf, 'Type', 'axes'); %获取所有子图的刻度属性
set(axesHandles, 'LineWidth', 1.2);   %刻度的线宽设置为1.2
set(axesHandles, 'FontSize' , 12);    %刻度的字体设置为12
set(findall(gcf, 'Type', 'line'), 'LineWidth', 1.2);          %所有线宽设置为1.2
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12);   %所有字体大小设置为12
set(findall(gcf, '-property', 'FontWeight'), 'FontWeight', 'bold');%所有属性均加粗
set(gcf, 'Position', [260, 140, 800, 600]); %设置图窗的位置（660,340）和大小（800, 600）
% for i=1:4
%     postion(i,:)=ax(i).Position;
% end
ax(1).Position=[0.12 0.55 0.34 0.34];
ax(2).Position=[0.60 0.55 0.34 0.34];
ax(3).Position=[0.12 0.09 0.34 0.34];
ax(4).Position=[0.60 0.09 0.34 0.34];
% %% 保存当前图窗为tiff格式的图像
print(gcf, 'D:\nmm\figure\plot_07_allpsd.tiff', '-dtiff', '-r600');
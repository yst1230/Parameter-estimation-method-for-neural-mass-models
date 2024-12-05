clc;clear;close all

rng(1)
addpath(genpath('D:\toolbox\EntropyHub'))
% figure
color_list=[52  148 186;
            236 112 22;
            58, 191, 153]/255;

xlabe_list={'A','B','C','D'};
Fs=128;

%                                      ||Plot wHVG of Observed signal||
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
        data2=mean(data);
        data2=zscore(data2-mean(data2));
        vg= fast_HVG(data2, linspace(0,5,length(data2)), 'w');
        d1= full(sum(vg));
        [ks(i,:),xi]=ksdensity(d1,linspace(-1, 1, 200));
    end
    [h1(k), h2]=plot_erroryst(ks,xi',color_list(k,:));
    hold on
end
title('Observed data')
ylim([0 inf])
xlabel('wHVG node degree')
ylabel({'Normalised frequency'})
text(-0.2, 1.05, xlabe_list{1}, 'Units', 'normalized');


%%                                      ||Plot wHVG of Observed2 signal||
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
        vg= fast_HVG(data2, linspace(0,5,length(data2)), 'w');
        d1= full(sum(vg));
        [ks(sub,:),xi]=ksdensity(d1,linspace(-1, 1, 200));
    end
    [h(k), h(k+3)]=plot_erroryst(ks,xi',color_list(k,:));
    hold on
end

title('Fitted data')
ylim([0 inf])
xlabel('wHVG node degree')
ylabel({'Normalised frequency'})
legend(h(1:6),{'HC mean','MCS mean','UWS mean','HC std','MCS std','UWS std'},'NumColumns', 6,'Box', 'on')
text(-0.2, 1.05, xlabe_list{2}, 'Units', 'normalized');

%%  entropy of different frequency bands
ax(3)=subplot(2,2,3);
freqRanges = [2 4;4 8;8 13;13 30;30 45];
for k=1:3
    for i=1:20
        if k==1
            data = eegdata{i};
        elseif k==2
            data =mcs{i};
        else
            data =uws{i};
        end
        data2=mean(data);
        data2=zscore(data2-mean(data2));
        for j=1:5
            [b,a]=butter(3,[freqRanges(j,:)]/(Fs/2));
            f_data=filtfilt(b,a,data2);
            P = ApEn (f_data,  'm', 5, 'tau', 1);
            Perm(k,i,j) = P(end);
        end
        P = ApEn (data2,  'm', 5, 'tau', 1);
        Perm(k,i,6) = P(end);
    end
end
data_mean=squeeze(mean(Perm,2))';
data_std =squeeze(std(Perm,0,2))';


b=bar({'Delta','Theta','Alpha','Beta','Gamma','WFB'},data_mean,'FaceColor','flat');box off

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
ylim([0,0.8])
ylabel('Approximate entropy')
legend('HC','MCS','UWS','Box','off')
text(-0.2, 1.05, xlabe_list{3}, 'Units', 'normalized');


%%  entropy of different frequency bands
ax(4)=subplot(2,2,4);
freqRanges = [2 4;4 8;8 13;13 30;30 45];
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
        for j=1:5
            [b,a]=butter(3,[freqRanges(j,:)]/(Fs/2));
            f_data=filtfilt(b,a,data2);
            P = ApEn (f_data,  'm', 5, 'tau', 1);
            Perm(k,i,j) = P(end);
        end
        P = ApEn (data2,  'm', 5, 'tau', 1);
        Perm(k,i,6) = P(end);
    end
end

data_mean=squeeze(mean(Perm,2))';
data_std =squeeze(std(Perm,0,2))';

b=bar({'Delta','Theta','Alpha','Beta','Gamma','WFB'},data_mean,'FaceColor','flat');box off
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

ylim([0,0.8])
ylabel('Approximate entropy')
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
print(gcf, 'D:\nmm\figure\plot_08_hvg_entropy.tiff', '-dtiff', '-r600');
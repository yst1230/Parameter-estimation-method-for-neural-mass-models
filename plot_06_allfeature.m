clc;clear;close all
addpath(genpath('D:\nmm'))
addpath(genpath('D:\toolbox\EntropyHub'))
rng(2)
Fs=128;
xlabe_list={'A','B','C','D'};
%% define colors for plotting
c1 = [0 0 0];
c2 = [51, 153, 255]/255; 
c3 = [0/255,0/255,153/255];
c4 = [0.6, 0, 0.6]; 
c5 = [0.6350 0.0780 0.1840];
ctot = [c5;c4;c3;c2;c1];
%% Plot Amp
ax(1)=subplot(4,4,[1,2,5,6]);
for k=1:5
    for i=1:20
        if k==5
            Pos=[3.25 22 135];
        else
            load(['D:\nmm\result_JR\data_S' num2str(k) '_' num2str(i)])
        end
        b=gen_data_JR(Pos);
        b = b-mean(b);
        OutS(i,:)=zscore(b);
    end
    data(:,k)=mean(OutS);
end

h1=offplot1(data,1.25,linspace(0,5,640),ctot);box off

box off
set(gca,'ytick', []);
set(gca,'TickDir','out');
xlim([0,5])
ylim([-1,6])
xlabel({'Time (s)'})
ylabel('Z-scored amplitude')
title('Time series')
text(-0.2, 1.1, xlabe_list{1}, 'Units', 'normalized','FontSize',15);

%% plot psd
ax(2)=subplot(4,4,[3,4,7,8]);
for k=1:5
    [pxx,f] = pwelch(data(:,k),hamming(128),56,Fs/0.1,Fs);
    f2=f(f>=2 & f<=20);
    pxx=pxx(f>=2 & f<=20);
    psd2=pxx/sum(pxx);
    plot(f2,psd2,'Color',ctot(k,:))
    hold on
end
hold off


box off
set(gca,'TickDir','out');
xlim([2,20])
xlabel({'Frequency (Hz)'})
ylabel('Normalised power')
title('PSD')
text(-0.2, 1.1, xlabe_list{2}, 'Units', 'normalized');
%% plot hvg
ax(3)=subplot(4,4,[9,10,13,14]);
for k=1:5
    vg= fast_HVG(data(:,k), linspace(0,5,length(OutS)), 'w');
    d1 = full(sum(vg));
    [ks,xi]=ksdensity(d1,linspace(-1, 1, 200));
    h(k)=plot(xi,ks,'Color',ctot(k,:));
    hold on
end
hold off

box off
set(gca,'TickDir','out');
xlabel({'wHVG node degree'})
ylabel('Normalised frequency')
title('wHVG')
text(-0.2, 1.1, xlabe_list{3}, 'Units', 'normalized');
legend(h([1 2 3 4 5]),{'Loss1','Loss2','Loss3','Loss4','Observed'},'NumColumns', 5, 'Box', 'on')

%% plot entropy

ax(4)=subplot(4,4,[11,12,15,16]);
for k=1:5
    for i=1:20
        if k==5
            Pos1=[3.25 22 135];
        else
            load(['D:\nmm\result_JR\data_S' num2str(k) '_' num2str(i)])
        end
        b=gen_data_JR(Pos1);
        b = b-mean(b);
        P = ApEn (zscore(b),  'm', 5, 'tau', 1);
        Perm(i,k) = P(end);
    end
end

data2=[Perm(:,1) Perm(:,2) Perm(:,3) Perm(:,4) Perm(:,5)];
g = [zeros(1,20),ones(1,20),2*ones(1,20),3*ones(1,20)];
v1 = violinplot(data2,g,'ViolinColor',ctot);
p1 = ranksum(Perm(:,1),Perm(:,5));
p2 = ranksum(Perm(:,2),Perm(:,5));
p3 = ranksum(Perm(:,3),Perm(:,5));
p4 = ranksum(Perm(:,4),Perm(:,5));
xticks(1:5)
xticklabels({'Loss1';'Loss2';'Loss3';'Loss4';'Observed'});
H1=sigstar({{'Loss1','Observed'}},p1);
H2=sigstar({{'Loss2','Observed'}},p2);
H3=sigstar({{'Loss3','Observed'}},p3);
H4=sigstar({{'Loss4','Observed'}},p4);


box off
set(gca,'TickDir','out');
ylim([0,0.7])
title('Approximate entropy')
text(-0.2, 1.1, xlabe_list{4}, 'Units', 'normalized');
%% 调整子图的位置
for i=1:4
    postion(i,:)=ax(i).Position;
end
ax(1).Position=[0.13 0.57 0.34 0.34];
ax(2).Position=[0.60 0.57 0.34 0.34];
ax(3).Position=[0.13 0.09 0.34 0.34];
ax(4).Position=[0.60 0.09 0.34 0.34];
%% 全局属性设置
axesHandles = findall(gcf, 'Type', 'axes'); 
set(axesHandles, 'LineWidth', 1.2);   
set(axesHandles, 'FontSize' , 12);    
set(findall(gcf, 'Type', 'line'), 'LineWidth', 1.2);          
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12);   
set(findall(gcf, '-property', 'FontWeight'), 'FontWeight', 'bold');
set(gcf, 'Position', [600, 300, 800, 660]); 
%% Save the current figure as an image in  tiff format
print(gcf, 'D:\nmm\figure\plot_06_all_feature.tiff', '-dtiff', '-r600');

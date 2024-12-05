
clc;clear;close all
rng(2)
xlabe_list={'A','B','C','D'};

addpath(genpath('D:\nmm'))
for k=1:4
    for j=1:3
        for i=1:20
            load(['D:\nmm\result_JR\data_S' num2str(k) '_' num2str(i)])
            bias(k,i,j)=Pos(j);
        end
    end
end

Ground_truth=[3.25 22 135 6];
lb=[2.6  17.6  108 3.12 ];
ub=[9.75 110   200 9    ];

for k=1:4
    for j=1:4
        for i=1:20
            bias1(k,i,j)=abs(bias(k,i,j)-Ground_truth(j))/Ground_truth(j);
        end
    end
end

for i=1:3
    for j=1:4
        p(i,j) = ranksum(squeeze(bias1(i,:,j)),squeeze(bias1(4,:,j)));
    end
end

plists={'A';'B';'C';'v_0'};
for i=1:4
    ax(i)=subplot(2,2,i);
    boxchart(squeeze(bias(:,:,i))','MarkerStyle','none')
    hold on
    for k=1:4
        h(k)=scatter(k * ones(20, 1), squeeze(bias(k,:,i)),'filled', 'jitter', 'on', 'jitterAmount', 0.1);
        hold on
        h(5)=yline(Ground_truth(i),'--',Ground_truth(i),'color',[0.6, 0.6, 0.6],'LineWidth',1,...
            'Fontsize',10,'LabelVerticalAlignment', 'top');
        hold on
        ylim([lb(i) ub(i)])
        title({['Parameter ' plists{i}]})
        yticks([lb(i)  ub(i)])
        xticks([])
        text(-0.2, 1.1, xlabe_list{i}, 'Units', 'normalized','FontWeight','bold');
    end
end
legend(h([1 2 3 4 5]),{'Loss1','Loss2',...
    'Loss3','Loss4','Ground truth'},'NumColumns', 5, 'Box', 'on')



axesHandles = findall(gcf, 'Type', 'axes'); 
set(axesHandles, 'LineWidth', 1.2);  
set(axesHandles, 'FontSize' , 12);    
set(findall(gcf, 'Type', 'line'), 'LineWidth', 1.2);          
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12);   
set(findall(gcf, '-property', 'FontWeight'), 'FontWeight', 'bold');
set(gcf, 'Position', [260, 140, 800, 600]); 
% for i=1:4
%     postion(i,:)=ax(i).Position;
% end
ax(1).Position=[0.14 0.53 0.34 0.34];
ax(2).Position=[0.58 0.53 0.34 0.34];
ax(3).Position=[0.14 0.08 0.34 0.34];
ax(4).Position=[0.58 0.08 0.34 0.34];
%% Save the current figure as an image in tiff format
print(gcf, 'D:\nmm\figure\plot_05_bias.tiff', '-dtiff', '-r600');


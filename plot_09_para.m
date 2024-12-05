clc;clear;close all
addpath(genpath('D:\工程设计的优化问题'))
color_list=[52  148 186;
    236 112 22;
    58, 191, 153]/255;
xlabe_list={'A','B','C','D'};

p_list={'Parameter A','Parameter B','Parameter C','Parameter v_0'};
for k=1:3
    for sub=1:20
        for i=1:20
            if k==1
                load(['D:\工程设计的优化问题\改进\result_hc\data_JR_hc_' num2str(sub) '_' num2str(i) '.mat'])
            elseif k==2
                load(['D:\工程设计的优化问题\改进\result_doc\data_JR_mcs_' num2str(sub) '_' num2str(i) '.mat'])
            else
                load(['D:\工程设计的优化问题\改进\result_doc\data_JR_uws_' num2str(sub) '_' num2str(i) '.mat'])
            end
        end
        all_pos(i,:)=Pos;
    end
    all_pos2(k,sub,:)=mean(all_pos);
end
save all_pos2 all_pos2

data_mean=mean(all_pos2,2);
data_std =mean(all_pos2,0,2);

box off
grid off
for k=1:4
    ax(k)=subplot(2,2,k);
    b=bar(data_mean(k,:),'FaceColor','flat','BarWidth', 0.5);box off
    for j = 1 : 3
        b.FaceColor  = 'flat';
        b.CData(j,:)= color_list(j,:);
        b.EdgeColor  = 'flat';
    end

    xticks(1:3);
    xticklabels({'HC','MCS','UWS'})
    % 获取误差线 x 值
    xx = zeros(size(data_mean(k,:),1), size(data_mean(k,:),2));
    xx = b.XEndPoints';
    % 绘制误差线
    hold on
    errorbar(xx, data_mean(k,:), data_std(k,:), data_std(k,:), 'LineStyle', 'none', 'Color', 'k', 'LineWidth', 1);
    title(p_list{k})

    text(-0.2, 1.1, xlabe_list{k}, 'Units', 'normalized','FontWeight','bold');
end
set(gcf, 'Renderer', 'painters');
axesHandles = findall(gcf, 'Type', 'axes'); %获取所有子图的刻度属性
set(axesHandles, 'LineWidth', 1.2);   %刻度的线宽设置为1.2
set(axesHandles, 'FontSize' , 12);    %刻度的字体设置为12
set(findall(gcf, 'Type', 'line'), 'LineWidth', 1.2);          %所有线宽设置为1.2
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12);   %所有字体大小设置为12
set(findall(gcf, '-property', 'FontWeight'), 'FontWeight', 'bold');%所有属性均加粗
set(gcf, 'Position', [260, 140, 800, 600]); %设置图窗的位置（660,340）和大小（800, 600）
for i=1:4
    postion(i,:)=ax(i).Position;
end


% %% 保存当前图窗为tiff格式的图像
print(gcf, 'D:\nmm\figure\plot_09_para.tiff', '-dtiff', '-r600');
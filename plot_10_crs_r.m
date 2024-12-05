clc;clear;close all
addpath(genpath('D:\nmm'))
rng(6)
load all_pos2
load crs_r_diagnosis
color_list=[52  148 186;
    236 112 22;
    58, 191, 153]/255;
xlabe_list={'Parameter A','Parameter B','Parameter C','Parameter v0'};
title_list={'A','B','C','D'};
method_list={'Power distribution','Approximate entropy','Model parameters'};
ylim_list=[2.5 5.5;15 45;100 180;2 11];
doc_crs=[crsr_mcs;crsr_uws];
x=sum(doc_crs(:,1:6),2)';
figure
for i=1:4
    subplot(2,2,i)
    y=[squeeze(all_pos2(2,:,i)) squeeze(all_pos2(3,:,i))];
    plot(x,y,'bx');box off
    hold on
    [p,s]= polyfit(x, y, 1);
    [yfit,dy] = polyconf(p,x,s,'predopt','curve'); % 多项式的置信区间
    hold on;
    line(x, yfit,'Color','r');
    hold off
    xlabel('CRS-R')
    ylabel(xlabe_list{i})
    [R, P] = corr(x', y');
    if P < 0.05
        text(0.4, 0.95, ['r = ', num2str(R,'%.2f') ', p = ', num2str(P, '%.2e')],'Units', 'normalized', 'Color', 'r','VerticalAlignment', 'top');
    else
        text(0.5, 0.95, ['r = ', num2str(R,'%.2f') ', p = ', num2str(P, '%.2f')],'Units', 'normalized', 'Color', 'k','VerticalAlignment', 'top');
    end
    text(-0.2, 1.05, title_list{i}, 'Units', 'normalized');
    ylim(ylim_list(i,:))
end

set(gcf, 'Renderer', 'painters');
axesHandles = findall(gcf, 'Type', 'axes'); %获取所有子图的刻度属性
set(axesHandles, 'LineWidth', 1.2);   %刻度的线宽设置为1.2
set(axesHandles, 'FontSize' , 12);    %刻度的字体设置为12
set(findall(gcf, 'Type', 'line'), 'LineWidth', 1.2);          %所有线宽设置为1.2
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12);   %所有字体大小设置为12
set(findall(gcf, '-property', 'FontWeight'), 'FontWeight', 'bold');%所有属性均加粗
set(gcf, 'Position', [260, 140, 800, 600]); %设置图窗的位置（660,340）和大小（800, 600）
%% 保存当前图窗为tiff格式的图像
print(gcf, 'D:\nmm\figure\plot_10_crs_r.tiff', '-dtiff', '-r600');
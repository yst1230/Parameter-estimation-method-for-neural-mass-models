clc;clear;close all

color_list={'m','g','b','c','r'};
c1 = [186 186 186]/255; % data
c2 = [58, 191, 153]/255; % soga20
c3 = [0/255,0/255,0/255]; % soga45
c4 = [0.6, 0, 0.6]; % moga20
c5 = [107 152 196]/255; % moga45
c6 = [241/255 182/255 86/255]; % moga45
ctot = [c2;c3;c4;c5;c6];
FontSize=12;
for i=1:10
    load(['D:\nmm\result_JR\data_S4_method_' num2str(i)])
    curve(1,i,:)=Curve_GWO;
    curve(2,i,:)=Curve_ChOA;
    curve(3,i,:)=Curve_ECO;
    curve(4,i,:)=Curve_WO;
    curve(5,i,:)=Curve_AOChOA;
end

data=squeeze(mean(curve,2));


for j=1:5
    h(j)=semilogy(data(j,:), 'Color',ctot(j,:));
    hold on
end
hold off
box off
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = 1.2;
ax.YAxis.LineWidth = 1.2;
% yticks([0.2 0.4 0.6 0.8])
legend(h(1:5),{'GWO','ChOA','ECO','WO','AOChOA'},'NumColumns', 1, 'Orientation', 'vertical','Box', 'off')
ylabel('Fitness')
xlabel('Iterations')


% %% 绘制局部放大图
% xlim_zoom = [200, 300]; 
% ylim_zoom = [0.29, 0.32]; 
% % 在主图中添加局部放大图
% axes('Position', [0.4, 0.4, 0.3, 0.4]); 
% box off; % 显示边框
% hold on;
% 
% 
% for j=1:5
%     h(j)=semilogy(data(j,:), color_list{j});
%     hold on
% end
% xlim(xlim_zoom); 
% ylim(ylim_zoom); 
% ax = gca;
% ax.XAxis.FontWeight = 'bold';
% ax.YAxis.FontWeight = 'bold';
% ax.XAxis.LineWidth = 1.2;
% ax.YAxis.LineWidth = 1.2;

set(findall(gcf, 'Type', 'line'), 'LineWidth', 1.2);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12);   %所有字体大小设置为12
set(findall(gcf, '-property', 'FontWeight'), 'FontWeight', 'bold');%所有属性均加粗
set(gcf, 'Position', [660, 340, 400, 300])
%%  Save the current figure as an image in tiff format
print(gcf, 'D:\nmm\figure\plot_04_method.tiff', '-dtiff', '-r600');
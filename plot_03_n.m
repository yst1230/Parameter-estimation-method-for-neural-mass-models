clc;clear;close all
color_list={'m','g','k','b','c','r'};
c1 = [186 186 186]/255; % data
c2 = [58, 191, 153]/255; % soga20
c3 = [0/255,0/255,0/255]; % soga45
c4 = [0.6, 0, 0.6]; % moga20
c5 = [107 152 196]/255; % moga45
c6 = [241/255 182/255 86/255]; % moga45
ctot = [c1;c2;c3;c4;c5;c6];
FontSize=12;
for j=2:7
    for i=1:10
        load(['D:\nmm\result_JR\data_S4_N' num2str(j) '0_' num2str(i)])
        curve(i,:)=curve1;
    end
    f_mean(j-1,:)=mean(curve,1);
end

for j=1:6
    h(j)=semilogy(f_mean(j,:), 'Color',ctot(j,:));
    hold on
end
hold off
box off
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = 1.2;
ax.YAxis.LineWidth = 1.2;
% yticks([0 1])
legend(h(1:6),{'N=20','N=30','N=40','N=50','N=60','N=70'},'NumColumns', 2, 'Orientation', 'vertical','Box', 'off')
ylabel('Fitness')
xlabel('Iterations')
set(findall(gcf, 'Type', 'line'), 'LineWidth', 1.2);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12);   
set(findall(gcf, '-property', 'FontWeight'), 'FontWeight', 'bold');
set(findall(gcf, '-property', 'FontName'), 'FontName', 'Arial');
set(gcf, 'Position', [660, 340, 400, 300]);
%% Save the current figure as an image in tiff format
print(gcf, 'D:\nmm\figure\plot_03_n.tiff', '-dtiff', '-r600');
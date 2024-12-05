clc; clear;close all;
load data_JR

color_list=[52  148 186;
            236 112 22]/255;
[E1, E2]=cao_deneme(OutS2(1,:),1,30);

figure
plot(1:size(E1,2),E1,'Color',color_list(1,:),'Marker','o')
hold on
plot(1:size(E2,2),E2,'Color',color_list(2,:),'Marker','*')
hold on
xline(10,'--','color',[0.6, 0.6, 0.6]);

% grid off
box off
xlabel('Embedding dimension')
legend('E1','E2');
ylim([0 1.1])

axesHandles = findall(gcf, 'Type', 'axes'); 
set(axesHandles, 'LineWidth', 1.2);  
set(axesHandles, 'FontSize' , 12);    
set(findall(gcf, 'Type', 'line'), 'LineWidth', 1.2);          
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12);   
set(findall(gcf, '-property', 'FontWeight'), 'FontWeight', 'bold');
set(gcf, 'Position', [260, 140, 400, 300]);
%% Save the current figure as an image in tiff format
print(gcf, 'D:\nmm\figure\plot_02_m.tiff', '-dtiff', '-r600');
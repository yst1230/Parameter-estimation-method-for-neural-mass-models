function [h1, h2]=plot_erroryst(x,f2,color)
signal_mean = mean(x); % 计算平均信号
signal_std = std(x, 0, 1); % 计算标准误差
% 上下误差范围
y_upper = signal_mean + signal_std ;
y_lower = signal_mean - signal_std ;
h2=fill([f2', fliplr(f2')], [y_upper, fliplr(y_lower)],color,'FaceAlpha', 0.15, 'EdgeColor', 'none');
hold on;
h1=plot(f2, mean(x),"Color",color,'LineWidth',1.2);box off;
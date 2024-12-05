function X_reconstructed = phase_space_reconstruction(time_series, m, tau)
    % 输入参数:
    % time_series - 需要重构的时间序列
    % m - 嵌入维数（embedding dimension）
    % tau - 时间延迟

    N = length(time_series); % 时间序列的长度
    % 初始化重构后的矩阵，大小为(N-(m-1)*tau)行，m列
    X_reconstructed = zeros(m, N - (m - 1) * tau);
    
    % 构建相空间重构矩阵
    for i = 1:(N - (m - 1) * tau)
        % 对时间序列的各个延迟项进行取值
        X_reconstructed(:,i) = time_series(i:tau:i + (m - 1) * tau);
    end
end

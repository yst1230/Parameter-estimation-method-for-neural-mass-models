function [f]=obj_single_JR(x,s,p)
f = 0;

load D:\nmm\data_JR


A = x(1);  
B = x(2); 
a = 100;   
b = 50;   
C = x(3);  
C1 = C;
C2 = 0.8*C1;
C3 = 0.25*C1;
C4 = 0.25*C1;
v0 = x(4);
rt=2;
yi = zeros(6,1);
Fs = 128;
Ti = 0;
Tf = 7;
SampleNumber = (Tf-Ti)*Fs;
options = odeset('RelTol',1E-3);
Tspan = linspace(Ti,Tf,SampleNumber);   % Time duration for the data
u =normrnd(200,30,SampleNumber+1,1);
[~,y] = ode45(@(t,y) odefcn_JansenRit(t, y, u, A, B, a, b, C1, C2, C3, C4, Fs,v0), Tspan, yi, options);
data = y(rt*Fs+1:end,2) - y(rt*Fs+1:end,3);
OutS = normrnd(0,(0.2*std(data))^2,5*Fs,1)+data;

if s==1
    for i=1:size(OutS2,1)
        d(i)=sqrt(mean((OutS2(i,:)-OutS').^2));
    end
elseif s==2
    [psdx,F] = pwelch(OutS,[],[],Fs/0.2,Fs);
    psdx=psdx/sum(psdx);
    index = F>2 & F<=45;
    for i=1:size(OutS2,1)
        psdx2 = pwelch(OutS2(i,:),[],[],Fs/0.2,Fs);
        psdx2 = psdx2/sum(psdx2);
        d(i)   = mean((psdx2(index)-psdx(index)).^2);
    end
elseif s==3
    vg= fast_HVG(OutS, linspace(0,5,length(OutS)), 'w');
    d1 = full(sum(vg));
    for i=1:20
        vg2= fast_HVG(OutS2(i,:), linspace(0,5,length(OutS)), 'w');
        d2 = full(sum(vg2));
        [~,~,d(i)] = kstest2(d1,d2);
    end
elseif s==4
    pdr1 = phase_space_reconstruction(OutS, p, 1);
    cov_x1=covariances(pdr1,'scm');
    cov_x1=cov_x1+0.1*eye(p);
    for i=1:20
        pdr2   = phase_space_reconstruction(OutS2(i,:), p, 1);
        cov_x2 = covariances(pdr2,'scm');
        cov_x2 = cov_x2+0.1*eye(p);
        d(i)   = distance_yst(cov_x1,cov_x2,'riemann');
    end
end
f(1)=mean(d);


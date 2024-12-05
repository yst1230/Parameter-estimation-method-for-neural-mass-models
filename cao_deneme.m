function [E1, E2] = cao_deneme(x,tao,mmax)
%x : time series
%tao : time delay
%mmax : maximum embedding dimension
%reference:Cao, L. (1997), ``Practical method for determining the minimum
%embedding dimension of a scalar time series'', Physcai D, 110, pp. 43-50. 
%author:"Merve Kizilkaya"
N=length(x);
for m=1:mmax
    M=N-m*tao;
    Y=psr_deneme(x,m,tao,M);
    for n=1:M
        y0=ones(M,1)*Y(n,:);
        distance=max(abs(Y-y0),[],2);
        [neardis, nearpos]=sort(distance);
        
        newpoint=[Y(n,:) x(n+m*tao)];
        newneig=[Y(nearpos(2),:) x(nearpos(2)+m*tao)];
        R1=max(abs(newpoint-newneig),[],2);
        
        a(n)=R1/neardis(2);
        d(n)=abs(x(n+m*tao)-x(nearpos(2)+m*tao));
    end
    E(m)=sum(a)/M;
    Ey(m)=sum(d)/M;
end

E1=E(2:end)./E(1:end-1);
E2=Ey(2:end)./Ey(1:end-1);
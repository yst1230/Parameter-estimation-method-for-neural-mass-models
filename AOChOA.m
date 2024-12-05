
function [Attacker_score,Attacker_pos,Convergence_curve,Attacker_history,fitness_history,position_history,Trajectories]=AOChOA(SearchAgents_no,Max_iter,lb,ub,dim,fobj,s,p)

% initialize Attacker, Barrier, Chaser, and Driver
Attacker_pos=zeros(1,dim);
Attacker_score=inf; %change this to -inf for maximization problems

Barrier_pos=zeros(1,dim);
Barrier_score=inf; %change this to -inf for maximization problems

Chaser_pos=zeros(1,dim);
Chaser_score=inf; %change this to -inf for maximization problems

Driver_pos=zeros(1,dim);
Driver_score=inf; %change this to -inf for maximization problems

%Initialize the positions of search agents
Positions=initialization(SearchAgents_no,dim,ub,lb); % Positions=SearchAgents_no*dim
Convergence_curve=zeros(1,Max_iter);
Attacker_history=zeros(dim,Max_iter);
fitness_history=zeros(1,Max_iter);
position_history=zeros(SearchAgents_no,Max_iter,dim);
Trajectories=zeros(SearchAgents_no,Max_iter);
l=1;% Loop counter
%%
while l<Max_iter+1
    parfor i=1:size(Positions,1)
        % Return back the search agents that go beyond the boundaries of the search space
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        fitness(i)=feval(fobj,Positions(i,:),s,p);
    end
    for i=1:size(Positions,1)
        % Update Attacker, Barrier, Chaser, and Driver
        if fitness(i)<Attacker_score
            Attacker_score=fitness(i); % Update Attacker
            Attacker_pos=Positions(i,:);
        end

        if fitness(i)>Attacker_score && fitness(i)<Barrier_score
            Barrier_score=fitness(i); % Update Barrier
            Barrier_pos=Positions(i,:);
        end

        if fitness(i)>Attacker_score && fitness(i)>Barrier_score && fitness(i)<Chaser_score
            Chaser_score=fitness(i); % Update Chaser
            Chaser_pos=Positions(i,:);
        end
        if fitness(i)>Attacker_score && fitness(i)>Barrier_score && fitness(i)>Chaser_score && fitness(i)>Driver_score
            Driver_score=fitness(i); % Update Driver
            Driver_pos=Positions(i,:);
        end
        position_history(i,l,:)=Positions(i,:);
        Trajectories(:,l)=Positions(:,1);
        fitness_history(i,l)=fobj(Positions(i,:));
    end
    f=cos((pi/2)*((l/Max_iter).^4));


    for i=1:size(Positions,1)
        for j=1:size(Positions,2)
            m=chaos_yst(3,1,1); 

            r11=rand(); 
            r12=rand(); 
            A1=2*f*r11-f; 
            C1=2*r12; 
            D_Attacker=abs(C1*Attacker_pos(j)-m*Positions(i,j)); 
            X1=Attacker_pos(j)-A1*D_Attacker;

            r21=rand();
            r22=rand();
            A2=2*f*r21-f; 
            C2=2*r22; 
            D_Barrier=abs(C2*Barrier_pos(j)-m*Positions(i,j)); 
            X2=Barrier_pos(j)-A2*D_Barrier;

            r31=rand(); 
            r32=rand(); 
            A3=2*f*r31-f; 
            C3=2*r32;
            D_Driver=abs(C3*Chaser_pos(j)-m*Positions(i,j)); 
            X3=Chaser_pos(j)-A3*D_Driver;

            r41=rand();
            r42=rand();
            A4=2*f*r41-f; 
            C4=2*r42; 
            D_Driver=abs(C4*Driver_pos(j)-m*Positions(i,j)); 
            X4=Chaser_pos(j)-A4*D_Driver;
            if rand() > 0.7
                Positions(i, j) = 0.4*X1+0.3*X2+0.2*X3+0.1*X4;
            else
                if rand < 0.5
                    Positions(i,j)=Attacker_pos(j)*(1-l/Max_iter)+(mean(Positions(i,j))-Attacker_pos(j))*rand(); % Eq. (3) and Eq. (4)
                else
                    %-------------------------------------------------------------------------------------
                    beta = 2*rand();
                    sigma_u = ((gamma(1+beta)*sin(pi*beta/2))/(gamma((1+beta)/2)*beta*2^(0.5*(beta-1))))^(1/beta);
                    u = normrnd(0, sigma_u);
                    v = normrnd(0, 1);
                    alpha_levi = 0.01*u/abs(v)^(-beta)*(Positions(i, j)-Attacker_pos(j));
                    Positions(i, j) =Attacker_pos(j)*alpha_levi;
                end
            end
        end
    end
    Attacker_history(:,l)=Attacker_pos';
    Convergence_curve(l)=Attacker_score;
    l=l+1;
    if mod(l,10)==0
        elapsed_time = toc;
        display(['Done ' num2str(l) '  Pos: ', num2str(Attacker_pos),  '  Loss: ', num2str(Attacker_score) '  Time ', num2str(elapsed_time)])
    end
end




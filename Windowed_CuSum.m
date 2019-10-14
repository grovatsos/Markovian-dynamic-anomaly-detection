%In this code we simulate the moving change problem for a sensor network of
%L nodes witha Window CuSum test
clear all
clc
load('Markov_10.mat','Markov_matrix')
window_length = 20;%Window length is equal to this plus 1
    L=10 ; %number of states
%load('Markov_100.mat','Markov_matrix')
   % L=100;
repetitions = 1; %Number of monte carlo simulations
delay(1:repetitions) = 0;
for q=1:1:repetitions
    %Assume we have 5 post change state corresponding to different means
    pre_change_mean = 0;
    post_change_mean = 2;
    sigma = 1;
    threshold = 60;

    horizon = 1000;
    Observations=[];
    
    error_count=0;
    changepoint = 100;
    %changepoint = horizon;
    %Generate the post-change states
    sensor_evolution(1:horizon - changepoint +1) = 0;
    initial_pmf = (ones(L,1))/L;% I set the initial pmf to uniform
    sensor_evolution(1) = find(mnrnd(1,initial_pmf,1)); %the first state is visited according to the initial pmf
    for u = 2:1:horizon - changepoint +1 
        sensor_evolution(u)=find(mnrnd(1,Markov_matrix(sensor_evolution(u-1),:)));
    end
    sensors = [zeros(1,changepoint-1) , sensor_evolution];%which sensors are affected, 0 means all are prechange
    statistic(1:horizon)=0;% CuSum statistic
    for i = 1:1:horizon
        if i >= changepoint %Post-change observations generation
            Observations(:,i) = normrnd(pre_change_mean,sigma,[L,1]);
            Observations(sensors(i),i) = normrnd(post_change_mean,sigma);
        else %Pre-change observations generation
            Observations(:,i) = normrnd(pre_change_mean,sigma,[L,1]);
        end
        % statistic calculation
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        window_start = max( i-window_length, 1 ); %calculate the beginning of the window... the end of the window is i
        
        to_maximize=[];
        to_maximize(1:i-window_start+2)=0;%here we store the LLRs of the window
        %the last element is always equal to zero to cover the max with 0
        %case
        y=1;%counter
        for o = window_start:1:i
            to_maximize(y) = sum_of_log_likelihoods(Observations(:,o:i), Markov_matrix,initial_pmf, pre_change_mean,post_change_mean,sigma,L ); %calculates the sum of loglikelihoods for specific argument nu of max
            y=y+1;
            
        end
        %to_maximize
        %calculate the statistic as the max of the sum of LLRs
        statistic(i) = max(to_maximize);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if statistic(i)>threshold
            delay(q) = i-changepoint; %DELAY
            %delay(q) = i; %FA
            break
        end
        i
    end
    statistic(i+1:horizon)=[];
   % plot(statistic);
   if mod(q,10000)== 0
        q
    end
   if i==horizon
       disp('error')
       error_count = error_count+1;
   end
end

plot(statistic)
delay;
average_delay = mean(delay)
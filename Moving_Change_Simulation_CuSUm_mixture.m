%In this code we simulate the moving change problem for a sensor network of
%L nodes. The algorithm taking the max over all LLRs and adding it to the
%CuSum statistic shouldn't work because of FALSE ALARMS. We use the test
%from the dynamic post change problem and adapt it accordingly
clear all
clc
%load('Markov_10.mat','Markov_matrix')
    %L=10 ; %number of sensors
load('Markov_100.mat','Markov_matrix')
    L=100;
  
  %calculate the stationary distribution
%probability_distribution=[1 1 1 1 1 1 1 1 1 1]*0.1;
probability_distribution = ones(1,L)/L;
Markov_reps=1000000;
for i = 1:1:Markov_reps
    probability_distribution = probability_distribution*Markov_matrix;
end
probability_distribution;

repetitions = 50000; %Number of monte carlo simulations
delay(1:repetitions) = 0;
for q=1:1:repetitions
    %Assume we have 5 post change state corresponding to different means
    pre_change_mean = 0;
    post_change_mean = 1;
    sigma = 1;
    threshold = 2.5;

    horizon = 2500;
    error_count=0;
    changepoint = 1;
    %changepoint = horizon;
    %Generate the post-change states
    sensor_evolution(1:horizon - changepoint +1) = 0;
    sensor_evolution(1) = randi(L); %the first state is visited uniformly at random
    for u = 2:1:horizon - changepoint +1 
        sensor_evolution(u)=find(mnrnd(1,Markov_matrix(sensor_evolution(u-1),:)));
    end
    sensors = [zeros(1,changepoint-1) , sensor_evolution];%which sensors are affected, 0 means all are prechange
    r=[];
    CuSum_statistic(1:horizon)=0;
    for i = 1:1:horizon
        if i >= changepoint %Post-change observations generation
            Observations = normrnd(pre_change_mean,sigma,[L,1]);
            Observations(sensors(i)) = normrnd(post_change_mean,sigma);
        else %Pre-change observations generation
            Observations = normrnd(pre_change_mean,sigma,[L,1]);
        end
        if i==1
            logs_to_add(1:L)=0;
            for j = 1:1:L
                logs_to_add(j) = (probability_distribution(j))*( (normpdf(Observations(j),post_change_mean,sigma))/ (normpdf(Observations(j),pre_change_mean,sigma)) );
            end
            CuSum_statistic(i) = max(log(sum(logs_to_add)),0);
        else
            for j = 1:1:L
                logs_to_add(j) = probability_distribution(j)*( (normpdf(Observations(j),post_change_mean,sigma))/ (normpdf(Observations(j),pre_change_mean,sigma)) );
            end
            CuSum_statistic(i) = max(CuSum_statistic(i-1)+log(sum(logs_to_add)),0);
        end

        if CuSum_statistic(i)>threshold
            delay(q) = i-changepoint; %DELAY
            %delay(q) = i; %FA
            break
        end
    end
    CuSum_statistic(i+1:horizon)=[];
   % plot(statistic);
   if mod(q,10000)== 0
        q
    end
   if i==horizon
       disp('error')
       error_count = error_count+1;
   end
end

plot(CuSum_statistic)
delay;
average_delay = mean(delay)
function sum_of_LLRs = sum_of_log_likelihoods(Observations, transition_matrix,initial_pmf, pre_change_mean,post_change_mean,sigma,L )
    %This function takes as input the observations in the window and
    %calculate the sum (this essentially runs an SPRT statistic
    %calculation)   
    n=size(Observations,2);
    
    predictor = initial_pmf;
    sum=0;
    for i=1:1:n
           conditional_probability = cond_prob(L,predictor,Observations(:,i),pre_change_mean,post_change_mean,sigma);
           f_0 = fzerocalculator(pre_change_mean,sigma,L,Observations(:,i));
           sum = sum + log(conditional_probability/f_0);
           estimator = state_estimator(L,predictor,Observations(:,i),pre_change_mean,post_change_mean,sigma);
           predictor = state_predictor(L,estimator,transition_matrix);
    end
    sum_of_LLRs =sum;
end
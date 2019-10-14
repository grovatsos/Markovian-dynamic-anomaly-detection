function conditional_probability = cond_prob(L,predictor,Observation,pre_change_mean,post_change_mean,sigma)
%This code uses the current state predictor and the current observation to
%calculate the conditional probability recursively
    
    fells(1:L)=0;
    for j=1:1:L
        fells(j) = fellcalculator(j,pre_change_mean,post_change_mean,sigma,L,Observation);
    end
    conditional_probability = dot(fells,predictor);
end
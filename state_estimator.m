function state_estimate = state_estimator(L,predictor,Observation,pre_change_mean,post_change_mean,sigma)
%This code uses the current observation and the previous predictor vector 
% P[S_n =j|X_1,...,X_n-1] to calculate the current estimate P[S_n =j|X_1,...,X_n]
    
    state_estimate(1:L)=0;
    for j=1:1:L
        fell = fellcalculator(j,pre_change_mean,post_change_mean,sigma,L,Observation);
        state_estimate(j) = predictor(j)*fell;
    end
    state_estimate = state_estimate/sum(state_estimate);
    
end
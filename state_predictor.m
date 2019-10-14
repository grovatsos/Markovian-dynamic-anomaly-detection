function state_predict = state_predictor(L,estimator,transition_matrix)
%This code uses the current state estimate and the transition matrix to
%calculate the vector of P[S_n+1 =j|X_1,...,X_n] 

        for j=1:1:L
            state_predict(j) = dot(estimator,transition_matrix(:,j) );
        end


end
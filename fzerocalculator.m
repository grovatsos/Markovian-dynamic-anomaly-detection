function f_0 = fzerocalculator(prechangemean,sigma,L,Observations)
%Computes f_ell(X_n) for a given ell and given Observation
%vector

    f_0s = [];

        for j=1:1:L
             f_0s(j) = normpdf(Observations(j),prechangemean,sigma);
        end

    f_0 = prod(f_0s);

end
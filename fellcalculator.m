function fell = fellcalculator(ell,prechangemean,meanshift,sigma,L,Observations)
%Computes f_ell(X_n) for a given ell and given Observation
%vector X_n

    fells = [];

        for j=1:1:L
            if j== ell
                fells(j) = normpdf(Observations(j),meanshift,sigma);
            else
                fells(j) = normpdf(Observations(j),prechangemean,sigma);
            end
        end

    fell = prod(fells);

end
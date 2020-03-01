function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)

    [muPos, sigmaPos] = computeMeanStd(vBoWPos);
    [muNeg, sigmaNeg] = computeMeanStd(vBoWNeg);

   
    pCar = 0;
    pNotCar = 0;
    N = length(histogram);
    for i = 1:N
        y = log(normpdf(histogram(i), muPos(i), sigmaPos(i)));
        
        if ~isnan(y)
            pCar = pCar + y;
        end
        
        z = log(normpdf(histogram(i), muNeg(i), sigmaNeg(i)));
        
        if ~isnan(z)
            pNotCar = pNotCar + z;
        end
    end
    
    pCar = exp(pCar);
    pNotCar = exp(pNotCar);
    
    %assumption from the assignment
    p = 0.5;
    if p * pCar > p * pNotCar
        label = 1;
    else
        label = 0;
    end

end



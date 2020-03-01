function peak = findpeak(X, xl , r)
difference = 100000;
peak = xl;
while difference > 0.1
    distance = sqrt(sum((X - peak).^2, 2));
    indices = find(distance <= r);
    if size(indices) == 1
        newpeak = X(indices,:);
    else
        newpeak = mean(X(indices, :));
    end
    difference = norm(peak - newpeak);
    peak = newpeak;
end
end


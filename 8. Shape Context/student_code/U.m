function result = U(t)
    if(t == 0)
        result = 0;
    else
        result = t.^2 .* log(t.^2);
    end
end
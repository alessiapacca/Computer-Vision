function [mu sigma] = computeMeanStd(vBoW)

sigma = std(vBoW);
mu = mean(vBoW);

end
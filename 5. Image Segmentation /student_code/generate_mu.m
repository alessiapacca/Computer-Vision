function mu = generate_mu(ranges, K)

maxL = ranges(1,1);
maxa = ranges(1,2);
maxb = ranges(1,3);
minL = ranges(2,1);
mina = ranges(2,2);
minb = ranges(2,3);

mu = [linspace(minL, maxL,K);
      linspace(mina, maxa,K); 
      linspace(minb, maxb,K);];

end

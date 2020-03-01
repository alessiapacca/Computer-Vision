function particles_w = observe(particles,frame,H,W,hist_bin,hist_target,sigma_observe)

n = size(particles,1);
particles_w = zeros(n,1);
for i = 1:n
    %finds xmin, xmax, ymin, ymax
    xMin = particles(i,1) - W/2;
    xMax = particles(i,1) + W/2;
    yMin = particles(i,2) - H/2;
    yMax = particles(i,2) + H/2;
    
    %call function previously implemented color_histogram
    hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin);
   
    %calculate dist with provided function 
    chi = chi2_cost(hist_target,hist);

    %add in particles_w with the provided formula from assignment
    particles_w(i) = 1/(sqrt(2*pi)*sigma_observe) * exp(-chi^2/(2*sigma_observe^2));
   
end
%normalize
particles_w = particles_w/sum(particles_w);
end

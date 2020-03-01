function [particles,particles_w] = resample(particles,particles_w)
%resample the particles based on their weights and return these new particles along with their corresponding weights

M = (size(particles,1)) ;
r = rand()* 1/M;
c = particles_w(1);
particlesNEW = zeros(size(particles));
particles_wNEW = zeros(size(particles_w));
i = 1;  

for m = 1:M
        U = r + (m-1)* 1/M;
        while c < U
            i = i + 1;
            if i > M 
                i = 1;
            end
            c = c + particles_w(i);
        end
    particlesNEW(m,:) = particles(i,:);
    particles_wNEW(m) = particles_w(i);
end

%return 
particles_wNEW = particles_wNEW/sum(particles_wNEW);
particles_w = particles_wNEW;
particles = particlesNEW;
end


            
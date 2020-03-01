function particles = propagate(particles,sizeFrame,params)

%This function should propagate the particles given the system 
%prediction model (matrix A) and the system model noise represented 
%by params.model, params.sigma position and params.sigma velocity. 
%Use the parameter sizeFrame to make sure that the center of the particle 
%lies inside the frame.

particlesnew = zeros(params.num_particles,size(particles,2));

%first model 
if params.model == 0
    A = [1,0;0,1];
    w = [params.sigma_position, params.sigma_position]; %2 elements 
else %second model 
    A = [1,0,1,0;0,1,0,1;0,0,1,0;0,0,0,1];
    w = [params.sigma_position, params.sigma_position, params.sigma_velocity, params.sigma_velocity]; %4 elements
end

%propagate each sample st-1 by updating particlesnew with the formula Ast-1 + wt-1
for i=1:params.num_particles
    W = w.*randn(1,size(particles,2));
    particlesnew(i,:) = particles(i,:)*A'+W;
end


%resize with the height and width of the frame
heightFrame = sizeFrame(1);
widthFrame = sizeFrame(2);
%first column
particlesnew(:,1) = min(particlesnew(:,1),widthFrame);
particlesnew(:,1) = max(particlesnew(:,1),1);
%second column 
particlesnew(:,2) = min(particlesnew(:,2),heightFrame);
particlesnew(:,2) = max(particlesnew(:,2),1);

particles = particlesnew;
end
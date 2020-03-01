function [w_x,w_y,E] = tps_model(X,Y,lambda)

%here we have to contruct A and b
%w_x and w_y are the parameters (ωi and ai) in the two TPS models
%E is the total bending energy and the inputs are as following:
%points in the template shape, X
%corresponding points in the target shape, Y 
%regularization parameter, lambda


% vx = zeros(numberModel,1); %Y dovrebbe avere 2 colonne, x e y
% 
% for i = 1:numberModel
%     vx(i,1) = Y(i,1);
% end
% vx = [vx; zeros(3,1)];
% 
% vy = zeros(numberModel,1); %Y dovrebbe avere 2 colonne, x e y
% for i = 1:numberModel
%     vy(i,1) = Y(i,2);
% end
% vy = [vy; zeros(3,1)];

numberModel = size(X,1); %number of points
vx = [Y(:, 1); zeros(3,1)];
vy = [Y(:, 2); zeros(3,1)];

pairDist = sqrt(dist2(X,X));
K = U(pairDist);   
P = [ones(numberModel,1), X];   %1, xi, yi just like described in the assignment. so it's size (numberModel*3)                                               
K(isnan(K)) = 0; %remove the same point that has distance zero 
A = [[K+lambda*eye(numberModel), P]; [P', zeros(3,3)]]; 

%now I have my system Ax = b
%then x =   A\b

w_x = A\vx;
w_y = A\vy;

E = w_x(1:end-3)'*K*w_x(1:end-3) + w_y(1:end-3)'*K*w_y(1:end-3);


end










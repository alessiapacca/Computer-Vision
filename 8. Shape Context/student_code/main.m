t = load('dataset.mat');
objects = t.objects;

n = 150;

%from 1 to 5 there is the heart shape, from 6 to 10 the fork and from 11 to
%15 the clock
X = t.objects(1).X;    
Y = t.objects(2).X;

%get samples from dataset
[X,Y] = sampledata(X,Y,n);

figure(100) 
imshow(t.objects(1).img)
figure(101)
imshow(t.objects(2).img)

matchingCost = shape_matching(X, Y, 1);

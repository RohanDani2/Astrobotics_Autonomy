a = [1 1 1 1 1 0 1 1 1 0];
a(2,:) = [0 1 1 0 1 0 0 1 1 1];
a(3,:) = [1 0 0 0 1 1 1 0 0 1];
a(4,:) = [0 0 1 1 1 1 0 1 0 1];
a(5,:) = [1 1 1 1 1 0 1 1 1 1];
a(6,:) = [1 0 0 0 1 0 1 1 0 0];
a(7,:) = [0 0 1 1 1 1 1 0 0 1];
a(8,:) = [1 1 1 1 1 1 0 1 0 1];
a(9,:) = [1 0 0 0 1 0 1 1 1 1];
a(10,:) = [0 0 1 1 1 0 1 0 1 1];
b = imresize(a, 4, 'nearest');
b = imresize(b, 0.25, 'nearest');
figure(1)
imshow(a)

figure(2)
imshow(b)

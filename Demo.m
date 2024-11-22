image_path = "4.png";
image = imread(image_path);

rho = 300;  % 1200 for "01", 700 for "02", 500 for "03", 300 for "04"
k = 2.5;    % 1.5 for "01", 1.75 for "02", 2 for "03", 2.5 for "04"
lambda = 100;
iter = 4;
smooth_image = GSTF(image, rho, k, lambda, iter);
figure, imshow(smooth_image);
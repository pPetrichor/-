I = imread('../asset/image/436.tif');
g_with_zero = process_with_zero(I,3,30);%使用高斯低通滤波器，截止频率取30
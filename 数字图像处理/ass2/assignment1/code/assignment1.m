I = imread('../asset/image/432.tif');
figure;subplot(1,3,1);imshow(I);title('原图');
g_without_zero = process_without_zero(I,3,15);%使用高斯低通滤波器，截止频率取15
subplot(1,3,2);imshow(g_without_zero);title('不进行零填充');
g_with_zero = process_with_zero(I,3,30);%使用高斯低通滤波器，截止频率取30
subplot(1,3,3);imshow(g_with_zero);title('进行零填充');
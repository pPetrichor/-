I = imread('../asset/image/3_3.jpg');
g_in_space = process_in_space(I,'sobel');%利用sobel算子在空间域进行处理
[g_in_freq_1,g_in_freq_2] = process_in_freq(I,'sobel');%利用sobel算子在频率域进行处理
figure;
subplot(1,3,1);imshow(g_in_space);title('空间域滤波处理结果');
subplot(1,3,2);imshow(g_in_freq_1);title('频率域滤波处理结果(未做零填充)');
subplot(1,3,3);imshow(g_in_freq_2);title('频率域滤波处理结果(零填充后)');

g_in_space = process_in_space(I,'sobel_2');%利用2个sobel算子在空间域进行处理
[g_in_freq_1,g_in_freq_2] = process_in_freq(I,'sobel_2');%利用sobel算子在频率域进行处理
figure;
subplot(1,3,1);imshow(g_in_space);title('空间域滤波处理结果');
subplot(1,3,2);imshow(g_in_freq_1);title('频率域滤波处理结果(未做零填充)');
subplot(1,3,3);imshow(g_in_freq_2);title('频率域滤波处理结果(零填充后)');

I = imread('../asset/image/zhiwen.jpg');
g_in_space = process_in_space(I,'lpls');%利用拉普拉斯算子在空间域进行处理
[g_in_freq_1,g_in_freq_2] = process_in_freq(I,'lpls');%利用拉普拉斯算子在频率域进行处理
figure;
subplot(1,3,1);imshow(g_in_space);title('空间域滤波处理结果');
subplot(1,3,2);imshow(g_in_freq_1);title('频率域滤波处理结果(未做零填充)');
subplot(1,3,3);imshow(g_in_freq_2);title('频率域滤波处理结果(零填充后)');

I = imread('../asset/image/scenery.jpg');
g_in_space = process_in_space(I,'average');%利用均值滤波器算子在空间域进行处理
[g_in_freq_1,g_in_freq_2] = process_in_freq(I,'average');%利用均值滤波器算子在频率域进行处理
figure;
subplot(1,3,1);imshow(g_in_space);title('空间域滤波处理结果');
subplot(1,3,2);imshow(g_in_freq_1);title('频率域滤波处理结果(未做零填充)');
subplot(1,3,3);imshow(g_in_freq_2);title('频率域滤波处理结果(零填充后)');

g_in_space = process_in_space(I,'weight');%利用加权线性滤波器算子在空间域进行处理
[g_in_freq_1,g_in_freq_2] = process_in_freq(I,'weight');%利用加权线性滤波器算子在频率域进行处理
figure;
subplot(1,3,1);imshow(g_in_space);title('空间域滤波处理结果');
subplot(1,3,2);imshow(g_in_freq_1);title('频率域滤波处理结果(未做零填充)');
subplot(1,3,3);imshow(g_in_freq_2);title('频率域滤波处理结果(零填充后)');
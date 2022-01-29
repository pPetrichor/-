function [output1,output2] = process_in_freq(I,operator)
    I = im2double(im2gray(I));
    [X,Y] = size(I);
    switch operator
        case 'sobel'
            op = [[-1,0,1];[-2,0,2];[-1,0,1]]; %sobel算子
         case 'sobel_2'%x、y方向上两个sobel算子
            op_x = [[-1,0,1];[-2,0,2];[-1,0,1]]; 
            op_y = [[-1,-2,-1];[0,0,0];[1,2,1]];
        case 'lpls'
            op = [[1,1,1];[1,-8,1];[1,1,1]]; %拉普拉斯算子对角线形式
        case 'average'
            op = 1/9 * [[1,1,1];[1,1,1];[1,1,1]]; %均值滤波器算子
        case 'weight'
            op = 1/16 * [[1,2,1];[2,4,2];[1,2,1]]; %加权线性滤波器算子
    end
    
    if strcmp(operator,'sobel_2')
        filter_x = fft2(op_x,X,Y);
        filter_y = fft2(op_y,X,Y);
        filter_x_T = log(1 + abs(fftshift(filter_x)));
        filter_y_T = log(1 + abs(fftshift(filter_y)));
        filter_x_A = angle(fftshift(filter_x)) + pi;
        filter_y_A = angle(fftshift(filter_y)) + pi;
        figure;
        subplot(3,2,1);imshow(uint8(filter_x_T * 255 ./ max(max(filter_x_T))));title('x方向算子的频域傅里叶谱(中心化后)');
        subplot(3,2,2);imshow(uint8(filter_y_T * 255 ./ max(max(filter_y_T))));title('y方向算子的频域傅里叶谱(中心化后)');
        subplot(3,2,3);imshow(uint8(filter_x_A * 255 / (2 * pi)));title('x方向算子的相位(中心化后)');
        subplot(3,2,4);imshow(uint8(filter_y_A * 255 / (2 * pi)));title('y方向算子的相位(中心化后)');
        F = fft2(I);
        % figure,imshow(F);
        F_T = log(1 + abs(fftshift(F)));
        F_A = angle(fftshift(F)) + pi;
        subplot(3,2,5);imshow(uint8(F_T * 25));title('原图的频域傅里叶谱(中心化后)');
        subplot(3,2,6);imshow(uint8(F_A * 255 / (2 * pi)));title('原图的相位(中心化后)');
        G_x = (filter_x .* F);
        output_x = (ifft2(G_x));
        G_y = (filter_y .* F);
        output_y = (ifft2(G_y));
        output1 = sqrt(output_x .^2 + output_y .^2);
        
        % 显示的是原图的频域图片，接下来对原图作扩展以完成滤波的零扩展
        filter_x = fft2(op_x,2 * X,2 * Y);
        filter_y = fft2(op_y,2 * X,2 * Y);
        % 算子做傅里叶变换，放大到原图大小的四倍，以完成滤波的零扩展
        I_0_padding = zeros(2 * X,2 * Y);
        I_0_padding(1:X,1:Y) = I;
        F = fft2(I_0_padding);
        G_x = (filter_x .* F);
        output_x = (ifft2(G_x));
        output_x = output_x(1:X,1:Y);
        G_y = (filter_y .* F);
        output_y = (ifft2(G_y));
        output_y = output_y(1:X,1:Y);
        output2 = sqrt(output_x .^2 + output_y .^2);
        
    else
        filter = fft2(op,X,Y);
        figure;
        filter_T = log(1 + abs(fftshift(filter)));
        filter_A = angle(fftshift(filter)) + pi;
        subplot(2,2,1);imshow(uint8(filter_T * 255 ./ max(max(filter_T))));title('算子的频域傅里叶谱(中心化后)');
        subplot(2,2,2);imshow(uint8(filter_A * 255 / (2 * pi)));title('算子的相位(中心化后)');
        F = fft2(I);
        % figure,imshow(F);
        F_T = log(1 + abs(fftshift(F)));%(abs(fftshift(F))).^(1/4);
        F_A = angle(fftshift(F)) + pi;
        subplot(2,2,3);imshow(F_T * 0.125);title('原图的频域傅里叶谱(中心化后)');
        subplot(2,2,4);imshow(uint8(F_A * 255 / (2 * pi)));title('原图的相位(中心化后)');
        G = (filter .* F);
        output1 = (ifft2(G));
        % 接下来做零填充
        filter = fft2(op,2 * X,2 * Y);
        % 算子做傅里叶变换，放大到原图大小的四倍，以完成滤波的零扩展
        I_0_padding = zeros(2 * X,2 * Y);
        I_0_padding(1:X,1:Y) = I;
        F = fft2(I_0_padding);
        G = (filter .* F);
        output = (ifft2(G));
        output2 = output(1:X,1:Y);
    end
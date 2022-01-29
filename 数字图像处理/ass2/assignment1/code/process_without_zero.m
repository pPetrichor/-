function [g] = process_without_zero(I,type,D_0)
    I = im2double(I);
    [X,Y] = size(I);
    for i = 1:X
        for j = 1:Y
            I(i,j) = I(i,j) * (-1)^(i+j);%将图像移动到中心
        end
    end
    F = fft2(I,X,Y); %做傅里叶变换
    % F = fftshift(F); 
    H = low_pass_fliter(type,X,Y,D_0);% type取1、2、3，依次对应理想低通滤波器、巴特沃斯低通滤波器、高斯低通滤波器
    G = H.*F;
    % figure, imshow(H);
    % G = ifftshift(G); %移动回原位置，等价于傅里叶反变换后乘以(-1)^(x+y)
    g = ifft2(G); %做傅里叶反变换
    for i = 1:X
        for j = 1:Y
            g(i,j) = g(i,j) * (-1)^(i+j);%将图像移动回原位置
        end
    end
        
        
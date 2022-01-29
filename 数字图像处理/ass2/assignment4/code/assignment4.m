clear
input = imread('../asset/image/woman.png');
if numel(size(input)) > 2
    [m,n,l] = size(input);
else
    [m,n] = size(input);
end
% ################### 模糊化处理,尝试祛皱 ##############
I = im2double(input);
if numel(size(I)) > 2
   output = I;
    figure;
    subplot(2,2,1);imshow(output);title('原图');
    Ir = I(:,:,1);
    Ig = I(:,:,2);
    Ib = I(:,:,3);
    output(:,:,1) = process_with_zero(Ir,3,35);
    output(:,:,2) = process_with_zero(Ig,3,35);
    output(:,:,3) = process_with_zero(Ib,3,35);
    subplot(2,2,2);imshow(output);title('D0 = 35');
    output(:,:,1) = process_with_zero(Ir,3,80);
    output(:,:,2) = process_with_zero(Ig,3,80);
    output(:,:,3) = process_with_zero(Ib,3,80);
    subplot(2,2,3);imshow(output);title('D0 = 80');
     output(:,:,1) = process_with_zero(Ir,3,160);
    output(:,:,2) = process_with_zero(Ig,3,160);
    output(:,:,3) = process_with_zero(Ib,3,160);
    subplot(2,2,4);imshow(output);title('D0 = 160');
else
    figure;
    subplot(2,2,1);imshow(I);title('原图');
    output = process_with_zero(I,3,25);
    subplot(2,2,2);imshow(output);title('D0 = 25');
    output = process_with_zero(I,3,120);
    subplot(2,2,3);imshow(output);title('D0 = 120');
    output = process_with_zero(I,3,160);
    subplot(2,2,4);imshow(output);title('D0 = 160');
end

% ###################### 表面模糊尝试 ###################
I = double(input);
figure;
subplot(1,3,1);imshow(mat2gray(I));title('原图');
r = 11; %模板半径
T = 36; %阈值
% 表面模糊中的阈值，是控制相邻像素色调值与中心像素值相差多大时才能成为模糊的一部分
if numel(size(I)) > 2
    output = I;
    for k = 1:3  
        t = I(:,:,k);
        I_padding = zeros(m + 2 * r, n + 2 * r);
        I_padding(r+1:r+m,r+1:r+n) = t;
        I_padding(1:r,r+1:n+r) = t(1:r,1:n);
        I_padding(1:m+r,n+r+1:n+2*r) = I_padding(1:m+r,n+1:n+r);
        I_padding(m+r+1:m+2*r,r+1:n+2*r) = I_padding(m+1:m+r,r+1:n+2*r);
        I_padding(1:m+2*r,1:r) = I_padding(1:m+2*r,r+1:2*r);
        co = t;
        for i = r+1:r+m
            for j = r+1:r+n
                op = 1 - (abs(I_padding(i-r:i+r,j-r:j+r) - I_padding(i,j)) / (2.5 * T));
                temp = find(op < 0);
                op(temp) = 0;
                c = op .* I_padding(i-r:i+r,j-r:j+r);
                co(i-r,j-r) = sum(sum(c)) ./ sum(sum(op));
            end
        end
        output(:,:,k) = co;
    end
else
    I_padding = zeros(m + 2 * r, n + 2 * r);
    I_padding(r+1:r+m,r+1:r+n) = I;
    I_padding(1:r,r+1:n+r) = I(1:r,1:n);
    I_padding(1:m+r,n+r+1:n+2*r) = I_padding(1:m+r,n+1:n+r);
    I_padding(m+r+1:m+2*r,r+1:n+2*r) = I_padding(m+1:m+r,r+1:n+2*r);
    I_padding(1:m+2*r,1:r) = I_padding(1:m+2*r,r+1:2*r);
    output = I;
    for i = r+1:r+m
        for j = r+1:r+n
            op = 1 - abs(I_padding(i-r:i+r,j-r:j+r) - I_padding(i,j)) / (2.5 * T);
            temp = find(op < 0);
            op(temp) = 0;
            c = op .* I_padding(i-r:i+r,j-r:j+r);
            output(i-r,j-r) = sum(sum(c)) ./ sum(sum(op));
        end
    end
end
subplot(1,3,2);imshow(mat2gray(output));title('表面模糊');
% 与高斯模糊相比，表面模糊对边缘保护的更加好

% ########################### 表面模糊后blend ########################
Opacity = 0.8;
result = (I * (1 - Opacity) + (I + 2 * output - 1) * Opacity);%blend
subplot(1,3,3);imshow(mat2gray(result) + 0.12);title('blend处理后'); %增加亮度，实现一定的美白效果

% ########### 自己的尝试：计算区域中的方差/标准差，超过阈值保留，未超过阈值平滑 ########
I = im2double(input);
if numel(size(I)) > 2
    I_1 = rgb2gray(I);
else
    I_1 = I;
end
r = 5;
I_padding = zeros(m + 2 * r, n + 2 * r);
I_padding(r+1:r+m,r+1:r+n) = I_1;
I_padding(1:r,r+1:n+r) = I_1(1:r,1:n);
I_padding(1:m+r,n+r+1:n+2*r) = I_padding(1:m+r,n+1:n+r);
I_padding(m+r+1:m+2*r,r+1:n+2*r) = I_padding(m+1:m+r,r+1:n+2*r);
I_padding(1:m+2*r,1:r) = I_padding(1:m+2*r,r+1:2*r);
output = I_1;
for i = r+1:r+m
    for j = r+1:r+n
        current = I_padding(i-r:i+r,j-r:j+r);
        sigma = std2(current);
        if sigma < 0.08
            output(i-r,j-r) = mean(mean(current)); %非边缘处进行平滑
        end
    end
end
figure;subplot(1,2,1);imshow(I_1);title('原图');
subplot(1,2,2);imshow(output);title('高方差保留，低方差平滑处理后');

% ######### 利用边缘去除斑点的尝试 ###########
figure;
subplot(2,2,1);imshow(I_1);title('原图');
% 加边缘，用test3
fliter = fspecial('average',5);
t = imfilter(I_1, fliter);
subplot(2,2,3);imshow(t);title('平滑处理');
fliter = fspecial('log');
i = imfilter(I_1, fliter);%拉普拉斯高斯算子边缘提取后的图片
p = i * 0.8 + I_1;%原图像加上边缘提取后的图片
subplot(2,2,2);imshow(p);title('原图像加上提取边缘');
fliter = fspecial('average',5);
x = imfilter(p, fliter);
subplot(2,2,4);imshow(x);title('平滑后');
figure;imshow(i);title('提取的边缘');

% ################# 按照噪声来考虑斑点去除,用timg ###################
x = ordfilt2(I_1,9,ones(3,3)); % 将雀斑看作胡椒噪声，用最大值滤波器处理
figure;subplot(1,3,1);imshow(x);title('最大值滤波器处理后');
x = ordfilt2(I_1,5,ones(3,3));% 尝试中值滤波器处理
subplot(1,3,2);imshow(x);title('中值滤波器处理一次后');
x = ordfilt2(x,5,ones(3,3));
subplot(1,3,3);imshow(x);title('中值滤波器处理两次后');

% ################ 双边滤波器的尝试 ######################3
r = 5;
s_d = 5;
s_a = 0.08;
figure;
subplot(1,3,1);imshow(mat2gray(I));title('原图');
if numel(size(I)) > 2
    Ir = I(:,:,1);
    Ig = I(:,:,2);
    Ib = I(:,:,3);
    output(:,:,1) = BF(Ir,r,s_d,s_a);
    output(:,:,2) = BF(Ig,r,s_d,s_a);
    output(:,:,3) = BF(Ib,r,s_d,s_a);
else
    output = BF(I,r,s_d,s_a);
end
subplot(1,3,2);imshow(mat2gray(output));title('双边滤波器');

% ################## 高斯滤波器的加入+blend处理 #####################
% ######### 参考https://www.cnblogs.com/Imageshop/p/4709710.html ######
highpass = output - I + 0.5;
gauss = fspecial('gaussian');
g = imfilter(highpass,gauss);
Opacity = 0.8;%控制透明度，可调高显示肌肤质感
result = (I * (1 - Opacity) + (I + 2 * g - 1) * Opacity);
subplot(1,3,3);imshow(mat2gray(result));title('blend+gaussian处理');

% ################ 导向滤波的尝试 ###############
r = 3;eps = 0.005;
if numel(size(I)) > 2
    B = I;
    B(:, :, 1) = guidedfilter(I(:, :, 1), I(:, :, 1), r, eps);
    B(:, :, 2) = guidedfilter(I(:, :, 2), I(:, :, 2), r, eps);
    B(:, :, 3) = guidedfilter(I(:, :, 3), I(:, :, 3), r, eps);
else
    B = guidedfilter(I,I,r,eps);
end
figure;subplot(1,2,1);imshow(I);title('原图');
subplot(1,2,2);imshow(B);title('导向滤波器');
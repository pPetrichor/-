function output = BF(I,r,s_d,s_r) %r表示模板半径，s_d表示空间域的方差，s_r表示值域的方差
I = im2double(I);
[m,n] = size(I);
% 利用原图片进行边缘填充
I_padding = zeros(m + 2 * r, n + 2 * r);
I_padding(r+1:r+m,r+1:r+n) = I;
I_padding(1:r,r+1:n+r) = I(1:r,1:n);
I_padding(1:m+r,n+r+1:n+2*r) = I_padding(1:m+r,n+1:n+r);
I_padding(m+r+1:m+2*r,r+1:n+2*r) = I_padding(m+1:m+r,r+1:n+2*r);
I_padding(1:m+2*r,1:r) = I_padding(1:m+2*r,r+1:2*r);

dis = zeros(2 * r + 1,2 * r + 1); %生成距离模板
for i = 1:2 * r + 1
    for j = 1:2 * r + 1
        dis(i,j) = (i - (r + 1))^2 + (j - (r + 1))^2;
    end
end

for i = r+1:r+m
    for j = r+1:r+n
        w = I_padding(i - r:i + r,j - r:j + r); %模板处理的区域
        fr = abs(w - I_padding(i,j));
        fr = exp(- fr .^ 2 / (2 * s_r ^ 2));
        %计算值域核fr
        fd = exp(- dis / (2 * s_d ^ 2));
        %计算空间域核fd
        op = fd .* fr;
        op = op / sum(sum(op));
        %相乘得到滤波器
        I_padding(i,j) = sum(sum(w .* op));
        %卷积
    end
end
       
output = I_padding(r+1:r+m,r+1:r+n);
end

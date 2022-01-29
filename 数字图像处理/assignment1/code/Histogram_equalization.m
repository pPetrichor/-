function [output] = Histogram_equalization(input_image)
%first test the image is a RGB or gray image
if numel(size(input_image)) == 3
    %this is a RGB image
    %here is just one method, if you have other ways to do the
    %equalization, you can change the following code
    % solution 1
    r=input_image(:,:,1);
    v=input_image(:,:,2);
    b=input_image(:,:,3);
    r1 = hist_equal(r);
    v1 = hist_equal(v);
    b1 = hist_equal(b);
    output = cat(3,r1,v1,b1);
    figure, imshow(output)
    %solution 2,先转化为hsi，对i作均衡化处理后转回rgb
    output = hist_equal_HSI(input_image);
    figure, imshow(output)
    %solution 3,先转化为hsv，对v作均衡化处理后转回rgb
    output = hist_equal_HSV(input_image);
else
    %this is a gray image
    [output] = hist_equal(input_image);
    
end

     function [output2] = hist_equal(input_channel)
    %you should complete this sub-function 
    input_channel = im2uint8(input_channel);%统一按照8位整数来存
    output2 = input_channel;
    data = imhist(input_channel); %利用imhist函数得到各灰度值像素点的数目
    [length,t] = size(data);%得到data的长度length
    for i=2:length
        data(i) = data(i-1) + data(i); %累加，计算后data(i)表示灰度值小于等于i-1的像素点数总和
    end
    [r,c] = size(input_channel);
    for i = 1:r
        for j = 1:c
            output2(i,j) = round(255 * data(input_channel(i,j)+1) / (r*c)); %二重循环代入公式，实现均衡化
        end
    end
    end

    function [output3] = hist_equal_HSI(input_channel)
    %you should complete this sub-function 
    %input_channel = im2uint8(input_channel);
    [H,S,I] = rgb2hsi(input_channel);
    I_new = double(hist_equal(I)); %对i作均衡化处理
    output3 = cat(3,H,S,I_new);
    output3 = hsi2rgb(output3);

        function [H,S,I] = rgb2hsi(rgb)
            rgb = double(rgb);%转化为double类型
            r = rgb(:, :, 1);
            g = rgb(:, :, 2);
            b = rgb(:, :, 3); %提取三个通道数据
            %利用转化公式进行计算
            x = 2 * r - g - b;
            y = 2 * sqrt((r-g).^2 + (r-b).*(g-b));
            zero = find(y == 0);
            y(zero) = eps; %防止除数为0
            w = acos(x./y);
            H = w;
            change = find(b > g);
            H(change) = 2 * pi - w(change);
            sum = r + g + b;
            zero = find(sum == 0);
            sum(zero) = eps;%防止除数为0
            S = 1 - (3 * min(min(r, g), b) ./ sum);
            I = sum / 3;
            zero = find(S == 0);
            H(zero) = 0;
            zero = find(I == (eps/3));%即之前sum == 0的位置
            H(zero) = 0;
            S(zero) = 0;
            I = uint8(sum / 3);%强度取整
        end
        
        function [rgb] = hsi2rgb(hsi)
            H = hsi(:, :, 1);
            S = hsi(:, :, 2);
            I = hsi(:, :, 3); %提取三个通道数据
            [r,c] = size(H);
            R = zeros(r,c);
            G = R;
            B = G;
            %利用转化公式进行计算,对不同区域分别处理
            for i = 1:r
                for j = 1:c
                    if((H(i,j) < 4 * pi / 3) && (H(i,j) >= 0))
                        B(i,j) = I(i,j) * (1 - S(i,j));
                        G(i,j) = 3 * I(i,j) - (R(i,j) + B(i,j));
                        R(i,j) = I(i,j) * (1 + S(i,j) * cos(H(i,j)) / cos(pi / 3 - H(i,j)));
                    end

                    if((H(i,j) >= 2 * pi / 3) && (H(i,j) < 4 * pi / 3))
                        H(i,j) = H(i,j) - 2 * pi / 3;
                        R(i,j) = I(i,j) * (1 - S(i,j));
                        B(i,j) = 3 * I(i,j) - (R(i,j) + B(i,j));
                        G(i,j) = I(i,j) * (1 + S(i,j) * cos(H(i,j)) / cos(pi / 3 - H(i,j)));
                    end

                    if((H(i,j) >= 4 * pi / 3) && (H(i,j) < 2 * pi))
                        H(i,j) = H(i,j) - 4 * pi / 3;
                        G(i,j) = I(i,j) * (1 - S(i,j));
                        R(i,j) = 3 * I(i,j) - (R(i,j) + B(i,j));
                        B(i,j) = I(i,j) * (1 + S(i,j) * cos(H(i,j)) / cos(pi / 3 - H(i,j)));
                    end
                end
            end
            R=uint8(R);
            G=uint8(G);
            B=uint8(B);
            rgb = cat(3,R,G,B);
        end
    end

    function [output4] = hist_equal_HSV(input_channel)
    %you should complete this sub-function 
    % input_channel = im2uint8(input_channel);
    HSI = rgb2hsv(input_channel);
    H=HSI(:,:,1);
    S=HSI(:,:,2);
    V=HSI(:,:,3);
    V_new = im2double(hist_equal(V));%对v进行均衡化
    output4 = cat(3,H,S,V_new);
    output4 = hsv2rgb(output4);
    end
end
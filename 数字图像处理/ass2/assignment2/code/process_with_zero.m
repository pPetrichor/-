function [g_r] = process_with_zero(I,type,D_0)
    I = im2double(I);
    figure;subplot(3,3,1);imshow(I);
    [X,Y] = size(I);
    P = 2*X;
    Q = 2*Y;
    J = zeros(P,Q);
    J(1:X,1:Y) = J(1:X,1:Y) + I;
    subplot(3,3,2);imshow(J);
    for i = 1:P
        for j = 1:Q
            J(i,j) = J(i,j) * (-1)^(i+j);
        end
    end
    subplot(3,3,3);imshow(J);
    F_J = fft2(J,P,Q);
    % figure, imshow(uint8(abs(F_J)));
    % T = uint8(abs(F_J)) * 10;
    T = uint8(log(1 + abs(F_J)) * 20);
    subplot(3,3,4);imshow(T);
    H = low_pass_fliter(type,P,Q,D_0);
    subplot(3,3,5);imshow(H);
    G = H.*F_J;
    T_1 = uint8(log(1 + abs(G)) * 20);
    subplot(3,3,6);imshow(T_1);
    g = real(ifft2(G)); %做傅里叶反变换
    for i = 1:P
        for j = 1:Q
            g(i,j) = g(i,j) * (-1)^(i+j);
        end
    end
    subplot(3,3,7);imshow(g);
    g_r = g(1:X,1:Y);
    subplot(3,3,8);imshow(g_r);
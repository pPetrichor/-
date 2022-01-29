function [g_r] = process_with_zero(I,type,D_0)
    I = im2double(I);
    [X,Y] = size(I);
    P = 2*X;
    Q = 2*Y;
    J = zeros(P,Q);
    J(1:X,1:Y) = J(1:X,1:Y) + I;
    for i = 1:P
        for j = 1:Q
            J(i,j) = J(i,j) * (-1)^(i+j);
        end
    end
    F_J = fft2(J,P,Q);

    H = low_pass_fliter(type,P,Q,D_0);
    G = H.*F_J;
    
    g = real(ifft2(G)); %做傅里叶反变换
    for i = 1:P
        for j = 1:Q
            g(i,j) = g(i,j) * (-1)^(i+j);
        end
    end
    g_r = g(1:X,1:Y);
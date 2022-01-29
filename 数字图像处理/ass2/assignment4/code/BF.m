function output = BF(I,r,s_d,s_r) %r��ʾģ��뾶��s_d��ʾ�ռ���ķ��s_r��ʾֵ��ķ���
I = im2double(I);
[m,n] = size(I);
% ����ԭͼƬ���б�Ե���
I_padding = zeros(m + 2 * r, n + 2 * r);
I_padding(r+1:r+m,r+1:r+n) = I;
I_padding(1:r,r+1:n+r) = I(1:r,1:n);
I_padding(1:m+r,n+r+1:n+2*r) = I_padding(1:m+r,n+1:n+r);
I_padding(m+r+1:m+2*r,r+1:n+2*r) = I_padding(m+1:m+r,r+1:n+2*r);
I_padding(1:m+2*r,1:r) = I_padding(1:m+2*r,r+1:2*r);

dis = zeros(2 * r + 1,2 * r + 1); %���ɾ���ģ��
for i = 1:2 * r + 1
    for j = 1:2 * r + 1
        dis(i,j) = (i - (r + 1))^2 + (j - (r + 1))^2;
    end
end

for i = r+1:r+m
    for j = r+1:r+n
        w = I_padding(i - r:i + r,j - r:j + r); %ģ�崦�������
        fr = abs(w - I_padding(i,j));
        fr = exp(- fr .^ 2 / (2 * s_r ^ 2));
        %����ֵ���fr
        fd = exp(- dis / (2 * s_d ^ 2));
        %����ռ����fd
        op = fd .* fr;
        op = op / sum(sum(op));
        %��˵õ��˲���
        I_padding(i,j) = sum(sum(w .* op));
        %���
    end
end
       
output = I_padding(r+1:r+m,r+1:r+n);
end

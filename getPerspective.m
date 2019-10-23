function perspective_mat = getPerspective(moving_points,fixed_points)
% GETPERSPECTIVE ���ݵ��ȡ͸�ӱ任����
% ���룺
%     moving_points��n*2�㼯����(x,y)
%     fixed_points��n*2�㼯����(x,y),��˳��Ҫ��Ӧmoving_points
% �����
%     perspective_mat��3*3͸�ӱ任����
% 
%  perspective_mat������ʽΪ[a11,a12,a13; a21,a22,a23; a31,a32,1];
%   ����fixed_points = perspective_mat*moving_points
% author: cuixing158@foxmail.com
%

assert(size(moving_points,1) == size(fixed_points,1)&& ...
size(moving_points,1)>=4);

nums = size(moving_points,1);
coefficient_mat = zeros(2*nums,8);
b = zeros(2*nums,1);
for i = 1:nums
    currentPoint = moving_points(i,:);
    currentFixedPoint = fixed_points(i,:);
    coefficient_mat(2*i-1,:) = [currentPoint(1),currentPoint(2),1,...
        0,0,0,...
        -currentPoint(1)*currentFixedPoint(1),-currentFixedPoint(1)*currentPoint(2)];
    b(2*i-1) = currentFixedPoint(1);
    
    coefficient_mat(2*i,:) = [0,0,0,...
        currentPoint(1),currentPoint(2),1,...
        -currentPoint(1)*currentFixedPoint(2),-currentPoint(2)*currentFixedPoint(2)];
    b(2*i) = currentFixedPoint(2);
end
perspective_mat = coefficient_mat\b; % ����4����ʱ��Ϊ��С���˷�����
perspective_mat = reshape([perspective_mat;1],3,3)';
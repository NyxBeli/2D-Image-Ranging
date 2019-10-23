function perspective_mat = getPerspective(moving_points,fixed_points)
% GETPERSPECTIVE 根据点获取透视变换矩阵
% 输入：
%     moving_points：n*2点集坐标(x,y)
%     fixed_points：n*2点集坐标(x,y),点顺序要对应moving_points
% 输出：
%     perspective_mat：3*3透视变换矩阵
% 
%  perspective_mat矩阵形式为[a11,a12,a13; a21,a22,a23; a31,a32,1];
%   满足fixed_points = perspective_mat*moving_points
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
perspective_mat = coefficient_mat\b; % 大于4个点时候为最小二乘法计算
perspective_mat = reshape([perspective_mat;1],3,3)';
addpath('./provided_code/');

%load data and select the region
load('twoFrameData.mat');
inRegion = selectRegion(im1, positions1);
getRegion = descriptors1(inRegion, :);

%calculate the euclidean distance
euclideanDis = dist2(getRegion, descriptors2);
region_SIFT = zeros(size(descriptors2,1), 1);

%calculate the final SIFT
final_SIFT_index = 0;
for i = 1:size(euclideanDis,1)
    current_val = min(euclideanDis(i,:));
    if (current_val) < 0.2
        [~,index] = min(euclideanDis(i,:));
        final_SIFT_index = final_SIFT_index + 1;
        final_SIFT(final_SIFT_index,1) = index;
    end
end

%display the result
imshow(im2);
displaySIFTPatches(positions2(final_SIFT,:), scales2(final_SIFT), orients2(final_SIFT), im2);
addpath('./provided_code/');
framesdir = './frames/';
siftdir = './sift/';

fname_list = dir([siftdir '/*.mat']);
randInd = randperm(length(fname_list), 50);  

index = 1;
num = length(randInd);
for ind =1:num
    fname = [siftdir '/' fname_list(randInd(ind)).name];
    load(fname);
    [col,row] = size(descriptors);
    
    end_point = index+col-1;
    select_des(index : end_point , :) = descriptors;
    corr_des(index : end_point) = randInd(ind); 
    index_des(index : end_point) = 1:col;
    
    index = index + [col,row];
    
end

[membership, mean, ~] = kmeansML(1500, select_des');
kMeans = mean';
randVal = randperm(length(membership), 2);

while membership(randVal(1)) < 25 ||  membership(randVal(1)) < 25
    randVal = randperm(length(membership), 2);
end

for indexVal = 1:2
    indexMem = find(membership == membership(randVal(indexVal)));
    indexFile = corr_des(indexMem);
    indexDes = index_des(indexMem);
    
    figure;
    for ind = 1:num/2
        fname = fname_list(indexFile(ind));
        img = [siftdir '/' fname.name];
        load(img);
        im = imread([framesdir '/' imname]);
        subplot(5,5,ind);
        imshow(getPatchFromSIFTParameters(positions(indexDes(ind), :), scales(indexDes(ind)), orients(indexDes(ind)), rgb2gray(im)));
    end
end


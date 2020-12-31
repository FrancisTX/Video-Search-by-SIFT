clc;clear;close all;
addpath('./');
load kMeans.mat;

framesdir = './frames/';
siftdir = './sift/';

% Get a list of all the .mat files in that directory.

% There is one .mat file per image.
fnames = dir([siftdir '/*.mat']);

%modify here to change the images 
index_fav=[11,56,88];

descriptors_3=[];
k=1500;

for i=1:3 
    fname = [siftdir '/' fnames(index_fav(i)).name]; %the file begins at NO.60
    load(fname, 'imname', 'descriptors');
    n2 = dist2(kMeans, descriptors);
    [min_value,index] = min(n2);
    [n,bin] = histc(index,1:k);
    n_zs(i,:) =zscore(n);
     
end

for i=1:length(fnames) 
    fname = [siftdir '/' fnames(i).name]; %the file begins at NO.60
    load(fname, 'descriptors');
    n2 = dist2(kMeans, descriptors);
    [min_value,index] = min(n2);
    [n,bin] = histc(index,1:k);
    for j=1:3 
        score(i,j)=dot(zscore(n),n_zs(j,:));
    end
end

for i=1:3 
    fname = [siftdir '/' fnames(index_fav(i)).name]; %the file begins at NO.60
    load(fname, 'imname');
    % read in the associated image
    imname = [framesdir '/' imname]; % add the full path
    figure;
    subplot(2,3,1)
    imshow(imname);
    title("Current Image");
    [score_sort,index_sort] = sort(score(:,i));
    
    for j=2:6
        fname = [siftdir '/' fnames(index_sort(end-j)).name];
        load(fname, 'imname');
        subplot(2,3,j)
        imname = [framesdir '/' imname]; % add the full path
        imshow(imname);
        title("Matched Image");   
    end
end  
    
    
    
clc;clear;close all;
addpath('./');
load kMeans.mat;

framesdir = './frames/';
siftdir = './sift/';

% Get a list of all the .mat files in that directory.

% There is one .mat file per image.
fnames = dir([siftdir '/*.mat']);

index_fav=[70,115,147];
descriptors_3=[];
k=1000;

% Loop through all the data files found
for i=1:3 
    % load that file
    fname = [siftdir '/' fnames(index_fav(i)-59).name]; %the file begins at NO.60
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    imname = [framesdir '/' imname]; % add the full path
    % read in the associated image
    im = imread(imname);
    figure;
    [oninds] = selectRegion(im, positions);
    descriptors_3 = [descriptors_3;descriptors(oninds,:)];
end  
% kmeans
%[membership,means,rms] = kmeansML(k,descriptors_3');
BOW_descriptors = kMeans;

for i=1:3 
    fname = [siftdir '/' fnames(index_fav(i)-59).name]; %the file begins at NO.60
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    n2 = dist2(BOW_descriptors, descriptors);
    [min_value,index] = min(n2);
    [n,bin] = histc(index,1:k);
    n_zs(i,:) =zscore(n);
     
end

for i=1:length(fnames) 
    fname = [siftdir '/' fnames(i).name]; %the file begins at NO.60
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    n2 = dist2(BOW_descriptors, descriptors);
    [min_value,index] = min(n2);
    [n,bin] = histc(index,1:k);
    for j=1:3 
        score(i,j)=dot(zscore(n),n_zs(j,:));
    end
end

for i=1:3 
    [score_sort,index_sort] = sort(score(:,i));
    figure;
    for j=1:5
        fname = [siftdir '/' fnames(index_sort(end-j+1)).name];
        load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
        subplot(2,3,j)
        imname = [framesdir '/' imname]; % add the full path
        imshow(imname);
    end
end  
    
    
    

# Heading
###### Heading

%% Read image
clear
clc
close all

file_extension = '.bmp';
folder_path_open = "D:\Experimental data\900x900 orig\";
imagefiles = dir(folder_path_open + '*' + file_extension);
nfiles = length(imagefiles); % number of images in the folder
disp([int2str(nfiles), ' images found']);

% Read first image in order to get image size
test_image = im2gray(imread(folder_path_open+imagefiles(1).name));
[image_height, image_width] = size(test_image);
disp(['Resolution: ', int2str(image_width), 'x', int2str(image_height)])
% Enter m and range of analyzed images
prompt = {'Enter size of set:', 'Enter step between images:'};
dlgtitle = 'Image range';
dims = [1 40];
definput = {'200', '1'}; %int2str(nfiles)
answer = inputdlg(prompt, dlgtitle, dims, definput);

% Get data from input
m = str2double(answer{2});
number_of_images_in_set = str2double(answer{1}); 
disp(['Analyzing ', num2str(ceil(number_of_images_in_set/m)), ' images in one set'])
% Initialize activity map
answer = questdlg('Save images?', 'Save image',	'Yes','No', 'No');
tic
activity_map = zeros(image_height,image_width);
difference = zeros(image_height,image_width);
counter = 0;
%% Read and analyze speckle images
for n_set = 1:number_of_images_in_set:nfiles
    if n_set + number_of_images_in_set - 1 >  nfiles
        break
    end
    for n = n_set:n_set+number_of_images_in_set-m-1   
        first_file = folder_path_open + int2str(n) + file_extension;
        second_file = folder_path_open + int2str(n+m) + file_extension;
        first_value = double(im2gray(imread(first_file))); 
        second_value = double(im2gray(imread(second_file)));
        for i = 1:image_height
            for j = 1:image_width
                    difference(i,j) = abs(first_value(i,j) - second_value(i,j))/(first_value(i,j) + second_value(i,j));                            
                    activity_map(i,j) = activity_map(i,j) + (difference(i,j)/(number_of_images_in_set-1));%(ceil(number_of_images_in_set/m)));
            end       
        end
    end

% Show acivity map 
    counter = counter + 1;
    figure;
    imshow(activity_map);
    colormap('turbo');
    
    caxis('auto')
    colorbar;
    %imagesc(activity_map) 
    %axis image
    %c = colorbar;
    %c.Label.String = 'Activity';
    %colormap 'turbo'
    %caxis([0 0.4])
    %title(['M = ', int2str(m), '. Range: ',int2str(n_set), '-', int2str(number_of_images_in_set+n_set-1), ' Images'])
    %disp(['Obtained ', num2str(counter), ' activity map'])
    switch answer
        case 'Yes'
        imwrite(activity_map*256, turbo(256), "activity_map_on" + num2str(counter) + ".bmp")
    end
    activity_map = zeros(image_height,image_width);
end
toc


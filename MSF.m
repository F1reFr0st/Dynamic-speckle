%% Enter settings
clear
clc
close all

file_extension = '.bmp'; % Enter file extension of analyzed images
folder_path = "D:\Experimental data\900x900 orig\"; % Enter folder path of analyzed images

% Find and show number of images in the folder
imagefiles = dir(folder_path + '*' + file_extension);
nfiles = length(imagefiles); % number of images in the folder
disp([int2str(nfiles), ' images found']);

% Read first image in order to get image size
test_image = im2gray(imread(folder_path+imagefiles(1).name));
[image_height, image_width] = size(test_image);
disp(['Resolution: ', int2str(image_width), 'x', int2str(image_height)])

% Enter number of analyzed images in one set and m step
prompt = {'Enter size of set:', 'Enter step between images:'};
dlgtitle = 'Image range';
dims = [1 40];
definput = {'200', '1'}; % By default size of set is: 200; M step value is: 1
answer = inputdlg(prompt, dlgtitle, dims, definput);

% Get infromation from input
m = str2double(answer{2});
number_of_images_in_set = str2double(answer{1}); 
disp(['Analyzing ', num2str(ceil(number_of_images_in_set)), ' images in one set'])

% Choose whether to save obtained activity maps or not
answer = questdlg('Save images?', 'Save image',	'Yes','No', 'No');

tic
% Сreate arrays with the dimensions of the image's resolution
activity_map = zeros(image_height,image_width);
difference = zeros(image_height,image_width);
counter = 1;
%% Analyze speckle images with Normalized modified structure algorithm
for n_set = 1:number_of_images_in_set:nfiles % Go through all images, seperated to sets 
    if n_set + number_of_images_in_set - 1 >  nfiles % Stop calculating activity map in case number of 
        break                                        % Number of required image is higher then last image number 
    end
    for n = n_set:n_set+number_of_images_in_set-m-1 % Analyze images in exact set   
        first_file = folder_path + int2str(n) + file_extension;
        second_file = folder_path + int2str(n+m) + file_extension;
        first_value = double(im2gray(imread(first_file))); 
        second_value = double(im2gray(imread(second_file)));
        for i = 1:image_height
            for j = 1:image_width
                % Algorithm equation 
                    difference(i,j) = abs(first_value(i,j) - second_value(i,j))/(first_value(i,j) + second_value(i,j));                            
                    activity_map(i,j) = activity_map(i,j) + (difference(i,j)/(number_of_images_in_set-1));
            end       
        end
    end

% Show acivity maps
    figure;
    imshow(activity_map);
    colormap('turbo');    
    caxis('auto')
    colorbar;

% Save activity maps if needed
    switch answer
        case 'Yes'
        imwrite(activity_map*256, turbo(256), "activity_map_" + num2str(counter) + ".bmp")
    end
    counter = counter + 1;
    activity_map = zeros(image_height,image_width);
end
toc


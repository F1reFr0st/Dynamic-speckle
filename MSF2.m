%% Enter settings
clear
clc
close all

Folder_path % Setup file extension and folder path

% Find and show number of images in the folder
imagefiles = dir(input_folder_path + '*' + file_extension);
nfiles = length(imagefiles); % number of images in the folder
disp([int2str(nfiles), ' images found']);

% Read first image in order to get image size
test_image = im2gray(imread(input_folder_path+imagefiles(1).name));
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
n_analyzed_pairs = ceil(number_of_images_in_set/m)-1;
disp(['Analyzing ', num2str(n_analyzed_pairs), '  pairs of images in one set'])

if mod(nfiles, number_of_images_in_set) ~= 0 % If total number of images is
    % not multiple of number of images in one set, reduce total number of 
    % images to be multiple   
    nfiles = nfiles - mod(nfiles, number_of_images_in_set);
end

tic
% Сreate arrays with the dimensions of the image's resolution
activity_map = zeros(image_height,image_width);
difference = zeros(image_height,image_width);
%% Analyze speckle images with Normalized modified structure algorithm
for n_set = 1:number_of_images_in_set:nfiles % Go through all images, seperated to sets 
    for n = n_set:m:n_set+number_of_images_in_set-m-1 % Analyze images in exact set 
        first_image = get_image(input_folder_path, n, file_extension) ; % Load first image
        second_image = get_image(input_folder_path, n+m, file_extension); % Load second image
        % Modified structure function algorithm
        difference = abs(first_image - second_image)./(first_image + second_image);
        activity_map = activity_map + difference./(n_analyzed_pairs);        
    end

% Show acivity maps
    figure;
    imshow(activity_map, "Colormap", turbo, 'DisplayRange', [ ]);
    title(sprintf('Set: %d - %d, m step: %d', n_set, n_set+number_of_images_in_set-1, m))    
    colorbar;

end
toc

function image = get_image(folder_path, n, file_extension)
    image_path = folder_path + int2str(n) + file_extension;
    image = double(im2gray(imread(image_path)));
end

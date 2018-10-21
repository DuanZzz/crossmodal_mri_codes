% Demo to mask an image with a circle.
% Requires the Image Processing Toolbox.
%
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 20;

% Change the current folder to the folder of this m-file.
if(~isdeployed)
	cd(fileparts(which(mfilename)));
end
	
% Read in a standard MATLAB gray scale demo image.
folder = fullfile(matlabroot, '\toolbox\images\imdemos');
% Comment out whichever demo image you don not want to use.
baseFileName = 'cameraman.tif'; % Grayscale demo image.
baseFileName = 'peppers.png'; % Color demo image.

fullFileName = fullfile(folder, baseFileName);
% See if the image exists.
if ~exist(fullFileName, 'file')
	% Doesn't exist in that folder. See if it exists anywhere on the path.
	fullFileName = baseFileName;
	if ~exist(fullFileName, 'file')
		errorMessage = sprintf('Error: file %s not found', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
% Read in the image from disk.
originalImage = imread(fullFileName);
% Get the dimensions of the image.  numberOfColorBands should be = 1.
[rows, columns, numberOfColorBands] = size(originalImage);
% Display the original gray scale image.
subplot(2, 2, 1);
imshow(originalImage, []);
% Change imshow to image() if you don't have the Image Processing Toolbox.
title('Original Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'Position', get(0,'Screensize')); 
set(gcf,'name','Image Analysis Demo','numbertitle','off') 

% Initialize parameters for the circle,
% such as it's location and radius.
circleCenterX = 130; 
circleCenterY =  75; % square area 0f 500*500 
circleRadius = 50;    % big circle radius 

% Initialize an image to a logical image of the circle. 
circleImage = false(rows, columns); 
[x, y] = meshgrid(1:columns, 1:rows); 
circleImage((x - circleCenterX).^2 + (y - circleCenterY).^2 <= circleRadius.^2) = true; 
% Display it in the upper right plot. 
subplot(2,2,2); 
imshow(circleImage, []); 
% Change imshow to image() if you don't have the Image Processing Toolbox.
title('Circle Mask', 'FontSize', fontSize); 
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
drawnow;

% Mask the image with the circle.
if numberOfColorBands == 1
	maskedImage = originalImage; % Initialize with the entire image.
	maskedImage(~circleImage) = 0; % Zero image outside the circle mask.
else
	% Mask the image.
	maskedImage = bsxfun(@times, originalImage, cast(circleImage,class(originalImage)));
end

% Display it in the lower right plot. 
subplot(2, 3, 5); 
imshow(maskedImage, []); 
% Change imshow to image() if you don't have the Image Processing Toolbox.
title('Image masked with the circle.', 'FontSize', fontSize); 


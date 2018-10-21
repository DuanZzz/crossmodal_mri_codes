% Demo to write an ellipse and a line into the overlay of an image,
% and then to burn those overlays into the image.

%----- Initializing steps -----
% Clean up
clc;
clear all;
close all;
workspace; % Display the workspace panel.

hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	% User does not have the toolbox installed.
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
end

% Display images to prepare for the demo.
monochromeImage = imread('pout.tif');
subplot(2, 4, 1);
imshow(monochromeImage);
title('Original Image');
subplot(2, 4, 2);
imshow(monochromeImage);
title('Original Image with ellipse in overlay');
subplot(2, 4, 5);
imshow(monochromeImage);
title('Original Image');
subplot(2, 4, 6);
imshow(monochromeImage);
title('Original Image with line in overlay');
set(gcf, 'units','normalized','outerposition',[0 0 1 1]); % Maximize figure.
set(gcf,'name','Image Analysis Demo','numbertitle','off') 

%----- Burn ellipse into image -----
% Create elliptical mask, h, as an ROI object over the second image.
subplot(2, 4, 2);
hEllipse = imellipse(gca,[10 10 50 150]); % Second argument defines ellipse shape and position.
% Create a binary image ("mask") from the ROI object.
binaryImage = hEllipse.createMask();
% Display the ellipse mask.
subplot(2, 4, 3);
imshow(binaryImage);
title('Binary mask of the ellipse');
% Let's try to add some text.  (Doesn't work)
% hText = text(50, 100, 'Line of Text');
% textMask = hText.createMask();
% binaryImage = binaryImage & textMask;
% imshow(binaryImage);
% Burn ellipse into image by setting it to 255 wherever the mask is true.
monochromeImage(binaryImage) = 255;
% Display the image with the "burned in" ellipse.
subplot(2, 4, 4);
imshow(monochromeImage);
title('New image with ellipse burned into image');

%----- Burn line into image -----
burnedImage = imread('pout.tif');
% Create line mask, h, as an ROI object over the second image in the bottom row.
subplot(2, 4, 6);
hLine = imline(gca,[10 100],[10 100]); % Second argument defines line endpoints.
% Create a binary image ("mask") from the ROI object.
binaryImage2 = hLine.createMask();
% Display the line mask.
subplot(2, 4, 7);
imshow(binaryImage2);
title('Binary mask of the line');
% Burn line into image by setting it to 255 wherever the mask is true.
burnedImage(binaryImage2) = 255;
% Display the image with the "burned in" line.
subplot(2, 4, 8);
imshow(burnedImage);
title('New image with line burned into image');
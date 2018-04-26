clear all   
clc
%        delete(instrfind); %delete connected ports
% % s=connect_bluetooth;
% % fprintf(s,'L');
%cam=webcam('winvideo', 1, 'YUY2_640x480','ROI',[1 1 640 480]);   %create webcam object
my_new_webcam=webcam();   %create webcam object
 

% Input_right_image=imread('RIGHT.jpg');
% Input_left_image=imread('LEFT.jpg');
% Input_noface_image=imread('no_face.jpg');
% Input_straight_image=imread('STRAIGHT.jpg');

Face_detector_object = vision.CascadeObjectDetector(); % Create a detector for face using Viola-Jones
% Eye_detector1_object = vision.CascadeObjectDetector('EyePairSmall'); %create detector for eyepair

while true % Infinite loop to continuously detect the face
    
    vid=snapshot(my_new_webcam);  %get a snapshot of webcam
    vid = rgb2gray(vid);    %convert to grayscale
    img = flip(vid, 2); % Flips the image horizontally
    
     bbox = step(Face_detector_object, img); % Creating bounding box using Face_detector_object  
      
     if ~ isempty(bbox)  %if face exists 
         biggest_box=1;     
         for i=1:rank(bbox) %find the biggest face
             if bbox(i,3)>bbox(biggest_box,3)
                 biggest_box=i;
             end
         end
         faceImage = imcrop(img,bbox(biggest_box,:)); % extract the face from the image
        % bboxeyes = step(Eye_detector1_object, faceImage); % locations of the eyepair using detector
         
         subplot(2,2,1),subimage(img); hold on; % Displays full image
         for i=1:size(bbox,1)    %draw all the regions that contain face
             rectangle('position', bbox(i, :), 'lineWidth', 2, 'edgeColor', 'y');
         end
         
         subplot(2,2,3),subimage(faceImage);     %display face image
                 
 
     
           
     end
 
end


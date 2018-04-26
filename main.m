clear all   
clf('reset');
%        delete(instrfind); %delete connected ports
% % s=connect_bluetooth;
% % fprintf(s,'L');
%cam=webcam('winvideo', 1, 'YUY2_640x480','ROI',[1 1 640 480]);   %create webcam object
my_new_webcam=webcam();   %create webcam object
 

Input_right_image=imread('RIGHT.jpg');
Input_left_image=imread('LEFT.jpg');
Input_noface_image=imread('no_face.jpg');
Input_straight_image=imread('STRAIGHT.jpg');

Face_detector_object = vision.CascadeObjectDetector(); % Create a detector for face using Viola-Jones
Eye_detector1_object = vision.CascadeObjectDetector('EyePairSmall'); %create detector for eyepair

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
         bboxeyes = step(Eye_detector1_object, faceImage); % locations of the eyepair using detector
         
         subplot(2,2,1),subimage(img); hold on; % Displays full image
         for i=1:size(bbox,1)    %draw all the regions that contain face
             rectangle('position', bbox(i, :), 'lineWidth', 2, 'edgeColor', 'y');
         end
         
         subplot(2,2,3),subimage(faceImage);     %display face image
                 
         if ~ isempty(bboxeyes)  %check it eyepair is available
             
             biggest_box_eyes=1;     
             for i=1:rank(bboxeyes) %find the biggest eyepair
                 if bboxeyes(i,3)>bboxeyes(biggest_box_eyes,3)
                     biggest_box_eyes=i;
                 end
             end
             
             bboxeyeshalf=[bboxeyes(biggest_box_eyes,1),bboxeyes(biggest_box_eyes,2),bboxeyes(biggest_box_eyes,3)/3,bboxeyes(biggest_box_eyes,4)];   %resize the eyepair width in half
             
             eyesImage = imcrop(faceImage,bboxeyeshalf(1,:));    %extract the half eyepair from the face image
             eyesImage = imadjust(eyesImage);    %adjust contrast

             r = bboxeyeshalf(1,4)/4;
             [centers, radii, metric] = imfindcircles(eyesImage, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', 0.93); % Hough Transform
             [M,I] = sort(radii, 'descend');
                 
             eyesPositions = centers;
                 
             subplot(2,2,2),subimage(eyesImage); hold on;
              
             viscircles(centers, radii,'EdgeColor','b');
                  
             if ~isempty(centers)
                pupil_x=centers(1);
                disL=abs(0-pupil_x);    %distance from left edge to center point
                disR=abs(bboxeyes(1,3)/3-pupil_x);%distance from right edge to center point
                subplot(2,2,4);
                if disL>disR+16
                    subimage(Input_right_image);
                 %    fprintf(s,'1');
                else if disR>disL
                    subimage(Input_left_image);
                 %    fprintf(s,'2');
                    else 
                       subimage(Input_straight_image); 
               %       fprintf(s,'3');
                       
                       
                    end
             
                end
     
             end          
         end
     else
        subplot(2,2,4);
        subimage(Input_noface_image);
      %   fprintf(s,'0');
        
     end
     set(gca,'XtickLabel',[],'YtickLabel',[]);

   hold off;
end


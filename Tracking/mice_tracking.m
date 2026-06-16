function mice_tracking(filename,threshold,crop,init_frame,openfield_param,scotch,scotch_end,outlier)

% Threshold for black and white discrimination
% Crop : vector (4 coordinate) to crop the image from camera
% Init frame : frame number for which you want to start the analysis
% Openfield_param : x and y center of the circle + radius (in pixel)
% Outlier: frames that you should not consider for analysis of
% trajectories/movement/speed

% Open file and get info
videoObj = VideoReader(filename);
number_frames = floor(videoObj.Duration*videoObj.FrameRate);
frame_rate = videoObj.FrameRate; 
time_vector = 0:1/videoObj.FrameRate:(videoObj.Duration);


% Check open-field properties
index_frame = round(number_frames/2);
vidFrame = read(videoObj,init_frame);

h(1)=figure;
hold on; imagesc(vidFrame(crop(1):crop(2),crop(3):crop(4),2));
xcenter = openfield_param(1);
ycenter = openfield_param(2);
openfield_radius = openfield_param(3);
inner_radius = openfield_radius/2;
th = 0:pi/50:2*pi;
xunit = openfield_radius * cos(th) + xcenter;
yunit = openfield_radius * sin(th) + ycenter;
xunit_inner = inner_radius * cos(th) + xcenter;
yunit_inner = inner_radius * sin(th) + ycenter;
hold on; plot(xunit, yunit);
plot(xunit_inner, yunit_inner);
real_diameter =300; %300;  % 245 diameter of the openfield arena (in mm) for white transparent ; 300 for the black arena (batch 2)
pixel_diameter = 2*openfield_radius ;
scale = pixel_diameter/real_diameter ;
openfield_coordinate = [xcenter, ycenter, openfield_radius, inner_radius, pixel_diameter, scale];

% Define scotch positions
if scotch==1  
    scotch_time_position=NaN*ones(number_frames,2); 
    scotch_time_border=NaN*ones(number_frames,4); 
    if isnan(scotch_end)==1
        scotch_end = number_frames;
    end
    k_scotch=1;
    position_number=input('How many scotch positions?');
    while k_scotch<=position_number 
        if position_number==1
            start_number=init_frame;
            end_number=scotch_end;
        else
            start_number=input('Frame number to look at?');
            end_number=input('Last frame?'); % define before movement (or typically before hand to remove scotch visible)
        end
        vidFrame = read(videoObj,start_number);
        diff_im = rgb2hsv(vidFrame);
        
%         diff_imbis = diff_im(:,:,3);  % 2 remplace 1 % pour le contexte
%         diff_imbis = diff_imbis(crop(1):crop(2),crop(3):crop(4))< 0.9;
        
         diff_imbis = diff_im(:,:,2);  % 2 remplace 1
         diff_imbis = diff_imbis(crop(1):crop(2),crop(3):crop(4))< 0.4; %0.7 remplace 0.2 
         %diff_init = imfill(diff_imbis,4,'holes');
         figure(); imagesc(1-diff_imbis); hold on ;
        
%         diff_im = rgb2gray(vidFrame) ;
%         diff_imbis = diff_im(crop(1):crop(2),crop(3):crop(4))< 50; %95; %50; %40;
%         diff_init = imfill(diff_imbis,4,'holes');
%         figure(); imagesc(diff_init); hold on ;
        arena = input('Where should they be?');
        %stats = regionprops(diff_init(arena(1):arena(2),arena(3):arena(4)), 'BoundingBox', 'Centroid','Extrema');
        stats = regionprops(diff_imbis(arena(1):arena(2),arena(3):arena(4)), 'BoundingBox', 'Centroid','Extrema');
        for object = 1:length(stats)
            bb(object,:) = stats(object).BoundingBox + [arena(3),arena(1),0,0];
            bc(object,:) = stats(object).Centroid + [arena(3),arena(1)];
            area(object) = bb(object,3)*bb(object,4);
            scotch_objects(object,:) = [bb(object,1), bb(object,1)+bb(object,3), bb(object,2), bb(object,2)+bb(object,4)];
            rectangle('Position',bb(object,:),'EdgeColor','r','LineWidth',2)
            plot(bc(object,1),bc(object,2), '-m+')
        end
        [~,scotch_id]=max(area);
        scotch_position(k_scotch,1) = bc(scotch_id,1) ;
        scotch_position(k_scotch,2) = bc(scotch_id,2) ;
        scotch_border(k_scotch,1:4) = scotch_objects(scotch_id,:);
        
        scotch_time_position(start_number:end_number,:)=repmat(scotch_position(k_scotch,:),[length(start_number:end_number) 1]);
        scotch_time_border(start_number:end_number,:)=repmat(scotch_border(k_scotch,:),[length(start_number:end_number) 1]);
        k_scotch=k_scotch+1;
    end
end


% Checking initial positions
for k=[1000:1070]%[init_frame+50:init_frame+150]
    index_frame = k;
    vidFrame = read(videoObj,index_frame);
    diff_im_new = rgb2gray(vidFrame) ;
    diff_im = diff_im_new(crop(1):crop(2),crop(3):crop(4))<threshold;
    diff_imbis=diff_im;
    diff_imtris=diff_im;
    for p=1:size(diff_im,1)
        for m=1:size(diff_im,2)
            if sqrt((p-ycenter).^2+(m-xcenter).^2)>openfield_radius; %-openfield_radius/20; %+openfield_radius/5;
                diff_imbis(p,m)=0;
            end
            if sqrt((p-ycenter).^2+(m-xcenter).^2)>openfield_radius+openfield_radius/5;
                diff_imtris(p,m)=0;
            end
            
        end
    end
    
    stats = regionprops(bwlabel(diff_imbis, 8), 'Area','BoundingBox', 'Centroid','Orientation','Extrema','MajorAxisLength','MinorAxisLength');
    for object = 1:length(stats)
        bb(object,:) = stats(object).BoundingBox;
        bc(object,:) = stats(object).Centroid;
        area(object) = bb(object,3)*bb(object,4);
        area_new(object) = stats(object).Area;
        ray(object) = sqrt((bc(object,1)-xcenter)^2+(bc(object,2)-ycenter)^2);
    end
    if k==1000
        mice_area=max(area_new); 
    end
    if length(stats)>0
        [usual_area,ind]=max(area_new); %min(abs(area_new-mice_area));
%         if usual_area < mice_area/20;
%             position(k,1) = position(k-1,1);
%             position(k,2) = position(k-1,2);
%         else
            position(k,1) = bc(ind,1);
            position(k,2) = bc(ind,2);
%        end
    elseif length(stats)==0
        stats = regionprops(bwlabel(diff_imtris, 8), 'Area','BoundingBox', 'Centroid','Orientation','Extrema','MajorAxisLength','MinorAxisLength');
        for object = 1:length(stats)
            bb(object,:) = stats(object).BoundingBox;
            bc(object,:) = stats(object).Centroid;
            area(object) = bb(object,3)*bb(object,4);
            area_new(object) = stats(object).Area;
            ray(object) = sqrt((bc(object,1)-xcenter)^2+(bc(object,2)-ycenter)^2);
        end
        if length(stats)>0
            position(k,1) = bc(1,1);
            position(k,2) = bc(1,2);
        else
            position(k,1) =position(k-1,1);
            position(k,2) = position(k-1,2);
        end
    end
    figure(3);
    imagesc(diff_imtris);
    hold on;
    plot(position(k,1),position(k,2), '-m+')
    if scotch==1
        plot(scotch_time_position(k,1),scotch_time_position(k,2), '-c+')
    end
    pause(1/videoObj.FrameRate)
    title(num2str(k)) ; 
    clear diff_im diff_imbis bb bc area area_new ray inside_field upper_boundary
    clear vidFrame
    k=k+1;
end
    
    
    
%     diff_im_new = rgb2gray(vidFrame) ;
%     diff_im = diff_im_new(crop(1):crop(2),crop(3):crop(4))<threshold;
%     diff_imbis=diff_im; 
%     for p=1:size(diff_im,1)
%         for m=1:size(diff_im,2)
%             if sqrt((p-ycenter).^2+(m-xcenter).^2)>openfield_radius;%openfield_radius/5; 
%                 diff_imbis(p,m)=0; 
%             end
%         end
%     end
%     %diff_im = imfill(diff_im,4,'holes');
%     %diff_im = bwareaopen(diff_im,50); % focus only on "big objects%
%     stats = regionprops(bwlabel(diff_imbis, 8), 'BoundingBox', 'Centroid','Orientation','Extrema','MajorAxisLength','MinorAxisLength');
%     for object = 1:length(stats)
%         bb(object,:) = stats(object).BoundingBox;
%         bc(object,:) = stats(object).Centroid;
%         area(object) = bb(object,3)*bb(object,4);
%         ray(object) = sqrt((bc(object,1)-xcenter)^2+(bc(object,2)-ycenter)^2);
%     end
%     if length(stats)>0
%             [mice_area,ind]=max(area);
%             position(k,1) = bc(ind,1);
%             position(k,2) = bc(ind,2);
%         elseif length(inside_field)==0
%             [~,ind]=min(ray);
%             position(k,1)=bc(ind,1);
%             position(k,2)=bc(ind,2);
%         end
%     end
%     figure(3);
%     imagesc(diff_imbis);
%     hold on;
%     plot(position(k,1),position(k,2), '-m+')
%     if scotch==1
%         plot(scotch_time_position(k,1),scotch_time_position(k,2), '-c+')
%     end
%     pause(1/videoObj.FrameRate)
%     title(num2str(k)) ; 
%     clear diff_im diff_imbis bb bc area ray inside_field upper_boundary
%     clear vidFrame
%     k=k+1;
% end

% threshold_check=input('Is the threshold good?');
% if threshold_check==0
%     threshold=input('Which threshold would you prefer?');
% end

clear videoObj stats diff_im
videoObj = VideoReader(filename);
position = NaN*zeros(number_frames,2);
check_plot=0;
k=1;
disp(number_frames)
while k<=number_frames %|| k <=600*frame_rate+init_frame
       
    if mod(k,1000)==1
        disp(k)
    end
    vidFrame = readFrame(videoObj);
    % Alternative method (if background not too grey)
    %     diff_im = im2bw(vidFrame,graythresh(vidFrame)); %imsubtract(rgb2gray(vidFrame),vidFrame(:,:,2));
    %     if k==1
    %         init_object = diff_im;
    %     end
    %     diff_im = init_object-diff_im; % thresholding
    %     diff_im = imfill(diff_im,4,'holes');
    %     diff_im = bwareaopen(diff_im,50); % focus only on "big objects
    %     stats = regionprops(bwlabel(diff_im(crop(1):crop(2),crop(3):crop(4)), 8), 'BoundingBox', 'Centroid','Orientation','Extrema');
    if any(outlier==k)==1 ||  k<init_frame
        position(k,1) = NaN;
        position(k,2) = NaN;
        
    else
        diff_im_new = rgb2gray(vidFrame) ;
        diff_im = diff_im_new(crop(1):crop(2),crop(3):crop(4))<threshold;
        diff_imbis=diff_im;
        diff_imtris=diff_im; 
        for p=1:size(diff_im,1)
            for m=1:size(diff_im,2)
                if sqrt((p-ycenter).^2+(m-xcenter).^2)>openfield_radius; %+openfield_radius/5;
                    diff_imbis(p,m)=0;
                end
                if sqrt((p-ycenter).^2+(m-xcenter).^2)>openfield_radius+openfield_radius/5;
                    diff_imtris(p,m)=0;
                end

            end
        end
        
        %disp(k)
        stats = regionprops(bwlabel(diff_imbis, 8), 'Area','BoundingBox', 'Centroid','Orientation','Extrema','MajorAxisLength','MinorAxisLength');
        for object = 1:length(stats)
            bb(object,:) = stats(object).BoundingBox;
            bc(object,:) = stats(object).Centroid;
            area(object) = bb(object,3)*bb(object,4);
            area_new(object) = stats(object).Area;
            ray(object) = sqrt((bc(object,1)-xcenter)^2+(bc(object,2)-ycenter)^2);
        end
        if length(stats)>0
            [usual_area,ind]=max(area_new); %max(area);
            if usual_area < mice_area/20; %mice_area/10;
                position(k,1) = position(k-1,1);
                position(k,2) = position(k-1,2);
            else
                position(k,1) = bc(ind,1);
                position(k,2) = bc(ind,2);
            end
        elseif length(stats)==0
            stats = regionprops(bwlabel(diff_imtris, 8), 'BoundingBox', 'Centroid','Orientation','Extrema','MajorAxisLength','MinorAxisLength');
            for object = 1:length(stats)
                bb(object,:) = stats(object).BoundingBox;
                bc(object,:) = stats(object).Centroid;
                area(object) = bb(object,3)*bb(object,4);
                ray(object) = sqrt((bc(object,1)-xcenter)^2+(bc(object,2)-ycenter)^2);
            end
            if length(stats)>0 
                position(k,1) = bc(1,1);
                position(k,2) = bc(1,2);
            else
                position(k,1) =position(k-1,1);
                position(k,2) = position(k-1,2);
            end
        end
        
        
%         if k<=scotch_end
%         
%             fig_dis=figure('visible','off');
%             imagesc(diff_imbis);
%             hold on;
%             plot(position(k,1),position(k,2), '-m+')
%             if scotch==1
%                 plot(scotch_time_position(k,1),scotch_time_position(k,2), '-c+')
% 
%             end
%             saveas(fig_dis,strcat(filename(1:end-4),'_frame_',num2str(k)),'fig')
%             close(fig_dis)
%         end
%         
        clear diff_im diff_imbis diff_imtris bb bc area area_new ray upper_boundary
        
    end
    clear vidFrame
    k=k+1;
end

% Cropping extra time (more than 10 min)
time_duration = 600; 
final_time = find(1:number_frames>time_duration*frame_rate+init_frame,1,'first'); 
if isempty(final_time)==1
    position_final=position(init_frame:end,:); 
    if scotch==1
    scotch_time_position_final=scotch_time_position(init_frame:end,:); 
    scotch_time_border_final=scotch_time_border(init_frame:end,:); 
    end
    time_vector = time_vector(1:size(position_final,1));
else
    position_final=position(init_frame:final_time,:); 
    if scotch==1
        scotch_time_position_final=scotch_time_position(init_frame:final_time,:); 
        scotch_time_border_final=scotch_time_border(init_frame:final_time,:); 
    end
    time_vector = time_vector(1:size(position_final,1));
end

h(2)=figure; hold on;
line([xcenter xcenter],[0 crop(2)-crop(1)],'Color','k')
line([0 crop(4)-crop(1)],[ycenter ycenter],'Color','k')
plot(position_final(:,1),position_final(:,2))
if scotch==1
    plot(scotch_time_position_final(:,1),scotch_time_position_final(:,2),'rs','MarkerSize',12)
end
set(gca,'YDir','reverse');


pixel_movement_x = [diff(position_final(:,1)); NaN];
pixel_movement_y = [diff(position_final(:,2)); NaN];
distance_pixel_dt = 0;
instant_pixel_speed = 0;
instant_speed = 0;

for k=1:size(position_final,1)
    distance_pixel_dt(k) = sqrt(pixel_movement_x(k)^2 + pixel_movement_y(k)^2);
    instant_pixel_speed(k) = distance_pixel_dt(k)*frame_rate;
    instant_speed(k) = instant_pixel_speed(k)/(scale*10); % in cm/sec
end
full_distance = nansum(distance_pixel_dt)/(scale*10); % in cm
average_speed = full_distance*frame_rate/(size(position_final,1) - length(outlier));

disp(strcat('Full distance =',num2str(full_distance)))
disp(strcat('Average speed =',num2str(average_speed)))

speed_threshold=2; 
proportion_time_still = length(find(instant_speed<speed_threshold))/(size(position_final,1)); 
proportion_time_moving = length(find(instant_speed>=speed_threshold))/(size(position_final,1)); 


% Time spent in different compartments (Divide the circular arena into 6 or n sections and transform the pixel coordinate into polar coordinates):
number_sections = 16 ;
time_each_section = zeros(number_sections,1);
time_openfield_center = 0;
time_openfield_border = 0;
pixel_angle = zeros(size(position_final,1),1);
pixel_radius = zeros(size(position_final,1),1);

for k=1:size(position_final,1)
    pixel_radius(k) = sqrt((position_final(k,2)-ycenter)^2 + (position_final(k,1)-xcenter)^2);
    if position_final(k,2) > ycenter && position_final(k,1) > xcenter
        pixel_angle(k) = atan((position_final(k,2)-ycenter)/(position_final(k,1)-xcenter));
    elseif position_final(k,1) < xcenter
        pixel_angle(k) = atan((position_final(k,2)-ycenter)/(position_final(k,1)-xcenter))+pi;
    elseif position_final(k,1) > xcenter && position_final(k,2)<ycenter
        pixel_angle(k) = atan((position_final(k,2)-ycenter)/(position_final(k,1)-xcenter))+2*pi;
    end
    
    for n=1:number_sections/2 % divide between inner and outer + pie chart
        if (pixel_angle(k) > 0 + (n-1)*2*pi/8) && (pixel_angle(k) <= n*2*pi/8)
            if pixel_radius(k) < 0.66*openfield_radius
                time_each_section(n)=time_each_section(n)+1;
                proportion_over_time(k,n) = time_each_section(n)/sum(time_each_section); 
            else
                time_each_section(n+number_sections/2)=time_each_section(n+number_sections/2)+1;
                proportion_over_time(k,n+number_sections/2) = time_each_section(n+number_sections/2)/sum(time_each_section); 
            end
        break
        end
    end
end

a=pixel_radius < inner_radius;
time_openfield_center = nnz(a)/length(pixel_radius);
time_openfield_border = (1-nnz(a))/length(pixel_radius);

h(3)=figure;
subplot(3,1,1)
distance_pixel_dt = distance_pixel_dt ;
distance_pixel_dt(isnan(distance_pixel_dt)) = 0;
plot(time_vector,cumsum(distance_pixel_dt/(scale*1000)));
ylabel('Cumulative distance over time (meter)')
subplot(3,1,2); hold on;
plot(time_vector,instant_speed)
ylabel('Speed in cm/sec')
subplot(3,1,3)
plot(time_vector,movmean(instant_speed,15,'omitnan'))
ylabel('Moving mean speed in cm/sec')

h(4)=figure;
pie(time_each_section/(size(position_final,1)-length(outlier)))
%legend(labels,'Location','southoutside','Orientation','horizontal')

h(5)=figure; 
for ii=1:8
    th = linspace((ii-1)*2*pi/8,ii*2*pi/8);
    xunit = openfield_radius * cos(th);
    yunit = openfield_radius * sin(th);
    xunit_in = 0.66*openfield_radius * cos(th);
    yunit_in = 0.66*openfield_radius * sin(th);
    x=[xunit 0 xunit(1)]; xin=[xunit_in 0 xunit_in(1)];
    y=[yunit 0 yunit(1)]; yin=[yunit_in 0 yunit_in(1)]; 
    P=line(xin,yin); hold on ;
    text(xin(end/2),yin(end/2),strcat(num2str(round(time_each_section(ii)*100/(size(position_final,1)-length(outlier)),2)),'%'))
    text(x(end/2),y(end/3),strcat(num2str(round(time_each_section(ii+8)*100/(size(position_final,1)-length(outlier)),2)),'%'))
    P=line(x,y); 
end

  %cd('/Users/charlotte.piette/Desktop/ARTICLE_ONE_SHOT/Video_jeremy/Second_priority')
savefig(h,strcat(filename(1:end-4),'_openfield_analysis.fig'),'compact')
save(strcat(filename(1:end-4),'_data_analysis'),'frame_rate','openfield_coordinate','number_sections','full_distance','average_speed','instant_pixel_speed','instant_speed','distance_pixel_dt','pixel_angle','pixel_radius','position_final','proportion_over_time','proportion_time_moving','proportion_time_still','speed_threshold','time_each_section','time_openfield_border','time_openfield_center','time_vector')


%% Scotch and movement analysis

if scotch==1
    
    last_scotch_frame = find(isnan(scotch_time_position_final),1,'first');
    scotch_frame = [];
    scotch_time = 0;
    if scotch_end==number_frames
        scotch_end=size(position_final,1);
    else
        scotch_end=scotch_end-init_frame+1;
    end
    
    for k=1:size(position_final,1)
        if k>last_scotch_frame
            break
        end
        if (position_final(k,1) > scotch_time_border_final(k,1)) && (position_final(k,1) < scotch_time_border_final(k,2)) && (position_final(k,2) < scotch_time_border_final(k,3))  && (position_final(k,2) < scotch_time_border_final(k,4))
            scotch_time = scotch_time+1;
            scotch_frame = [scotch_frame, k];
        end
    end

    scotch_time = scotch_time/last_scotch_frame;
    scotch_period = unique(scotch_frame);
    scotching_episode = zeros(size(scotch_time_position_final,1),1);
    scotching_episode(scotch_period) =1;
    
    post_scotch_frame = [];
    post_scotch_time = 0;
    for k=scotch_end:size(scotch_time_position_final,1)
        if (position_final(k,1) > scotch_time_border_final(k,1)) && (position_final(k,1) < scotch_time_border_final(k,2)) && (position_final(k,2) < scotch_time_border_final(k,3))  && (position_final(k,2) < scotch_time_border_final(k,4))
            post_scotch_time = post_scotch_time+1;
            post_scotch_frame = [post_scotch_frame, k];
        end
     end
    post_scotch_time = post_scotch_time/(size(scotch_time_position_final,1) - scotch_end);
    post_scotch_period = unique(post_scotch_frame);
    post_scotching_episode = zeros(size(scotch_time_position_final,1),1);
    post_scotching_episode(post_scotch_period) =1;
    figure();
    subplot(2,1,1);
    plot(time_vector(1:end),scotching_episode);
    title('Time course of episodes near the scotch')
    subplot(2,1,2) ;plot(time_vector(1:end),post_scotching_episode);
    title('Post scotch removal - Revisiting of the scotch location')
    savefig(strcat(filename(1:end-4),'_Scotch_episodes.fig'))
    
    
    number_sections = 16 ;
    time_scotch_section = zeros(number_sections,1);
    pixel_scotch_radius = zeros(size(scotch_time_position_final,1),1);
    pixel_scotch_angle = zeros(size(scotch_time_position_final,1),1);
    for k=1:size(scotch_time_position_final,1)
        pixel_scotch_radius(k) = sqrt((scotch_time_position_final(k,2)-ycenter)^2 + (scotch_time_position_final(k,1)-xcenter)^2);
        if scotch_time_position_final(k,2) > ycenter && scotch_time_position_final(k,1) > xcenter
            pixel_scotch_angle(k) = atan((scotch_time_position_final(k,2)-ycenter)/(scotch_time_position_final(k,1)-xcenter));
        elseif scotch_time_position_final(k,1) < xcenter
            pixel_scotch_angle(k) = atan((scotch_time_position_final(k,2)-ycenter)/(scotch_time_position_final(k,1)-xcenter))+pi;
        elseif scotch_time_position_final(k,1) > xcenter && scotch_time_position_final(k,2)<ycenter
            pixel_scotch_angle(k) = atan((scotch_time_position_final(k,2)-ycenter)/(scotch_time_position_final(k,1)-xcenter))+2*pi;
        else
            pixel_scotch_angle(k) =NaN;
        end
    end

       
%     for k=1:scotch_end
%         for n=1:number_sections/2
%             if (pixel_angle(k) >= 0 + (n-1)*2*pi/8) && (pixel_angle(k) <= n*2*pi/8) && (pixel_scotch_angle(k) >= 0 + (n-1)*2*pi/8) && (pixel_scotch_angle(k) <= n*2*pi/8)
%                 if pixel_radius(k) < 0.66*openfield_radius && pixel_scotch_radius(k) < 0.66*openfield_radius
%                     time_scotch_section(n)=time_scotch_section(n)+1;
%                 elseif pixel_radius(k) > 0.66*openfield_radius && pixel_scotch_radius(k) > 0.66*openfield_radius
%                     time_scotch_section(n+number_sections/2)=time_scotch_section(n+number_sections/2)+1;
%                 end
%             end
%         end
%     end
        
    time_close_scotch = sum(time_scotch_section)*100/(scotch_end-init_frame);
    

    %cd('/Users/charlotte.piette/Desktop/ARTICLE_ONE_SHOT/Video_jeremy/Second_priority')
    save(strcat(filename(1:end-4),'_scotch_analysis'),'scotching_episode','post_scotching_episode','time_scotch_section','time_close_scotch','scotch_time_position_final', 'scotch_time_border_final', 'scotch_end','pixel_scotch_radius', 'pixel_scotch_angle')
  save(strcat(filename(1:end-4),'_scotch_analysis'),'scotching_episode','post_scotching_episode','scotch_time_position_final', 'scotch_time_border_final', 'scotch_end','pixel_scotch_radius', 'pixel_scotch_angle')
end

end








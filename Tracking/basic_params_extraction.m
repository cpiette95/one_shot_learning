function [table_basic_params] = basic_params_extraction(Mice_table,M,mouse_name)

full_distance_table=[]; 
proportion_time_wall_table=[]; 
proportion_time_still_table=[]; 
mean_speed_moving_table=[]; 
number_center_cross=[]; 
number_immobile=[]; 

for index_number=1:size(Mice_table{1,M},1)
        
    date=Mice_table{1,M}{index_number}(1:8);
    session_number=Mice_table{1,M}{index_number}(end-5:end-4);
    init_frame=Mice_table{1,M}{index_number,4};
    
    load(strcat(date,'_',mouse_name,'_',session_number,'_data_analysis.mat'));
    
        
    full_duration(index_number) =600; 
    try
      fileID = VideoReader(char(strcat(date,'_',mouse_name,'_',session_number,'.mp4')));
      number_frames = round(fileID.Duration*fileID.FrameRate);
     full_duration(index_number) = number_frames/frame_rate;
    end

    
    crop_start=0;
    
    position_final_new=position_final(crop_start+2:end,:);
    position_final_new = [sgolayfilt(position_final_new(:,1),3,21) sgolayfilt(position_final_new(:,2),3,21)];
    
    
    openfield_radius = openfield_coordinate(3);
    threshold_external_radius = 2*openfield_radius/3;
    xcenter=openfield_coordinate(1);
    ycenter=openfield_coordinate(2);
    scale = openfield_coordinate(6);
    
    smoothed_pixel_movement_x = [smooth_diff(position_final_new(:,1),1,11)];
    smoothed_pixel_movement_y = [smooth_diff(position_final_new(:,2),1,11)];
    body_instant_speed = ((sqrt(smoothed_pixel_movement_x.^2 + smoothed_pixel_movement_y.^2))*frame_rate)/(openfield_coordinate(6)*10); % in cm/sec
    distance_pixel_dt = sqrt(smoothed_pixel_movement_x.^2 + smoothed_pixel_movement_y.^2);
    [body_angle,body_radius]=cart2pol(position_final_new(:,1)-xcenter,position_final_new(:,2)-ycenter); %centered to the arena
    body_polar_coordinate_center_ref = [body_radius mod(unwrap(body_angle),2*pi)];
    
    
    threshold_external_radius = 2*openfield_radius/3;
    speed_threshold = 2;
    full_distance_table(index_number) = nansum(distance_pixel_dt)/(scale*1000); % in m
    proportion_time_still_table(index_number) = length(find(body_instant_speed<speed_threshold))/(size(position_final_new,1));
    proportion_time_wall_table(index_number) = length(find(body_radius > threshold_external_radius))/(size(position_final_new,1));
    mean_speed_moving_table(index_number) = nanmean(body_instant_speed(body_instant_speed>speed_threshold));
    
    % nombre de traversées par le centre
    threshold_internal_radius = openfield_radius/3;
    cross_internal_rad = find(body_radius < threshold_internal_radius);
    seg = diff(cross_internal_rad) ;
    if length(cross_internal_rad)>=1
        seg = [1;seg(seg~=1)];
    else
        seg = seg(seg~=1);
    end
    number_center_cross(index_number) = length(seg);
    
    %distribution des temps d'immobilité
    immob=find(body_instant_speed<speed_threshold);
    duration_threshold = 60; %1 sec
    seg_immob = diff(immob);
    for k=1:length(seg_immob)
        if seg_immob(k)<5
            seg_immob(k)=1;
        end
    end
    start_seg=find(seg_immob > 1);
    start_seg_timepoint = [immob(1); immob(start_seg+1)];
    start_immob = [1; start_seg+1];
    diff_start_immob = diff(start_immob);
    good_immob=[]; good_immob_timepoint=[];
    for k=1:length(start_immob)-1
        if diff_start_immob(k)>duration_threshold
            good_immob = [good_immob;diff_start_immob(k)./frame_rate];
            good_immob_timepoint = [good_immob_timepoint;start_seg_timepoint(k)./frame_rate];
        end
    end
    if length(seg_immob)-start_immob(end)>duration_threshold
        good_immob = [good_immob ; (length(seg_immob)-start_immob(end))./frame_rate];
        good_immob_timepoint = [good_immob_timepoint;start_seg_timepoint(end)./frame_rate];
        
    end
    
    %         figure(); subplot(2,1,1); hold on;
    %         plot(body_instant_speed)
    %         for k=1:length(good_immob_timepoint)
    %             plot(good_immob_timepoint(k)*frame_rate,5,'rx')
    %         end
    %         subplot(2,1,2); hist(good_immob);
    
    number_immobile(index_number) = length(good_immob);
    
    %save(strcat(date,'_',mouse_name,'_',session_number,'_basic_params.mat'),'crop_start','position_final_new','body_instant_speed','body_polar_coordinate_center_ref','speed_threshold','duration_threshold')

    end

%table_basic_params=[full_distance_table(1) mean_speed_moving_table(1) proportion_time_wall_table(1) proportion_time_still_table(1)  number_center_cross(1) number_immobile(1) NaN full_duration(1) NaN NaN]; % full_distance_table(2) mean_speed_moving_table(2) proportion_time_wall_table(2) proportion_time_still_table(2)  number_center_cross(2) number_immobile(2) NaN full_duration(2) NaN NaN full_distance_table(2)./full_distance_table(1) proportion_time_wall_table(2)./proportion_time_wall_table(1)  proportion_time_still_table(2)./proportion_time_still_table(1) full_distance_table(3) mean_speed_moving_table(3) proportion_time_wall_table(3) proportion_time_still_table(3)  number_center_cross(3) number_immobile(3) NaN full_duration(3) NaN NaN full_distance_table(3)./full_distance_table(2) proportion_time_wall_table(3)./proportion_time_wall_table(2)  proportion_time_still_table(3)./proportion_time_still_table(2)];

   if size(Mice_table{1,M},1)==2
      table_basic_params=[full_distance_table(1) mean_speed_moving_table(1) proportion_time_wall_table(1) proportion_time_still_table(1)  number_center_cross(1) number_immobile(1) NaN full_duration(1) NaN NaN full_distance_table(2) mean_speed_moving_table(2) proportion_time_wall_table(2) proportion_time_still_table(2)  number_center_cross(2) number_immobile(2) NaN full_duration(2) NaN NaN full_distance_table(2)./full_distance_table(1) proportion_time_wall_table(2)./proportion_time_wall_table(1)  proportion_time_still_table(2)./proportion_time_still_table(1)];        
   elseif size(Mice_table{1,M},1)==3
         table_basic_params=[full_distance_table(1) mean_speed_moving_table(1) proportion_time_wall_table(1) proportion_time_still_table(1)  number_center_cross(1) number_immobile(1) NaN full_duration(1) NaN NaN full_distance_table(2) mean_speed_moving_table(2) proportion_time_wall_table(2) proportion_time_still_table(2)  number_center_cross(2) number_immobile(2) NaN full_duration(2) NaN NaN full_distance_table(2)./full_distance_table(1) proportion_time_wall_table(2)./proportion_time_wall_table(1)  proportion_time_still_table(2)./proportion_time_still_table(1) full_distance_table(3) mean_speed_moving_table(3) proportion_time_wall_table(3) proportion_time_still_table(3)  number_center_cross(3) number_immobile(3) NaN full_duration(3) NaN NaN full_distance_table(3)./full_distance_table(2) proportion_time_wall_table(3)./proportion_time_wall_table(2)  proportion_time_still_table(3)./proportion_time_still_table(2)];
    else
        table_basic_params=[full_distance_table(1) mean_speed_moving_table(1) proportion_time_wall_table(1) proportion_time_still_table(1)  number_center_cross(1) number_immobile(1) NaN full_duration(1) NaN NaN full_distance_table(2) mean_speed_moving_table(2) proportion_time_wall_table(2) proportion_time_still_table(2)  number_center_cross(2) number_immobile(2) NaN full_duration(2) NaN NaN full_distance_table(2)./full_distance_table(1) proportion_time_wall_table(2)./proportion_time_wall_table(1)  proportion_time_still_table(2)./proportion_time_still_table(1) full_distance_table(3) mean_speed_moving_table(3) proportion_time_wall_table(3) proportion_time_still_table(3)  number_center_cross(3) number_immobile(3) NaN full_duration(3) NaN NaN full_distance_table(3)./full_distance_table(2) proportion_time_wall_table(3)./proportion_time_wall_table(2)  proportion_time_still_table(3)./proportion_time_still_table(2) full_distance_table(4) mean_speed_moving_table(4) proportion_time_wall_table(4) proportion_time_still_table(4) number_center_cross(4) number_immobile(4) NaN full_duration(4) NaN ];
    end
end


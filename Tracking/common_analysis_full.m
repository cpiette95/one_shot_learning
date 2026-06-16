function [table,table_bis,table_tri,table_quatre,passages_linearity,time_zone,table_30,table_60,table_250,avoidance_params,time_precision,mean_speed_body_beginning] = common_analysis_full(full_name,init_frame,crop,contact_frame_start,contact_frame_end)

%function [table,table_bis,table_tri,table_quatre,passages_linearity,time_zone,table_30,table_60,table_250,avoidance_params,time_precision,mean_speed_body_beginning] = common_analysis_full(mouse_name,date,session_number,init_frame,crop,contact_frame_start,contact_frame_end)
%load(strcat(date,'_',mouse_name,'_',session_number,'_data_analysis.mat'));
%load(strcat(date,'_',mouse_name,'_',session_number,'_scotch_analysis.mat'));
%load(strcat(date,'_',mouse_name,'_',session_number,'_scotch_detection_final.mat'))
%load(strcat(date,'_',mouse_name,'_',session_number,'_position_final.mat'))


load(strcat(full_name,'_data_analysis.mat'));
load(strcat(full_name,'_scotch_analysis.mat'));
load(strcat(full_name,'_scotch_detection_final.mat'))
load(strcat(full_name,'_position_final.mat'))




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

crop_start=0;
start_contact=contact_frame_start-init_frame-crop_start-1;
start_contact = max(start_contact,1);
if contact_frame_start==-1
    start_contact=size(position_final_new,1);
end
if contact_frame_end==-1
    end_contact = size(position_final_new,1);
else
    end_contact=min(size(position_final_new,1),contact_frame_end-init_frame-crop_start-1);
end


% [snout_angle,snout_radius]=cart2pol(snout_data_new(:,1)-xcenter,snout_data_new(:,2)-ycenter);
% snout_polar_coordinate_center_ref = [snout_radius mod(unwrap(snout_angle),2*pi)];
% smoothed_snout_pixel_movement_x = [smooth_diff(snout_data_new(:,1),1,11)];
% smoothed_snout_pixel_movement_y = [smooth_diff(snout_data_new(:,2),1,11)];
% snout_instant_speed = ((sqrt(smoothed_snout_pixel_movement_x.^2 + smoothed_snout_pixel_movement_y.^2))*frame_rate)/(openfield_coordinate(6)*10); % in cm/sec OUF!!!

% Scotch determination
scotch_time_position_final_new = scotch_time_position_final(crop_start+2:end,:);
[scotch_angle,scotch_radius]=cart2pol(scotch_time_position_final_new(:,1)-xcenter,scotch_time_position_final_new(:,2)-ycenter);
before_contact_scotch=unique(scotch_time_position_final_new(1:start_contact,1));
th = 0:pi/200:2*pi;
xunit = openfield_radius * cos(th) + xcenter;
yunit = openfield_radius * sin(th) + ycenter;
xunit_scotch = diameters_scotch(1)/2 * cos(th) + centers_scotch(1,1);
yunit_scotch = diameters_scotch(1)/2 * sin(th) + centers_scotch(1,2);
radius_circle = [4,6,8,10]*10 ;% in mm
[body_angle,body_radius]=cart2pol(position_final_new(:,1)-scotch_time_position_final_new(:,1),position_final_new(:,2)-scotch_time_position_final_new(:,2));
polar_coordinate_scotch_ref = [body_radius mod(unwrap(body_angle),2*pi)];


%     %% General properties:
speed_threshold = 2; % to adjust accordingly
interval_dur = 2; % speed during the first 2 seconds inside the arena
threshold_external_radius = 2*openfield_radius/3;
mean_speed_body_entrance=nanmean(body_instant_speed(1:floor(frame_rate*interval_dur)));

interval_dur_bis=10; 
mean_speed_body_beginning=nanmean(body_instant_speed(1:floor(frame_rate*interval_dur_bis)));

distance_before_contact = nansum(distance_pixel_dt(1:start_contact))/(scale*1000);
proportion_time_still_before_contact = length(find(body_instant_speed(1:start_contact)<speed_threshold))*100./start_contact;
proportion_time_wall_before_contact = length(find(body_polar_coordinate_center_ref(1:start_contact,1) > threshold_external_radius))*100./start_contact;

threshold_internal_radius = openfield_radius/3;
cross_internal_rad = find(body_polar_coordinate_center_ref(1:start_contact,1) < threshold_internal_radius);
seg = diff(cross_internal_rad) ;
if length(cross_internal_rad)>=1
    seg = [1;seg(seg~=1)];
else
    seg = seg(seg~=1);
end
number_center_cross_before_contact = length(seg);

% Speed before contact:
interval_dur = 2; %
if contact_frame_start~=-1
    mean_speed_body_precontact =nanmean(body_instant_speed(max(1,start_contact-floor(frame_rate*interval_dur)):start_contact));
    mean_speed_body_precontact_1sec =nanmean(body_instant_speed(max(1,start_contact-floor(frame_rate):start_contact)));
else
    mean_speed_body_precontact=NaN;
end

% Degree of immobility during contact:
if contact_frame_start~=-1
    immobility_contact = length(find(body_instant_speed(start_contact:end_contact)<speed_threshold))*100/length(body_instant_speed(start_contact:end_contact));
    distance_during_contact = nansum(distance_pixel_dt(start_contact:end_contact))/(scale*1000);
    max_speed_contact= max(body_instant_speed(start_contact:end_contact));
    mean_speed_contact = nanmean(body_instant_speed(start_contact:end_contact));
    % Speed immediately after first contact (5 second)
    speed_contact = mean(body_instant_speed(start_contact:min(end_contact,start_contact+5*frame_rate)));
else
    immobility_contact=NaN;
    distance_during_contact=NaN;
    max_speed_contact=NaN;
    mean_speed_contact=NaN;
    speed_contact=NaN;
end

%Post-contact:
if contact_frame_end~=-1
    last_frame = length(body_instant_speed);
    immobility_post_1min_contact = length(find(body_instant_speed(end_contact:min(end_contact+60*frame_rate,last_frame))<speed_threshold))*100/length(body_instant_speed(end_contact:min(end_contact+60*frame_rate,last_frame)));
    proportion_wall_post_1min_contact = length(find(body_polar_coordinate_center_ref(end_contact:min(end_contact+60*frame_rate,last_frame),1) > threshold_external_radius))*100/length(body_instant_speed(end_contact:min(end_contact+60*frame_rate,last_frame)));
    max_speed_post_contact = max(body_instant_speed(end_contact:min(end_contact+10*frame_rate,last_frame)));
else
    immobility_post_1min_contact=NaN;
    proportion_wall_post_1min_contact=NaN;
    max_speed_post_contact=NaN;
end

figure(); subplot(1,2,1);
%plot(snout_data_new(1:start_contact,1),snout_data_new(1:start_contact,2)); hold on ;
plot(position_final_new(1:start_contact,1),position_final_new(1:start_contact,2))
subplot(1,2,2); hold on;
plot(body_instant_speed(1:start_contact))


%Scotch global interaction:
a=wrapToPi(body_polar_coordinate_center_ref(1:start_contact,2)-scotch_angle(1:start_contact));
index_half_scotch = find(a<pi/2 & a>-pi/2);
index_out_scotch = find(a>pi/2 | a<-pi/2);

time_spent_scotch_half = length(index_half_scotch)*100./length(body_polar_coordinate_center_ref(1:start_contact,2));
time_spent_immobile_scotch_half = length(find(body_instant_speed(index_half_scotch)<speed_threshold))*100./length(index_half_scotch);
time_spent_immobile_out_scotch = length(find(body_instant_speed(index_out_scotch)<speed_threshold))*100./length(index_out_scotch);

   
index_opposite_scotch = find(a>4*pi/6 | a<-4*pi/6);
index_close_scotch = find(a<pi/6 & a>-pi/6);
time_spent_scotch_close=length(index_close_scotch)*100./length(body_polar_coordinate_center_ref(1:start_contact,2));
time_spent_scotch_opposite=length(index_opposite_scotch)*100./length(body_polar_coordinate_center_ref(1:start_contact,2));


index_zone=[];
for wo=1:length(radius_circle)
    radius_circle_pixel = radius_circle(wo)*scale; %(then rescale for pixel size)
    index_zone = find(polar_coordinate_scotch_ref(1:start_contact,1) < radius_circle_pixel); % reference: scotch position
    time_spent_circle_scotch_zone_full(wo) = length(index_zone)*100./length(polar_coordinate_scotch_ref(1:start_contact,1));    
end





if length(before_contact_scotch)==1
    disp('Unique scotch position before contact')
    unique_pos = 1;
else
    disp('More than 1 scotch position before contact')
    unique_pos = 0;
end


if distance_before_contact>=2.5
    
    distance_pixel_dt(isnan(distance_pixel_dt))=0;
    cumul_distance = cumsum(distance_pixel_dt)./(scale*1000);
    index_250 = find(cumul_distance>2.5,1,'first');
    
    figure(); hold on;
    fill(xunit,yunit,'r.-','MarkerSize',12);
    fill(xunit_scotch,yunit_scotch,'w.-','MarkerSize',12);
    plot(position_final_new(1:index_250,1),position_final_new(1:index_250,2),'-ko','MarkerSize',12,'MarkerFaceColor','k')
    axis equal
    axis([min(xunit)-20 max(xunit)+20 min(yunit)-20 max(yunit)+20])
    h(1) = xlabel(''); h(2) = ylabel(''); set(gca, 'Xcolor', 'w', 'Ycolor', 'w')
    set(h, 'Color', 'k') ; set(gca, 'XTick', []); set(gca, 'YTick', []);
    F=getframe(gcf); [X,Map]=frame2im(F); B=rgb2gray(X); B=B<50;
    %saveas(gcf,strcat(date,'_',mouse_name,'_',session_number,'_Area_avoidance_250cm.jpg'))
    
    figure(); hold on;
    fill(xunit,yunit,'r.-','MarkerSize',12);
    fill(xunit_scotch,yunit_scotch,'w.-','MarkerSize',12);
    plot(position_final_new(1:index_250,1),position_final_new(1:index_250,2),'-go','MarkerSize',12,'MarkerFaceColor','g')
    axis equal
    axis([min(xunit)-20 max(xunit)+20 min(yunit)-20 max(yunit)+20])
    h(1) = xlabel(''); h(2) = ylabel(''); set(gca, 'Xcolor', 'w', 'Ycolor', 'w')
    set(h, 'Color', 'k') ; set(gca, 'XTick', []); set(gca, 'YTick', []);
    F=getframe(gcf); [X,Map]=frame2im(F); B=rgb2gray(X);
    surface_walk_250 = sum(sum(B==150));
    
    
    a=wrapToPi(body_polar_coordinate_center_ref(1:index_250,2)-scotch_angle(1:index_250));
    index_half_scotch = find(a<pi/2 & a>-pi/2);
    index_out_scotch = find(a>pi/2 | a<-pi/2);
    index_opposite_scotch = find(a>5*pi/6 | a<-5*pi/6);
    index_close_scotch = find(a<pi/6 & a>-pi/6);
    
    time_near_wall_250=length(find(body_polar_coordinate_center_ref(1:index_250,1) > threshold_external_radius))*100./index_250;
    time_still_250=length(find(body_instant_speed(1:index_250)<speed_threshold))*100./index_250;
    time_immobile_scotch_half_250=length(find(body_instant_speed(index_half_scotch)<speed_threshold))*100./length(index_half_scotch);
    time_immobile_scotch_opposite_250=length(find(body_instant_speed(index_out_scotch)<speed_threshold))*100./length(index_out_scotch);
    time_spent_scotch_half_250=length(index_half_scotch)*100./length(body_polar_coordinate_center_ref(1:index_250,2));
    
    time_spent_scotch_close_250=length(index_close_scotch)*100./length(body_polar_coordinate_center_ref(1:index_250,2));
    time_spent_scotch_opposite_250=length(index_opposite_scotch)*100./length(body_polar_coordinate_center_ref(1:index_250,2));
    
    cross_internal_rad = find(body_polar_coordinate_center_ref(1:index_250,1) < threshold_internal_radius);
    seg = diff(cross_internal_rad) ;
    if length(cross_internal_rad)>=1
        seg = [1;seg(seg~=1)];
    else
        seg = seg(seg~=1);
    end
    number_crosses_250=length(seg);
    
    
else
    surface_walk_250 = NaN;
    time_near_wall_250=NaN;
    time_still_250=NaN;
    time_immobile_scotch_half_250=NaN;
    time_immobile_scotch_opposite_250=NaN;
    time_spent_scotch_close_250=NaN;
    time_spent_scotch_opposite_250=NaN;
    time_spent_scotch_half_250=NaN;
    number_crosses_250=NaN;
end


% Même chose pour 30 sec :
time_threshold=30*frame_rate;
if start_contact>30*frame_rate
    
    a=wrapToPi(body_polar_coordinate_center_ref(1:time_threshold,2)-scotch_angle(1:time_threshold));
    index_half_scotch = find(a<pi/2 & a>-pi/2);
    index_out_scotch = find(a>pi/2 | a<-pi/2);
    index_opposite_scotch = find(a>4*pi/6 | a<-4*pi/6);
    index_close_scotch = find(a<pi/6 & a>-pi/6);
    
    time_near_wall_30=length(find(body_polar_coordinate_center_ref(1:time_threshold,1) > threshold_external_radius))*100./time_threshold;
    time_still_30=length(find(body_instant_speed(1:time_threshold)<speed_threshold))*100./time_threshold;
    time_immobile_scotch_half_30=length(find(body_instant_speed(index_half_scotch)<speed_threshold))*100./length(index_half_scotch);
    time_immobile_scotch_opposite_30=length(find(body_instant_speed(index_out_scotch)<speed_threshold))*100./length(index_out_scotch);
    time_spent_scotch_half_30=length(index_half_scotch)*100./length(body_polar_coordinate_center_ref(1:time_threshold,2));
    time_spent_scotch_close_30=length(index_close_scotch)*100./length(body_polar_coordinate_center_ref(1:time_threshold,2));
    time_spent_scotch_opposite_30=length(index_opposite_scotch)*100./length(body_polar_coordinate_center_ref(1:time_threshold,2));

    
    figure();
    plot(position_final_new(1:time_threshold,1),position_final_new(1:time_threshold,2))
    hold on;
    th = 0:pi/200:2*pi;
    
     distance=[]; number_crosses=[]; 
%     for wil=1:length(radius_circle)
%         radius_circle_pixel = radius_circle(wil)*scale; %(then rescale for pixel size)
%         circle_xunit = radius_circle_pixel*cos(th)+scotch_time_position_final_new(1,1);
%         circle_yunit = radius_circle_pixel*sin(th)+scotch_time_position_final_new(1,2);
%         plot(circle_xunit,circle_yunit)
%         cross_internal_rayon = find(polar_coordinate_scotch_ref(1:time_threshold,1)<radius_circle_pixel);
%         distance_pixel_dt_subset = cumsum(sqrt(diff(position_final_new(1:time_threshold+2,1)).^2 + diff(position_final_new(1:time_threshold+2,2)).^2));
%         distance_pixel_dt_subset=distance_pixel_dt_subset(cross_internal_rayon);
%         seg = diff(cross_internal_rayon) ;
%         if length(cross_internal_rayon)>=1
%             seg_bor = [1;seg(seg~=1 & seg>15)];
%             seg_bor_idx = [1;find(seg~=1 & seg>15)];
%         else
%             seg_bor = seg(seg~=1 & seg>15);
%             seg_bor_idx = find(seg~=1 & seg>15);
%         end
%         
%         bord=[];
%         seg_bor_idx=[seg_bor_idx; length(seg)];
%         
%         if ~isempty(seg_bor)
%         bord(1,:) = [1 seg_bor_idx(2)]; 
%         if length(seg_bor_idx)>3
%         for bi=2:length(seg_bor_idx)-2
%             bord(bi,:) = [seg_bor_idx(bi)+1 seg_bor_idx(bi+1)];
%         end
%         end
%         bord(length(seg_bor_idx)-1,:)=[seg_bor_idx(length(seg_bor_idx)-1)+1 seg_bor_idx(end)+1];
%         distance(wil,1:length(seg_bor)) = distance_pixel_dt_subset(bord(:,2))-distance_pixel_dt_subset(bord(:,1));
% 
%         else
%             distance(wil,1)=NaN;
%         end
%         
%         number_crosses(wil)=length(seg_bor);
%         
%     end

    
    cross_internal_rad = find(body_polar_coordinate_center_ref(1:time_threshold,1) < threshold_internal_radius);
    seg = diff(cross_internal_rad) ;
    if length(cross_internal_rad)>=1
        seg = [1;seg(seg~=1)];
    else
        seg = seg(seg~=1);
    end
    number_crosses_30=length(seg);
    
    
    index_zone=[];
    for wo=1:length(radius_circle)
        radius_circle_pixel = radius_circle(wo)*scale; %(then rescale for pixel size)
        index_zone = find(polar_coordinate_scotch_ref(1:time_threshold,1) < radius_circle_pixel); % reference: scotch position
        time_spent_circle_scotch_zone(wo) = length(index_zone)*100./time_threshold;
        time_still_spent_circle_scotch_zone(wo) = length(find(body_instant_speed(index_zone)<speed_threshold))*100./length(body_instant_speed(index_zone));
        average_speed_circle_scotch_zone(wo) = nanmean(body_instant_speed(index_zone));
        
        %figure(); polarplot(a(index_zone),body_polar_coordinate_center_ref(index_zone,1),'o'); 
        number_crossings_scotch_30(wo) = length(find(diff(index_zone)>5)); 
        
    end
    
else
    time_near_wall_30=NaN;
    time_still_30=NaN;
    time_immobile_scotch_half_30=NaN;
    time_immobile_scotch_opposite_30=NaN;
    time_spent_scotch_opposite_30=NaN;
     time_spent_scotch_close_30=NaN;
    time_spent_scotch_half_30=NaN;
    number_crosses_30=NaN;
    time_spent_circle_scotch_zone(1:4)=[NaN,NaN,NaN,NaN];
    average_speed_circle_scotch_zone(1:4)=[NaN,NaN,NaN,NaN];
    time_still_spent_circle_scotch_zone(1:4)=[NaN,NaN,NaN,NaN];
    number_crossings_scotch_30(1:4)=[NaN,NaN,NaN,NaN];

    
end


%     % Pour 60 sec :
time_threshold=60*frame_rate;
if start_contact>60*frame_rate
    
    a=wrapToPi(body_polar_coordinate_center_ref(1:time_threshold,2)-scotch_angle(1:time_threshold));
    index_half_scotch = find(a<pi/2 & a>-pi/2);
    index_out_scotch = find(a>pi/2 | a<-pi/2);
    index_opposite_scotch = find(a>4*pi/6 | a<-4*pi/6);
    index_close_scotch = find(a<pi/6 & a>-pi/6);

    time_near_wall_60=length(find(body_polar_coordinate_center_ref(1:time_threshold,1) > threshold_external_radius))*100./time_threshold;
    time_still_60=length(find(body_instant_speed(1:time_threshold)<speed_threshold))*100./time_threshold;
    time_immobile_scotch_half_60=length(find(body_instant_speed(index_half_scotch)<speed_threshold))*100./length(index_half_scotch);
    time_immobile_scotch_opposite_60=length(find(body_instant_speed(index_out_scotch)<speed_threshold))*100./length(index_out_scotch);
    time_spent_scotch_half_60=length(index_half_scotch)*100./length(body_polar_coordinate_center_ref(1:time_threshold,2));
    time_spent_scotch_close_60=length(index_close_scotch)*100./length(body_polar_coordinate_center_ref(1:time_threshold,2));
    time_spent_scotch_opposite_60=length(index_opposite_scotch)*100./length(body_polar_coordinate_center_ref(1:time_threshold,2));
    
    cross_internal_rad = find(body_polar_coordinate_center_ref(1:time_threshold,1) < threshold_internal_radius);
    seg = diff(cross_internal_rad) ;
    if length(cross_internal_rad)>=1
        seg = [1;seg(seg~=1)];
    else
        seg = seg(seg~=1);
    end
    number_crosses_60=length(seg);
    
    %
    index_zone=[];
    for wo=1:length(radius_circle)
        radius_circle_pixel = radius_circle(wo)*scale; %(then rescale for pixel size)
        index_zone = find(polar_coordinate_scotch_ref(1:time_threshold,1) < radius_circle_pixel); % reference: scotch position
        time_spent_circle_scotch_zone_60(wo) = length(index_zone)*100./time_threshold;
        number_crossings_scotch_60(wo) = length(find(diff(index_zone)>5)); 
    end
    %
    
    
else
    time_spent_circle_scotch_zone_60(1:4)=[NaN,NaN,NaN,NaN];
    time_near_wall_60=NaN;
    time_still_60=NaN;
    time_immobile_scotch_half_60=NaN;
    time_immobile_scotch_opposite_60=NaN;
    time_spent_scotch_half_60=NaN;
    number_crosses_60=NaN;
    time_spent_scotch_close_60=NaN;
    time_spent_scotch_opposite_60=NaN;
    number_crossings_scotch_60(1:4)=[NaN,NaN,NaN,NaN];

end


time_threshold=120*frame_rate;
if start_contact>120*frame_rate
    
    a=wrapToPi(body_polar_coordinate_center_ref(1:time_threshold,2)-scotch_angle(1:time_threshold));
    index_half_scotch = find(a<pi/2 & a>-pi/2);
    index_out_scotch = find(a>pi/2 | a<-pi/2);
    
    time_near_wall_120=length(find(body_polar_coordinate_center_ref(1:time_threshold,1) > threshold_external_radius))*100./time_threshold;
    time_still_120=length(find(body_instant_speed(1:time_threshold)<speed_threshold))*100./time_threshold;
    time_immobile_scotch_half_120=length(find(body_instant_speed(index_half_scotch)<speed_threshold))*100./length(index_half_scotch);
    time_immobile_scotch_opposite_120=length(find(body_instant_speed(index_out_scotch)<speed_threshold))*100./length(index_out_scotch);
    time_spent_scotch_half_120=length(index_half_scotch)*100./length(body_polar_coordinate_center_ref(1:time_threshold,2));
    
    index_zone=[];
    for wo=1:length(radius_circle)
        radius_circle_pixel = radius_circle(wo)*scale; %(then rescale for pixel size)
        index_zone = find(polar_coordinate_scotch_ref(1:time_threshold,1) < radius_circle_pixel); % reference: scotch position
        time_spent_circle_scotch_zone_120(wo) = length(index_zone)*100./time_threshold;
        time_still_spent_circle_scotch_zone_120(wo) = length(find(body_instant_speed(index_zone)<speed_threshold))*100./length(body_instant_speed(index_zone));
        average_speed_circle_scotch_zone_120(wo) = nanmean(body_instant_speed(index_zone));
    end
    %
    
    
else
    time_near_wall_120=NaN;
    time_still_120=NaN;
    time_immobile_scotch_half_120=NaN;
    time_immobile_scotch_opposite_120=NaN;
    time_spent_scotch_half_120=NaN;
    number_crosses_120=NaN;
    time_spent_circle_scotch_zone_120(1:4)=[NaN,NaN,NaN,NaN];
    time_still_spent_circle_scotch_zone_120(1:4)=[NaN,NaN,NaN,NaN];
    average_speed_circle_scotch_zone_120(1:4)=[NaN,NaN,NaN,NaN];
end


% Previously: seuil à 60 = on essaie avec seuil à 80
body_distance_threshold=60*scale;
distance_to_scotch = sqrt((position_final_new(:,1)-scotch_time_position_final_new(:,1)).^2  + (position_final_new(:,2)-scotch_time_position_final_new(:,2)).^2);
a=-distance_to_scotch+openfield_coordinate(3)*2;

if start_contact>70
    figure();
    findpeaks(a(1:start_contact-10),'MinPeakHeight',-body_distance_threshold+openfield_coordinate(3)*2,'MinPeakProminence',60,'MinPeakDistance',min(start_contact-2,2*frame_rate));
    [ipts,locs]=findpeaks(a(1:start_contact-10),'MinPeakHeight',-body_distance_threshold+openfield_coordinate(3)*2,'MinPeakProminence',60,'MinPeakDistance',min(start_contact-2,2*frame_rate));
else
    locs=[];
end
z=1; x=1; demi_tour_centre=[]; max_speed_dt_centre=[]; max_speed_in=[]; max_speed_out=[]; mean_speed_out=[]; mean_speed_in=[]; max_mean_speed_out=[];
threshold_prominence = 0.09;
threshold_monotonicity = 0.001;

[body_angle,body_radius]=cart2pol(position_final_new(:,1)-scotch_time_position_final_new(:,1),position_final_new(:,2)-scotch_time_position_final_new(:,2));

figure()
if ~isempty(locs)
    
    if locs(end)+30 > length(body_instant_speed)
        locs = locs(1:end-1);
    end
    
    for k=1:length(locs)
        max_speed_out(k) = max(body_instant_speed(locs(k):min(locs(k)+2*frame_rate,length(body_instant_speed))));
        [~,id_max]= max(body_instant_speed(locs(k):min(locs(k)+2*frame_rate,length(body_instant_speed))));
        angle_delta = body_instant_speed(max(1,locs(k)-30):locs(k)+30);
        [TF,Pmin]=islocalmin(angle_delta);
        [TM,Pmax]=islocalmax(angle_delta);
        if length(angle_delta)==61 & (any(find(TF==1)>=27) & any(find(TF==1)<=33) & max(Pmin(27:33))>threshold_prominence) | (any(find(TM==1)>=27) & any(find(TM==1)<=33) & max(Pmax(27:33))>threshold_prominence)
            demi_tour_centre(x) = locs(k) ;
            x=x+1;
        elseif length(angle_delta)~=61
            dur1=length(angle_delta)-31;
            if (any(find(TF==1)>=dur1-2) & any(find(TF==1)<=dur1+4) & max(Pmin(dur1-2:dur1+4))>threshold_prominence) | (any(find(TM==1)>=dur1-2) & any(find(TM==1)<=dur1+4) & max(Pmax(dur1-2:dur1+4))>threshold_prominence)
                demi_tour_centre(x) = locs(k) ;
                x=x+1;
            end
        end
        
    end
    
    
    
    nbre_episodes = length(locs);
    nbre_demitours = length(demi_tour_centre);
    seuil_speed=20;
    high_speed_passages = sum(max_speed_out>seuil_speed);
    if start_contact>30*frame_rate
        nbre_episodes_30 = sum(locs<30*frame_rate);
        nbre_demitours_30 = sum(demi_tour_centre<30*frame_rate);
        max_speed_out_30 = max_speed_out(1:nbre_episodes_30);
        high_speed_passages_30=sum(max_speed_out_30>seuil_speed);
    else
        nbre_episodes_30=NaN;
        nbre_demitours_30=NaN;
        high_speed_passages_30=NaN;
    end
    if start_contact>60*frame_rate
        nbre_episodes_60 = sum(locs<60*frame_rate);
        nbre_demitours_60 = sum(demi_tour_centre<60*frame_rate);
        max_speed_out_60 = max_speed_out(1:nbre_episodes_60);
        high_speed_passages_60=sum(max_speed_out_60>seuil_speed);
    else
        nbre_episodes_60=NaN;
        nbre_demitours_60=NaN;
        high_speed_passages_60=NaN;
    end
    if start_contact>120*frame_rate
        nbre_episodes_120 = sum(locs<120*frame_rate);
        nbre_demitours_120 = sum(demi_tour_centre<120*frame_rate);
        max_speed_out_120 = max_speed_out(1:nbre_episodes_120);
        high_speed_passages_120=sum(max_speed_out_120>seuil_speed);
    else
        nbre_episodes_120=NaN;
        nbre_demitours_120=NaN;
        high_speed_passages_120=NaN;
    end
    if start_contact>180*frame_rate
        nbre_episodes_180 = sum(locs<180*frame_rate);
        nbre_demitours_180 = sum(demi_tour_centre<180*frame_rate);
        max_speed_out_180 = max_speed_out(1:nbre_episodes_180);
        high_speed_passages_180=sum(max_speed_out_180>seuil_speed);
    else
        nbre_episodes_180=NaN;
        nbre_demitours_180=NaN;
        high_speed_passages_180=NaN;
    end
    if start_contact>240*frame_rate
        nbre_episodes_240 = sum(locs<240*frame_rate);
        nbre_demitours_240 = sum(demi_tour_centre<240*frame_rate);
        max_speed_out_240 = max_speed_out(1:nbre_episodes_240);
        high_speed_passages_240=sum(max_speed_out_240>seuil_speed);
    else
        nbre_episodes_240=NaN;
        nbre_demitours_240=NaN;
        high_speed_passages_240=NaN;
    end
    if start_contact>300*frame_rate
        nbre_episodes_300 = sum(locs<300*frame_rate);
        nbre_demitours_300 = sum(demi_tour_centre<300*frame_rate);
        max_speed_out_300 = max_speed_out(1:nbre_episodes_300);
        high_speed_passages_300=sum(max_speed_out_300>seuil_speed);
    else
        nbre_episodes_300=NaN;
        nbre_demitours_300=NaN;
        high_speed_passages_300=NaN;
    end
    if start_contact>360*frame_rate
        nbre_episodes_360 = sum(locs<360*frame_rate);
        nbre_demitours_360 = sum(demi_tour_centre<360*frame_rate);
        max_speed_out_360 = max_speed_out(1:nbre_episodes_360);
        high_speed_passages_360=sum(max_speed_out_360>seuil_speed);
    else
        nbre_episodes_360=NaN;
        nbre_demitours_360=NaN;
        high_speed_passages_360=NaN;
    end
    
    
else
    nbre_episodes=NaN;
    nbre_episodes_30=NaN;
    nbre_episodes_60=NaN;
    nbre_episodes_120=NaN;
    nbre_episodes_180=NaN;
    nbre_episodes_240=NaN;
    nbre_episodes_300=NaN;
    nbre_episodes_360=NaN;
    nbre_demitours=NaN;
    nbre_demitours_30=NaN;
    nbre_demitours_60=NaN;
    nbre_demitours_120=NaN;
    nbre_demitours_180=NaN;
    nbre_demitours_240=NaN;
    nbre_demitours_300=NaN;
    nbre_demitours_360=NaN;
    high_speed_passages=NaN;
    high_speed_passages_30=NaN;
    high_speed_passages_60=NaN;
    high_speed_passages_120=NaN;
    high_speed_passages_180=NaN;
    high_speed_passages_240=NaN;
    high_speed_passages_300=NaN;
    high_speed_passages_360=NaN;
    
end



%Avoidance of scotch zone until contact
figure(); hold on;
fill(xunit,yunit,'r.-','MarkerSize',12);
fill(xunit_scotch,yunit_scotch,'w.-','MarkerSize',12);
plot(position_final_new(1:start_contact,1),position_final_new(1:start_contact,2),'-ko','MarkerSize',12,'MarkerFaceColor','k')
axis equal
axis([min(xunit)-20 max(xunit)+20 min(yunit)-20 max(yunit)+20])
h(1) = xlabel(''); h(2) = ylabel(''); set(gca, 'Xcolor', 'w', 'Ycolor', 'w')
set(h, 'Color', 'k') ; set(gca, 'XTick', []); set(gca, 'YTick', []);
F=getframe(gcf); [X,Map]=frame2im(F); B=rgb2gray(X); B=B<50;
%saveas(gcf,strcat(date,'_',mouse_name,'_',session_number,'_Area_avoidance_contact.jpg'))


figure(); hold on;
fill(xunit,yunit,'r.-','MarkerSize',12);
fill(xunit_scotch,yunit_scotch,'w.-','MarkerSize',12);
plot(position_final_new(1:start_contact,1),position_final_new(1:start_contact,2),'-go','MarkerSize',12,'MarkerFaceColor','g')
axis equal
axis([min(xunit)-20 max(xunit)+20 min(yunit)-20 max(yunit)+20])
h(1) = xlabel(''); h(2) = ylabel(''); set(gca, 'Xcolor', 'w', 'Ycolor', 'w')
set(h, 'Color', 'k') ; set(gca, 'XTick', []); set(gca, 'YTick', []);
F=getframe(gcf); [X,Map]=frame2im(F); B=rgb2gray(X);
surface_walk_total = sum(sum(B==150));


%Avoidance of scotch zone after contact (last scotch position used)
if contact_frame_end~=-1
    last_scotch_position = [scotch_time_position_final_new(find(~isnan(scotch_time_position_final_new(:,1)),1,'last'),1) scotch_time_position_final_new(find(~isnan(scotch_time_position_final_new(:,2)),1,'last'),2)];
    [body_angle,body_radius]=cart2pol(position_final_new(:,1)-last_scotch_position(1,1),position_final_new(:,2)-last_scotch_position(1,2));
    radius_circle = 80;% in mm  (a bit less than 1/3 de l'arène)
    radius_circle_pixel = radius_circle*scale; %(then rescale for pixel size)
    last_frame = length(body_instant_speed);
    index_zone = find(body_radius(end_contact:min(end_contact+60*frame_rate,last_frame)) < radius_circle_pixel); % reference: scotch position
    post_1min_time_spent_circle_scotch_zone =  length(index_zone)*100./length(body_radius(end_contact:min(end_contact+60*frame_rate,last_frame)));
else
    post_1min_time_spent_circle_scotch_zone=NaN;
end



%% Final output:
table=[mean_speed_body_entrance' distance_before_contact' proportion_time_still_before_contact' proportion_time_wall_before_contact' number_center_cross_before_contact' time_spent_scotch_half' time_spent_immobile_scotch_half' time_spent_immobile_out_scotch' unique_pos' nbre_episodes' nbre_demitours' high_speed_passages' time_spent_scotch_close' time_spent_scotch_opposite'];
table_bis=[mean_speed_body_precontact' speed_contact'];
table_tri=[distance_during_contact' max_speed_contact' mean_speed_contact' immobility_contact'];
table_quatre=[max_speed_post_contact' proportion_wall_post_1min_contact' immobility_post_1min_contact' post_1min_time_spent_circle_scotch_zone'];

passages_linearity=[nbre_episodes_30' nbre_episodes_60' nbre_episodes_120' nbre_episodes_180'  nbre_episodes_240' nbre_episodes_300' nbre_episodes_360' nbre_demitours_30' nbre_demitours_60' nbre_demitours_120' nbre_demitours_180' nbre_demitours_240' nbre_demitours_300' nbre_demitours_360' high_speed_passages_30' high_speed_passages_60' high_speed_passages_120' high_speed_passages_180' high_speed_passages_240' high_speed_passages_300' high_speed_passages_360'];
time_zone = [time_spent_circle_scotch_zone_full time_spent_circle_scotch_zone time_still_spent_circle_scotch_zone average_speed_circle_scotch_zone time_spent_circle_scotch_zone_120 time_still_spent_circle_scotch_zone_120 average_speed_circle_scotch_zone_120 time_spent_circle_scotch_zone_60];

table_30=[time_still_30' time_near_wall_30' number_crosses_30' time_spent_scotch_half_30'  time_immobile_scotch_half_30' time_immobile_scotch_opposite_30' nbre_episodes_30' nbre_demitours_30' high_speed_passages_30'];
table_60=[time_still_60' time_near_wall_60' number_crosses_60' time_spent_scotch_half_60' time_immobile_scotch_half_60' time_immobile_scotch_opposite_60' nbre_episodes_60' nbre_demitours_60' high_speed_passages_60'];
table_250 = [time_still_250' time_near_wall_250' number_crosses_250' time_spent_scotch_half_250' time_immobile_scotch_half_250' time_immobile_scotch_opposite_250'];
avoidance_params=[surface_walk_total' surface_walk_250'];

time_precision=[time_spent_scotch_close_250 time_spent_scotch_close_30 time_spent_scotch_close_60 time_spent_scotch_opposite_250 time_spent_scotch_opposite_30 time_spent_scotch_opposite_60 number_crossings_scotch_30 number_crossings_scotch_60];
    
close all

end


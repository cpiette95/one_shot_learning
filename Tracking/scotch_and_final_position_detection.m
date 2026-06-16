function scotch_and_final_position_detection(full_name,init_frame,crop)
    %function scotch_and_final_position_detection(mouse_name,date,session_number,init_frame,crop)
load(strcat(full_name,'_data_analysis.mat'))
load(strcat(full_name,'_scotch_analysis.mat'));
videoObj = VideoReader(strcat(full_name,'.mp4'));

%videoObj = VideoReader(strcat(date,'_',mouse_name,'_',session_number,'.mp4'));
%load(strcat(date,'_',mouse_name,'_',session_number,'_data_analysis.mat'));
%load(strcat(date,'_',mouse_name,'_',session_number,'_scotch_analysis.mat'));

crop_start=0;
position_final_new=position_final(crop_start+2:end,:);
position_final_new = [sgolayfilt(position_final_new(:,1),3,21) sgolayfilt(position_final_new(:,2),3,21)];
snout_data_new=[];

try
    fileID = fopen(strcat(date,'_',mouse_name,'_',session_number,'.csv'),'r');
    data_array = textscan(fileID, '%f%f%f%f%f%f%f%f%f%f%[^\n\r]', 'Delimiter', ',', 'EmptyValue' ,NaN,'HeaderLines' ,3, 'ReturnOnError', false);
    fclose(fileID);
    
    diverg=diff(position_final);
    %     diverg_points=find(abs(diverg(:,1))>200 | abs(diverg(:,2))>200)
    %     if ~isempty(diverg_points)
    %         lims=diff(diverg_points);
    %
    %         if diverg_points(1) <50
    %             diverg_points_new = diverg_points(find(lims>30)+1)
    %             crop_start = diverg_points(1);
    %         else
    %             diverg_points_new = [diverg_points(1); diverg_points(find(lims>30)+1)]
    %         end
    %
    %         while ~isempty(diverg_points_new);
    %             for k=1:length(diverg_points_new)
    %                 position_final(diverg_points_new(k)+1,1)=position_final(diverg_points_new(k),1);
    %                 position_final(diverg_points_new(k)+1,2)=position_final(diverg_points_new(k),2);
    %             end
    %             diverg=diff(position_final);
    %             diverg_points=find(abs(diverg(:,1))>200 | abs(diverg(:,2))>200);
    %             diverg_points = diverg_points(diverg_points>crop_start);
    %             lims=diff(diverg_points);
    %             if ~isempty(lims)
    %                 diverg_points_new = [diverg_points(1) ;diverg_points(find(lims>30)+1)]
    %             else
    %                 diverg_points_new=[];
    %             end
    %         end
    %     end
    
    
    %     % Snout data
    snout_data = [data_array{1,2}(init_frame:size(scotching_episode,1)+init_frame-1) data_array{1,3}(init_frame:size(scotching_episode,1)+init_frame-1) data_array{1,4}(init_frame:size(scotching_episode,1)+init_frame-1)];
    snout_data(:,1) = snout_data(:,1)-crop(3); % translate due to cropping
    snout_data(:,2) = snout_data(:,2)-crop(1);
    
    for k=2:size(snout_data,1)-1
        if (abs(snout_data(k+1,1)-snout_data(k,1)) > 200)  | (abs(snout_data(k+1,2)-snout_data(k,2)) > 200)
            snout_data(k+1,1)=snout_data(k,1);
            snout_data(k+1,2)=snout_data(k,2);
            disp(k);
        end
    end
    
    snout_data_new = [sgolayfilt(snout_data(crop_start+2:end,1),3,21) sgolayfilt(snout_data(crop_start+2:end,2),3,21)];
    
    figure();
    plot(snout_data_new(:,1),snout_data_new(:,2))
end

% New more precise detection of scotch position
scotch_pos=unique(scotch_time_position_final(:,1),'stable'); scotch_pos =scotch_pos(~isnan(scotch_pos));


centers_scotch=[]; diameters_scotch=[];

for k=1:length(scotch_pos)
    
    index_scotch=find(scotch_time_position_final(:,1)==scotch_pos(k),1,'first');
    vidFrame = read(videoObj,init_frame+index_scotch-1);
    
    vidFrame = read(videoObj,init_frame+index_scotch+105);
    
    
   good_threshold=0;
    method_good=1;
    
    while good_threshold==0
        %diff_im = rgb2hsv(vidFrame);
        diff_im = vidFrame;
        diff_imbis = diff_im(:,:,1);
        figure(); imagesc(diff_imbis); colorbar ;
        scotch_threshold = input('threshold_detection?');
        %diff_imbis =
        %diff_imbis(crop(1):crop(2),crop(3):crop(4))>scotch_threshold; to
        %be updated when rgb2hsv is used
        diff_imbis = diff_imbis(crop(1):crop(2),crop(3):crop(4))<scotch_threshold;
        figure(); imagesc(diff_imbis); colorbar
        good_threshold = input('threshold ok?');
%         if good_threshold==0
%             method_good = input('good method?');
%         end
        close()
        if method_good==0
            diff_imbis = vidFrame(:,:,1);
            figure(); imagesc(diff_imbis); colorbar
            scotch_threshold = 160; %input('threshold_detection?');
            diff_imbis = diff_imbis(crop(1):crop(2),crop(3):crop(4))<scotch_threshold;
            figure(); imagesc(diff_imbis)
            good_threshold = 1; %input('threshold ok?');
            close()
        end
    end
    
    diff_init = diff_imbis;
    figure(); imagesc(diff_init);
    stats = regionprops(diff_init, 'BoundingBox', 'Centroid','Extrema','MajorAxisLength','MinorAxisLength');
    a={stats(:).Centroid};
    stats_centroid=reshape(cell2mat(a'),[size(stats,1),2]);
    [~,id]=min((stats_centroid(:,1)-scotch_time_position_final(index_scotch,1)).^2 + (stats_centroid(:,2)-scotch_time_position_final(index_scotch,2)).^2);
    
    hold on; plot(stats_centroid(id,1),stats_centroid(id,2),'rx');
    hold on; plot(scotch_time_position_final(index_scotch,1),scotch_time_position_final(index_scotch,2),'gx');
    
    centers_scotch(k,:)=stats(id).Centroid;
    diameters_scotch(k) = mean([stats(id).MajorAxisLength stats(id).MinorAxisLength],2);
    viscircles(centers_scotch,diameters_scotch/2);
    r=find(scotch_time_position_final(:,1)==scotch_time_position_final(index_scotch,1));
    
    scotch_time_position_final(r,1:2) = repmat([stats_centroid(id,1) stats_centroid(id,2)],[length(r),1]);
    %scotch_time_position_final(r,1:2) = repmat([scotch_time_position_final(index_scotch,1)+35,scotch_time_position_final(index_scotch,2)-35],[length(r),1]);

    pause(5)
    close()
    
end

%cd('/Volumes/SAUVEGARDE/THESE/REVISIONS_2025/Jeremy_exps_CB1_D2')
%save(strcat(date,'_',mouse_name,'_',session_number,'_scotch_detection_final.mat'),'scotch_time_position_final','centers_scotch','diameters_scotch');
%save(strcat(date,'_',mouse_name,'_',session_number,'_position_final.mat'),'snout_data_new', 'position_final_new');
save(strcat(full_name,'_scotch_detection_final.mat'),'scotch_time_position_final','centers_scotch','diameters_scotch');
save(strcat(full_name,'_position_final.mat'),'snout_data_new', 'position_final_new');


end

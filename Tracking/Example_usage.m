% Example usage for tracking mice trajectory 
addpath('/Users/charlotte.piette/Desktop/ARTICLE_ONE_SHOT/Analyse_Trajectoire/Fonctions')

cd('/Users/charlotte.piette/Desktop/ARTICLE_ONE_SHOT/Opto_KO/New_videos/Analyse')
Mice_table{1,1} = {'DFK-33UX290-1_V9662_S1_0023.mp4',50,[50,1000,300,1300],250,[500,480,375],1,1810,NaN;'DFK-33UX290-1_V9662_S2_0032.mp4',50,[50,1000,300,1300],250,[500,480,375],1,13760,NaN;'DFK-33UX290-1_V9662_S3_0041.mp4',50,[50,1000,300,1300],200,[510,490,375],1,NaN,NaN}; %S1:1-480 puis 516-1810; S2:1-8930 puis 12575-13760; S3:no contact
Mice_table{1,2} = {'DFK-33UX290-1_V9636_S1_0021.mp4',50,[50,1000,300,1300],230,[510,490,375],1,14680,NaN;'DFK-33UX290-1_V9636_S2_0030.mp4',50,[50,1000,300,1300],400,[510,480,375],1,12975,NaN;'DFK-33UX290-1_V9636_S3_0039.mp4',50,[50,1000,300,1300],200,[510,490,375],1,NaN,NaN}; %S1:1-4075 puis 13700-14680; S2:1-12975  ; S3:NaN
Mice_table{1,3} = {'DFK-33UX290-1_V9701_S1_0027.mp4',50,[50,1000,500,1500],245,[450,480,375],1,1500,NaN;'DFK-33UX290-1_V9701_S2_0036.mp4',50,[50,1000,500,1500],220,[450,480,375],1,NaN,NaN;'DFK-33UX290-1_V9701_S3_0009.mp4',50,[50,1000,500,1500],220,[450,480,375],1,8470,NaN}; %S1:1-381 puis 440-1500; S2:no contact  ; S3:1-6408 puis 7260-8470
Mice_table{1,4} = {'DFK-33UX290-1_V9718_S1_0022.mp4',50,[50,1000,500,1600],260,[450,470,375],1,1970,NaN;'DFK-33UX290-1_V9718_S2_0031.mp4',50,[50,1000,500,1500],205,[440,460,375],1,NaN,NaN;'DFK-33UX290-1_V9718_S3_0004.mp4',50,[50,1000,500,1500],210,[450,460,375],1,14565,NaN}; %S1:1-559 puis 965-1970; S2: no contact; S3:1-14565
Mice_table{1,5} = {'DFK-33UX290-1_V9715_S1_0018.mp4',50,[50,1000,500,1500],265,[450,460,375],1,4570,NaN;'DFK-33UX290-1_V9715_S2_0028.mp4',50,[50,1000,500,1500],225,[450,460,375],1,1930,NaN;'DFK-33UX290-1_V9715_S3_0004.mp4',50,[50,1000,500,1500],310,[450,460,375],1,NaN,NaN}; %S1:1-815 puis 2940-4570; S2: 1-612 puis 1353-1930; S3:no contact
Mice_table{1,6} = {'DFK-33UX290-1_V9710_S1_0023.mp4',50,[50,1000,500,1500],260,[450,460,375],1,2740,NaN;'DFK-33UX290-1_V9710_S2_0032.mp4',50,[50,1000,500,1500],280,[450,470,375],1,4930,NaN;'DFK-33UX290-1_V9710_S3_0005.mp4',50,[50,1000,500,1500],215,[450,460,375],1,NaN,NaN}; %S1:1-1995 puis 2175-2740; S2:1-3925 puis 4420-4930; S3: no contact
Mice_table{1,7} = {'DFK-33UX290-1_V9713_S1_0025.mp4',50,[50,1000,500,1500],205,[450,470,375],1,2880,NaN;'DFK-33UX290-1_V9713_S2_0034.mp4',50,[50,1000,500,1500],265,[450,460,375],1,11245,NaN;'DFK-33UX290-1_V9713_S3_0007.mp4',50,[50,1000,500,1500],235,[450,460,375],1,NaN,NaN}; %S1:1-796 puis 1854-2880; S2:1-9030 puis 10080-11245; S3:no contact
Mice_table{1,8} = {'DFK-33UX290-1_V9717_S1_0021.mp4',50,[50,1000,500,1500],230,[440,480,375],1,3140,NaN;'DFK-33UX290-1_V9717_S2_0030.mp4',50,[50,1000,500,1500],325,[450,460,375],1,NaN,NaN;'DFK-33UX290-1_V9717_S3_0003.mp4',50,[50,1000,500,1500],250,[440,450,375],1,NaN,NaN}; %S1:1-1515 puis 2505-3140; S2:no contact; S3:no contact

%Fam: 
contact_frames=[483	515; 4070	13700; 383	435 ; 559	952; 815	2940 ; 2000	2170; 789	1854; 1510	2510]; 
%R1: 
%contact_frames =[8930	12548; 12975	-1; -1 -1; -1	-1; 612	1350; 3916	4410; 9030	10060; -1 -1]; 

% Select mouse recording: 
index=1 ; % looking at mouse 1 
recording=2; % considering Fam data here for instance

% Initial extraction of position 
videoObj = VideoReader(char(Mice_table{1,index}{recording,1}));
threshold = Mice_table{1,index}{recording,2}; 
crop = Mice_table{1,index}{recording,3}; 
number_frames = round(videoObj.Duration*videoObj.FrameRate); 
vidFrame = read(videoObj,3300);
figure(2); imagesc(vidFrame(crop(1):crop(2),crop(3):crop(4),2)); hold on; 
th = 0:pi/50:2*pi;
xunit = Mice_table{1,index}{recording,5}(3) * cos(th) + Mice_table{1,index}{recording,5}(1);
yunit =Mice_table{1,index}{recording,5}(3) * sin(th) + Mice_table{1,index}{recording,5}(2);
xunit_inner = (Mice_table{1,index}{recording,5}(3)/2) * cos(th) + Mice_table{1,index}{recording,5}(1);
yunit_inner = (Mice_table{1,index}{recording,5}(3)/2) * sin(th) + Mice_table{1,index}{recording,5}(2);
hold on; plot(xunit, yunit);
plot(xunit_inner, yunit_inner);


% function to save position and scotch trajectory
mice_tracking(char(Mice_table{1,index}{recording,1}),Mice_table{1,index}{recording,2},Mice_table{1,index}{recording,3},Mice_table{1,index}{recording,4},Mice_table{1,index}{recording,5},Mice_table{1,index}{recording,6},Mice_table{1,index}{recording,7},Mice_table{1,index}{recording,8})


% re-analyze scotch position + smoothing of trajectory: 
name=strfind(Mice_table{1,index}(1),'_');
mouse_name=Mice_table{1,index}{1}(name{1,1}(1)+1:name{1,1}(2)-1);
date=Mice_table{1,M}{recording}(1:8);
session_number=Mice_table{1,M}{recording}(end-5:end-4);
init_frame=Mice_table{1,M}{recording,4};
crop=Mice_table{1,M}{recording,3};

scotch_and_final_position_detection(mouse_name,date,session_number,init_frame,crop)


% Basic locomotion params analysis (across all recordings)
[table_basic_params]=basic_params_extraction(Mice_table,index,mouse_name);

% More specific analysis (for either fam or retrieval)
contact_frame_start= contact_frames(index,1);
contact_frame_end = contact_frames(index,2);
[table,table_bis,table_tri,table_quatre,passages_linearity,time_zone,table_30,table_60,table_250,avoidance_params] = common_analysis_full(mouse_name,date,session_number,init_frame,crop,contact_frame_start,contact_frame_end);

 

    
    
    


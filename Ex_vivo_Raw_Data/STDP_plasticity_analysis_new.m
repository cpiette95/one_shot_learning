%clear
set(0,'DefaultFigureWindowStyle','docked')

cd('/Users/charlotte.piette/Dropbox/ARTICLE_ONE_SHOT/Revisions_Patch/Patch/charlotte_2025/20250219')
addpath('/Users/charlotte.piette/Dropbox/ARTICLE_ONE_SHOT/Revisions_Patch/Excel_sheets')
% 
inputs_plasticity = {};
inputs_plasticity(1,:) = {'Name of the recording','Number of days', 'Best Performance', 'Baseline protocol number', 'Paired_pulse or not', 'Sweep to avoid baseline','Pairing protocol','Post-pairing baseline number','Paired pulse or not', 'Sweep to avoid during post-baseline','Cursor PSP peak start','Cursor PSP peak end','Cursor PSP max start','Cursor PSP max end'};
inputs_plasticity(2,1:3) = {'20250219_03',3,1};
inputs_plasticity(2,4:6) = {119,0,1:35};
inputs_plasticity(2,7) = {128};
inputs_plasticity(2,8:10) = {129,0,NaN};
inputs_plasticity(3,8:10) = {130,0,NaN};
inputs_plasticity(4,8:10) = {131,0,NaN};
inputs_plasticity(5,8:10) = {132,0,NaN};
inputs_plasticity(6,8:10) = {133,0,NaN};
inputs_plasticity(7,8:10) = {134,0,NaN};
inputs_plasticity(8,8:10) = {135,0,NaN};
inputs_plasticity(9,8:10) = {136,0,NaN};
inputs_plasticity(10,8:10) = {137,0,NaN};
inputs_plasticity(11,8:10) = {138,0,NaN};
inputs_plasticity(12,8:10) = {139,0,NaN};
inputs_plasticity(13,8:10) = {140,0,NaN};
inputs_plasticity(14,8:10) = {141,0,NaN};
inputs_plasticity(15,8:10) = {142,0,NaN};
inputs_plasticity(16,8:10) = {143,0,NaN};
inputs_plasticity(17,8:10) = {144,0,NaN};
inputs_plasticity(18,8:10) = {145,0,NaN};
inputs_plasticity(2,11:14) = {0.202,0.215,0.2020,0.2020}; %0.203
 
data_file = inputs_plasticity{2,1}; 
interesting_protocols = [inputs_plasticity{2,4},inputs_plasticity{2,7}, inputs_plasticity{2,8} inputs_plasticity{3,8},inputs_plasticity{4,8},inputs_plasticity{5,8},inputs_plasticity{6,8},inputs_plasticity{7,8},inputs_plasticity{8,8},inputs_plasticity{9,8},inputs_plasticity{10,8},inputs_plasticity{11,8},inputs_plasticity{12,8},inputs_plasticity{13,8},inputs_plasticity{14,8} inputs_plasticity{15,8} inputs_plasticity{16,8} inputs_plasticity{17,8} inputs_plasticity{18,8}]; % inputs_plasticity{19,8} inputs_plasticity{20,8} inputs_plasticity{21,8} inputs_plasticity{22,8} inputs_plasticity{23,8} inputs_plasticity{24,8} inputs_plasticity{25,8} inputs_plasticity{26,8} inputs_plasticity{27,8} inputs_plasticity{28,8} inputs_plasticity{29,8} inputs_plasticity{30,8} inputs_plasticity{31,8} inputs_plasticity{32,8} inputs_plasticity{33,8} inputs_plasticity{34,8}]; 
splitmat_check_new(inputs_plasticity{2,1}(1:8),interesting_protocols,inputs_plasticity{2,1}(10:11))%
% 

results_plasticity = {}; 
results_plasticity(1,:) = {'Name of the recording','Number of training sessions', 'Best Performance', 'Amplitude PSP baseline', 'Rising time PSP baseline', 'Area PSP baseline','Current deflection baseline', 'Holding current baseline','Series resistance baseline','Amplitude PSP post', 'Rising time PSP post', 'Area PSP post','Current deflection post', 'Holding current post','AP post','Series resistance post'};  
results_plasticity(2,1:3) = inputs_plasticity(2,1:3); 


New_results_plasticity = {}; 
New_results_plasticity(1,:) = {'Name of the recording','Number of training sessions', 'Best Performance', 'Amplitude PSP baseline', 'Rising time PSP baseline', 'Area half PSP baseline','Area PSP baseline','Current deflection for Rinput baseline', 'Holding current baseline', 'Current deflection for Rseries','Latency baseline','Half duration baseline','Spontaneous event amplitude','Spontaneoues event frequency','Amplitude PSP post', 'Rising time PSP post', 'Area half PSP post','Area PSP post','Current deflection for Rinput post', 'Holding current post','Current deflection for Rseries','Latency post','Half duration post','Spontaneous amplitude post','Spontaneous frequency post'};  
New_results_plasticity(2,1:3) = inputs_plasticity(2,1:3); 

VC=1; 

check_data =0; 


% if =1 : no analysis, just checking if there is a good response or not 
% if =0 : only analysis (no plot)
% if =2 : analysis + plot of the EPSP analysis

% % % Extracting recording properties of pairing protocol    
% %cd(strcat('/Volumes/LaCie/DOSSIER THESE/DATA_THESE/STICKY_OCCLUSION/RAW_DATA/Charlotte/',inputs_plasticity{2,1}(1:8)));
% clearvars data myStruc
load(strcat(inputs_plasticity{2,1},'_',num2str(inputs_plasticity{2,7}),'.mat'));    
names = fieldnames(myStruc) ;
% pairings = length(names); %/2; 
% duration_depol = 0.030; 
% start_depol = 0.400; %0.400; %Sylvie:0.4; CP:0.1
% threshold_spike = 0;
% threshold_spike_real=0;
% fs = 10000;
% positiv_stim =0;
% m=1;
% post_spike = []; last_spike_time=[];
% number_pre_spikes = [];
% stim_time = [];
% for k=1:15%pairings
%     pairing_response = getfield(myStruc,names{m})*1000;
%     %pairing_stimulation = getfield(myStruc,names{m+1});
%     %pause(0.4)
%     %findpeaks(pairing_response(:,2),'Threshold',threshold_spike,'MinPeakProminence',4);
%     holding_voltage(k) = mean(pairing_response(1:start_depol*fs,2));
%     [ipts,locs]=findpeaks(pairing_response(:,2),'Threshold',threshold_spike,'MinPeakProminence',4);
%     locs_spikes = locs(ipts>threshold_spike_real) ;
%     number_pre_spikes(k) = length(find(locs_spikes<(start_depol+duration_depol)*fs));
%     if number_pre_spikes(k)~=0
%         last_spike_time(k) = max(locs_spikes(find(locs_spikes<=(start_depol+duration_depol+0.001)*fs)))/fs;
%         figure(1); hold on; plot(pairing_response(:,1),pairing_response(:,2)); title(num2str(k))
%         plot(max(locs_spikes(find(locs_spikes<=(start_depol+duration_depol+0.001)*fs)))/10,0,'rx'); pause(0.5)
%         close all
%         ylim([-80 50])
%         %xlim([1 400])
% 
%     else
%         last_spike_time(k) = NaN;
%     end
% 
% 
%     if positiv_stim==0
%         [i,locs_max]=min(pairing_response(:,2));
%         stim_time(k) = locs_max/fs;
%     else
%         %[i,locs_max]=max(pairing_response(1300:1700,2));
%         [i,locs_max]=max(pairing_response(4449:4455,2));
%         stim_time(k) = (locs_max+4449)/fs;
%     end
% 
% %     post_idx = find(locs>(start_depol+duration_depol)*fs);
% %     if positiv_stim ==0
% %         if isempty(post_idx)==0
% %             for t=1:length(post_idx)
% %                 if max(diff(pairing_response(locs(post_idx(t))-2:locs(post_idx(t))+2,2)))>10
% %                     stim_time(k) = locs(post_idx(t))/fs;
% %                     post_stim_response(k) = locs(post_idx(t)+1)/fs;
% %                     if max(pairing_response(locs(post_idx(t)+1),2))>threshold_spike
% %                         post_spike(k) = 1;
% %                     else
% %                         post_spike(k) = 0;
% %                     end
% %                     break
% %                 end
% %             end
% %         end
% %     elseif positiv_stim==0
% %         [~,pos]=min(pairing_response(:,2));
% %         stim_time(k) = pos/fs;
% %         [~,locs_post] = max(pairing_response(pos+40:pos+200,2));
% %         %locs_post = locs(locs>pos+5);
% %         post_stim_response(k) = (locs_post+pos+39)/fs;
% %         if max(pairing_response(locs_post+pos+39,2))>threshold_spike
% %             post_spike(k) = 1;
% %         else
% %             post_spike(k) = 0;
% %         end
% %     end
%     m=m+1; %2;
% end
% 
% %latency = post_stim_response - last_spike_time ;
% latency = (stim_time - last_spike_time)*1000 ;
% mean_latency = nanmean(latency)
% std_latency = nanstd(latency)
% vhold = mean(holding_voltage)

%
% % % % %for plotting later:
pairing_response = getfield(myStruc,names{5});
pairing_stimulation = getfield(myStruc,names{6});
% % % % 
% % 

for k=1:sum(~cellfun(@isempty,inputs_plasticity(:,4)))-1
    recording_baseline = inputs_plasticity{k+1,4};
    PP_positive_baseline = inputs_plasticity{k+1,5};
    sweep_to_avoid_baseline = inputs_plasticity{k+1,6};
    
    if VC==1
        [amplitude_PSP_baseline,rise_time_PSP_baseline,area_PSP_baseline,area_PSP_half_baseline,latency_baseline,half_width_duration_baseline,current_deflection_baseline,holding_current_baseline,AP_index_baseline,series_resistance_baseline,spontaneous_amplitude,spontaneous_frequency]=myplasticity_analysis_in_vitro('baseline',inputs_plasticity,recording_baseline,sweep_to_avoid_baseline,check_data,PP_positive_baseline);    
    else
        [amplitude_PSP_baseline,rise_time_PSP_baseline,area_PSP_baseline,area_PSP_half_baseline,latency_baseline,half_width_duration_baseline,current_deflection_baseline,holding_current_baseline,AP_index_baseline,series_resistance_baseline]=myplasticity_analysis_CC_new('baseline',inputs_plasticity,recording_baseline,sweep_to_avoid_baseline,check_data,PP_positive_baseline);    
    end
    results_plasticity{k+1,4} = amplitude_PSP_baseline;
    results_plasticity{k+1,5} = rise_time_PSP_baseline;
    results_plasticity{k+1,6} =  area_PSP_half_baseline; 
    results_plasticity{k+1,7} = area_PSP_baseline;  
    results_plasticity{k+1,8} = current_deflection_baseline*1000;
    results_plasticity{k+1,9} = holding_current_baseline;
    results_plasticity{k+1,10} = series_resistance_baseline*1000;
    results_plasticity{k+1,11} = latency_baseline;
    results_plasticity{k+1,12} = half_width_duration_baseline;
    results_plasticity{k+1,13} = spontaneous_amplitude;
    results_plasticity{k+1,14} = spontaneous_frequency';
    
end

New_results_plasticity{2,4} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,4))),4});
New_results_plasticity{2,5} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,4))),5});
New_results_plasticity{2,6} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,4))),6});
New_results_plasticity{2,7} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,4))),7});
New_results_plasticity{2,8} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,4))),8});
New_results_plasticity{2,9} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,4))),9});
New_results_plasticity{2,10} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,4))),10});
New_results_plasticity{2,11} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,4))),11});
New_results_plasticity{2,12} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,4))),12});
New_results_plasticity{2,13} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,4))),13});
New_results_plasticity{2,14} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,4))),14});


for k=1:sum(~cellfun(@isempty,inputs_plasticity(:,8)))-1
    recording_post = inputs_plasticity{k+1,8};
    PP_positive_post = inputs_plasticity{k+1,9};
    sweep_to_avoid_post = inputs_plasticity{k+1,10};
    
    if VC==1
        [amplitude_PSP_post,rise_time_PSP_post,area_PSP_post,area_PSP_half_post,latency_post,halfwidth_duration_post,current_deflection_post,holding_current_post,AP_index_post,series_resistance_post,spontaneous_amplitude_post,spontaneous_frequency_post]=myplasticity_analysis_in_vitro('post',inputs_plasticity,recording_post,sweep_to_avoid_post,check_data,PP_positive_post);
    else
        [amplitude_PSP_post,rise_time_PSP_post,area_PSP_post,area_PSP_half_post,latency_post,halfwidth_duration_post,current_deflection_post,holding_current_post,AP_index_post,series_resistance_post]=myplasticity_analysis_CC_new('post',inputs_plasticity,recording_post,sweep_to_avoid_post,check_data,PP_positive_post);
    end 
    results_plasticity{k+1,15} = amplitude_PSP_post; 
    results_plasticity{k+1,16} = rise_time_PSP_post; 
    results_plasticity{k+1,17} =  area_PSP_half_post;
    results_plasticity{k+1,18} = area_PSP_post;  
    results_plasticity{k+1,19} = current_deflection_post*1000; % passage en Mohm
    results_plasticity{k+1,20} = holding_current_post;
    results_plasticity{k+1,21} = series_resistance_post*1000;
    results_plasticity{k+1,22} = AP_index_post;
    results_plasticity{k+1,23} = latency_post;
    results_plasticity{k+1,24} = halfwidth_duration_post;
    results_plasticity{k+1,25} = spontaneous_amplitude_post;
    results_plasticity{k+1,26} = spontaneous_frequency_post';

          
    
end

New_results_plasticity{2,15} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,15))),15});
New_results_plasticity{2,16} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,15))),16});
New_results_plasticity{2,17} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,15))),17});
New_results_plasticity{2,18} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,15))),18});
New_results_plasticity{2,19} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,15))),19});
New_results_plasticity{2,20} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,15))),20});
New_results_plasticity{2,21} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,15))),21});
New_results_plasticity{2,22} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,15))),22});
New_results_plasticity{2,23} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,15))),23});
New_results_plasticity{2,24} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,15))),24});
New_results_plasticity{2,25} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,15))),25});
New_results_plasticity{2,26} = horzcat(results_plasticity{2:sum(~cellfun(@isempty,results_plasticity(:,15))),26});


%% Raw data


%if sum(~cellfun(@isempty,inputs_plasticity(:,4)))==2
add_factor=0; 
%else 
%    add_factor=1; 
%end

first_index_baseline=find(~isnan(New_results_plasticity{2,4}),1);
last_index_baseline=length(New_results_plasticity{2,4});

figure()
%suptitle([strcat('STDP results for cell = ',inputs_plasticity(2,1))])
% Distribution of EPSP during baseline: 
mean_baseline_amp = nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,4})); 
subplot(4,2,1) ; hold on; 
plot(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,4}),'o')
plot([first_index_baseline last_index_baseline],[mean_baseline_amp mean_baseline_amp],'k','LineWidth',1.5);
%if max(AP_index_baseline)==1
%    plot(mean_baseline_amp*AP_index_baseline,'r*')
%end
ylabel('PSP amplitude (pA)')
title('Baseline')
subplot(4,2,3); hold on; 
mean_baseline_current_deflec = nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,8}));
plot(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,8}),'o','color',[0.2 0.6 0.2])
upper_limit = mean_baseline_current_deflec + 0.20*mean_baseline_current_deflec; 
bottom_limit = mean_baseline_current_deflec - 0.20*mean_baseline_current_deflec;
plot([first_index_baseline last_index_baseline],[upper_limit upper_limit],'color',[1 0.8 0.2],'LineWidth',1.5);
plot([first_index_baseline last_index_baseline],[nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,8})) nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,8}))],'k','LineWidth',1.5);
plot([first_index_baseline last_index_baseline],[bottom_limit bottom_limit],'color',[1 0.8 0.2],'LineWidth',1.5);
ylabel('Input resistance (Mohm)')
subplot(4,2,5); hold on; 
mean_baseline_current_series_deflec = nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,10}));
upper_series_limit = mean_baseline_current_series_deflec + 0.20*mean_baseline_current_series_deflec; 
bottom_series_limit = mean_baseline_current_series_deflec - 0.20*mean_baseline_current_series_deflec;
plot(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,10}),'o','color',[0.2 0.6 0.2])
plot([first_index_baseline last_index_baseline],[nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,10})) nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,10}))],'k','LineWidth',1.5);
plot([first_index_baseline last_index_baseline],[upper_series_limit upper_series_limit],'color',[1 0.8 0.2],'LineWidth',1.5);
plot([first_index_baseline last_index_baseline],[bottom_series_limit bottom_series_limit],'color',[1 0.8 0.2],'LineWidth',1.5);
xlabel('Sweep number')
ylabel('Series resistance (Mohm)')
subplot(4,2,7); hold on; 
plot(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,9}),'o','color',[1 0.4 0.6])
plot([first_index_baseline last_index_baseline],[nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,9})) nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,9}))],'k','LineWidth',1.5);
xlabel('Sweep number')
ylabel('Holding current (pA)')

subplot(4,2,2); hold on; 
plot(New_results_plasticity{2,15},'o')
plot([1 length(New_results_plasticity{2,15})],[mean_baseline_amp mean_baseline_amp],'k','LineWidth',1.5);
if max(New_results_plasticity{2,22})==1
    plot(mean_baseline_amp*New_results_plasticity{2,22},'r*')
end
ylabel('PSP amplitude (pA)')
title('Post protocol')
subplot(4,2,4); hold on; 
plot(New_results_plasticity{2,19},'o','color',[0.2 0.6 0.2])
plot([1 length(New_results_plasticity{2,19})],[mean_baseline_current_deflec mean_baseline_current_deflec],'k','LineWidth',1.5);
plot([1 length(New_results_plasticity{2,19})],[upper_limit upper_limit],'color',[1 0.8 0.2],'LineWidth',1.5);
plot([1 length(New_results_plasticity{2,19})],[bottom_limit bottom_limit],'color',[1 0.8 0.2],'LineWidth',1.5);
ylabel('Input resistance (Mohm)')
subplot(4,2,6); hold on; 
plot(New_results_plasticity{2,21},'o','color',[0.2 0.6 0.2])
plot([1 length(New_results_plasticity{2,21})],[mean_baseline_current_series_deflec mean_baseline_current_series_deflec],'k','LineWidth',1.5);
plot([1 length(New_results_plasticity{2,21})],[upper_series_limit upper_series_limit],'color',[1 0.8 0.2],'LineWidth',1.5);
plot([1 length(New_results_plasticity{2,21})],[bottom_series_limit bottom_series_limit],'color',[1 0.8 0.2],'LineWidth',1.5);
ylabel('Series resistance (Mohm)')
subplot(4,2,8); hold on; 
plot(New_results_plasticity{2,20},'o','color',[1 0.4 0.6])
plot([1 length(New_results_plasticity{2,20})],[nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,9})) nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4)))+add_factor,9}))],'k','LineWidth',1.5);
xlabel('Sweep number')
ylabel('Holding current (pA)')
% 
% 
figure()
subplot(4,3,[1:3]); hold on;
plot(pairing_response(1000:3000,1),pairing_response(1000:3000,2)*1e3)
plot(pairing_stimulation(1000:3000,1),pairing_stimulation(1000:3000,2)*1e11)
%plot(pairing_response(1:3000,1),pairing_response(1:3000,2)*1e3)
%plot(pairing_stimulation(1:3000,1),pairing_stimulation(1:3000,2)*1e11)
%plot(pairing_response(1000:10000,1),pairing_response(1000:10000,2)*1e3)

title([strcat('Pairing protocol for cell = ',inputs_plasticity{2,1})],'interpreter', 'none')
subplot(4,3,4); hold on;
mean_baseline_amp = nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4))),4})); 
plot(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4))),4}),'o')
plot([first_index_baseline last_index_baseline],[mean_baseline_amp mean_baseline_amp],'k','LineWidth',1.5);
if max(AP_index_baseline)==1
    plot(mean_baseline_amp*AP_index_baseline(first_index_baseline:last_index_baseline),'r*')
end
ylabel('Amplitude (pA)')
title('PSP Baseline')

subplot(4,3,5); hold on;
plot(New_results_plasticity{2,15},'o')
plot([1 length(New_results_plasticity{2,15})],[mean_baseline_amp mean_baseline_amp],'k','LineWidth',1.5);
if max(New_results_plasticity{2,22})==1
    plot(mean_baseline_amp*New_results_plasticity{2,22},'r*')
end
title('PSP post protocol')
subplot(4,3,6); hold on;
group = [zeros(1,length(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4))),4}))),ones(1,length(New_results_plasticity{2,15}))];
C = [horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4))),4}) New_results_plasticity{2,15}];
boxplot(C,group);
set(gca,'XTickLabel',{'Baseline','Post'})
ylabel('Amplitude (pA)')

subplot(4,3,7); hold on; 
plot(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4))),5}),'o','color',[0.6 0 0.2])
mean_rise_time_baseline=nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4))),5})); 
plot([first_index_baseline last_index_baseline],[mean_rise_time_baseline mean_rise_time_baseline],'k','LineWidth',1.5);
ylabel('Rise time (msec)')
xlim([first_index_baseline last_index_baseline])
subplot(4,3,8); hold on; 
plot(New_results_plasticity{2,16},'o','color',[0.6 0 0.2])
plot([1 length(New_results_plasticity{2,16})],[mean_rise_time_baseline mean_rise_time_baseline],'k','LineWidth',1.5);
subplot(4,3,9) 
group = [zeros(1,length(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4))),5}))),ones(1,length(New_results_plasticity{2,16}))];
C = [horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4))),5}) New_results_plasticity{2,16}];
boxplot(C,group);
set(gca,'XTickLabel',{'Baseline','Post'})
ylabel('Rise time (msec)')

subplot(4,3,10); hold on; 
plot(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4))),6}),'o','color',[0.4 0.8 0.2])
mean_area_baseline=nanmean(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4))),6})); 
plot([first_index_baseline last_index_baseline],[mean_area_baseline mean_area_baseline],'k','LineWidth',1.5);
ylabel('Area')
xlabel('Sweep number')
subplot(4,3,11); hold on; 
plot(New_results_plasticity{2,17},'o','color',[0.4 0.8 0.2])
plot([1 length(New_results_plasticity{2,17})],[mean_area_baseline mean_area_baseline],'k','LineWidth',1.5);
xlabel('Sweep number')
subplot(4,3,12)
group = [zeros(1,length(horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4))),6}))),ones(1,length(New_results_plasticity{2,17}))];
C = [horzcat(results_plasticity{2:sum(~cellfun(@isempty,inputs_plasticity(:,4))),6}) New_results_plasticity{2,17}];
boxplot(C,group);
set(gca,'XTickLabel',{'Baseline','Post'})
ylabel('Area')



save(strcat('STDP_new_results_cell_',inputs_plasticity{2,1}),'inputs_plasticity','results_plasticity','New_results_plasticity'); 







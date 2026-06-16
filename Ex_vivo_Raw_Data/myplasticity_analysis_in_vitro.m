function [amplitude_PSP,rise_time_PSP, area_PSP, area_PSP_half, latency, half_duration, current_deflection, holding_current,AP_index,series_resistance,spontaneous_amplitude,spontaneous_frequency]=myplasticity_analysis_in_vitro(context,inputs_plasticity,recording_index,sweep_to_avoid,check_data,PP_positive)

clearvars data myStruc

% cell1 :0.202; 0.215 ; 0.2008 ; 0.2100
% cell2 & 3 : 0.202;0.215 ; 0.2020 ; 0.207
% cell 4: 0.202; 0.215 ; 0.2020 (puis 0.2023) ; 0.2100

% sylvie cell 3: 0.202; 0.215 ; 0.2008 ; 0.2100
% cell 7, 8, 9, 11: 0.202; 0.215 ; 0.2010 ; 0.2100
% cell 10: 0.0206,0.215,0.202,0.208

cursor_PSP_start = inputs_plasticity{2,11};
cursor_PSP_end = inputs_plasticity{2,12};
cursor_baseline_PSP_start = inputs_plasticity{2,13} ;
cursor_baseline_PSP_end = inputs_plasticity{2,14} ;

cursor_baseline_resistance_start = 0.72;
cursor_baseline_resistance_end = 0.80;
cursor_resistance_start = 0.82;
cursor_resistance_end = 0.90;

if PP_positive ==1 
    cursor_baseline_resistance_start = 1.76 ;%0.72; % 1.76;
    cursor_baseline_resistance_end =1.84; % 0.80; %1.84;
    cursor_resistance_start = 1.86; %0.82; %1.86;
    cursor_resistance_end = 1.94 ; %0.90; %1.94;
end
    

load(strcat(inputs_plasticity{2,1},'_',num2str(recording_index),'.mat'));
names = fieldnames(myStruc) ;
nSweeps = length(names) ;
spontaneous_amplitude = []; 
spontaneous_frequency = []; 

s=1; 

for p=1:nSweeps
    
    %         if M==4 && p>300
    %             cursor_baseline_PSP_start = 0.2023;
    %         end
    
    Name_1 = getfield(myStruc,names{p});
    Name_1(:,2) = Name_1(:,2)*1e12;
    sampling_f = 1./(Name_1(2,1)-Name_1(1,1)); %10000; % 10kHz

    %figure(); plot(Name_1(:,2)); 
    
    if check_data ==1
        
        fig=figure(1); clf(fig) ; hold on;
        plot(Name_1(:,1),Name_1(:,2));
        plot(Name_1(:,1),smooth(Name_1(:,2),5));
        ylim([mean(Name_1(:,2))-250,mean(Name_1(:,2))+100])
        title(strcat(num2str(recording_index),'-',num2str(p)))
        pause(2)
        
        
    elseif check_data == 0 || check_data == 2 %Characteristics of EPSP
        
        baseline_resistance = mean(Name_1(ceil(cursor_baseline_resistance_start*sampling_f):ceil(cursor_baseline_resistance_end*sampling_f),2));
        deflection_resistance = mean(Name_1(ceil(cursor_resistance_start*sampling_f):ceil(cursor_resistance_end*sampling_f),2));
        peak_resistance = min(Name_1(ceil(cursor_baseline_resistance_start*sampling_f):ceil(cursor_resistance_start*sampling_f),2)); 
        
        %Name_1(:,2) = smooth(Name_1(:,2),5);
        Interpolate_EPSP_trace = interp1(Name_1,1:0.05:length(Name_1(:,1)),'linear');
        Name_2(:,1) = 1:0.05:length(Name_1(:,1));
        Name_2(:,2) = Interpolate_EPSP_trace(:,2); 
        interp_analysis = 1; 
        
        if interp_analysis == 1; 
            variable = Name_2; 
            sampling_f = sampling_f*20; 
        else 
            variable = Name_1; 
        end
        
        
        [peak_PSP,peak_PSP_cursor] = min(variable(ceil(cursor_PSP_start*sampling_f):ceil(cursor_PSP_end*sampling_f),2));
        peak_PSP_cursor = ceil(cursor_PSP_start*sampling_f) + peak_PSP_cursor;

%         %%Based on change in slope
%         [PSP_onset,argmin] = min(diff(Name_1(ceil(cursor_baseline_PSP_start*sampling_f/20):peak_PSP_cursor/20,2)));
%         onset_PSP_cursor = ceil(cursor_baseline_PSP_start*sampling_f) + argmin*20;
%         PSP_onset = Name_1(ceil(cursor_baseline_PSP_start*sampling_f/20)+argmin,2);
%         o=1;
%         while argmin==1
%             [PSP_onset,argmin] = min(diff(Name_1(ceil(cursor_baseline_PSP_start*sampling_f/20)+o:peak_PSP_cursor/20,2)));
%             onset_PSP_cursor = ceil(cursor_baseline_PSP_start*sampling_f) + argmin*20 +o;
%             PSP_onset = Name_1(ceil(cursor_baseline_PSP_start*sampling_f/20)+o+argmin,2);
%             o=o+1;
%         end
        
 
%         figure(); findchangepts(variable(ceil(cursor_baseline_PSP_start*sampling_f):peak_PSP_cursor-100,2),'Statistic','linear','MinThreshold',200)
%         
%         if peak_PSP_cursor-100 > ceil(cursor_baseline_PSP_start*sampling_f)
%             [PSP_onset,argmax] = max(smooth(diff(variable(ceil(cursor_baseline_PSP_start*sampling_f):peak_PSP_cursor-100,2)),100));
%             onset_PSP_cursor = ceil(cursor_baseline_PSP_start*sampling_f) + argmax;
%             PSP_onset = variable(onset_PSP_cursor,2); 
%         else
%             [PSP_onset,argmax] = max(smooth(diff(variable(ceil(cursor_baseline_PSP_start*sampling_f):peak_PSP_cursor-200,2)),100));
%             onset_PSP_cursor = ceil(cursor_baseline_PSP_start*sampling_f) + argmax;
%             PSP_onset = variable(onset_PSP_cursor,2); 
%         end


         [PSP_onset,argmax] = max(variable(ceil(cursor_baseline_PSP_start*sampling_f):peak_PSP_cursor,2));
         onset_PSP_cursor = ceil(cursor_baseline_PSP_start*sampling_f) + argmax;
        
        AP=0; 
        if  peak_PSP < -1000 | peak_PSP_cursor < onset_PSP_cursor 
            AP=1 ;
        else
            AP=0;
        end
        
        current_deflection(s) = NaN; 
        series_resistance(s) = NaN; 
        holding_current(s) = NaN; 
        amplitude_PSP(s) = NaN;
        rise_time_PSP(s) = NaN;
        rise_time_PSP_start(s) = NaN;
        rise_time_PSP_end(s) = NaN;
        latency(s) = NaN; 
        half_duration(s) = NaN; 
        area_PSP(s) = NaN;
        area_PSP_half(s) = NaN; 
        AP_index(s) = NaN;
        
        if any(sweep_to_avoid==s)==0 && AP==0
            
            % Amplitude of EPSP (peak to peak)
            
            %
            amplitude_PSP(s) = abs(peak_PSP - PSP_onset); % in pA
            
            %
            %amplitude_PSP(p) = abs(peak_PSP - mean(Name_1(1:2000,2))); % in pA
            
            % Slope of EPSP (20-80% rise time)
            amplitude_PSP_20 = PSP_onset - 0.20*amplitude_PSP(s) ;
            amplitude_PSP_80 = PSP_onset - 0.80*amplitude_PSP(s) ;
            
            EPSP_trace = variable(onset_PSP_cursor:peak_PSP_cursor,2);
                        
            [c_start index_start] = min(abs(EPSP_trace - amplitude_PSP_20));
            [c_end index_end] =min(abs(EPSP_trace - amplitude_PSP_80));
            
            rise_time_PSP_start(s) = (onset_PSP_cursor+index_start-1)/sampling_f;
            rise_time_PSP_end(s) = (onset_PSP_cursor+index_end-1)/sampling_f;
            rise_time_PSP(s) = (rise_time_PSP_end(s) - rise_time_PSP_start(s))*1e3; % in ms
            
            % Area of EPSP
            [value,end_possibilities] = min(abs(PSP_onset-variable(peak_PSP_cursor:peak_PSP_cursor+0.03*sampling_f,2)));
            PSP_end = peak_PSP_cursor + end_possibilities;
            area_PSP(s) = trapz(variable(onset_PSP_cursor:PSP_end));

            % Area of EPSP at halfwidth
            half_amplitude_PSP = PSP_onset - amplitude_PSP(s)/2; 
            [c_start index_start_bis] = min(abs(EPSP_trace - half_amplitude_PSP)); 
            EPSP_trace_bis = variable(peak_PSP_cursor:PSP_end,2);
            [c_start index_end_bis] = min(abs(EPSP_trace_bis - half_amplitude_PSP)); 
            PSP_halfstart = (onset_PSP_cursor + index_start_bis - 1); 
            PSP_halfend = (peak_PSP_cursor + index_end_bis - 1); 
            area_PSP_half(s) = trapz(variable(PSP_halfstart:PSP_halfend));
            
            half_duration(s) = (PSP_halfend - PSP_halfstart)/sampling_f; 
                        
            % Latency relative to Stimulation onset (peak)
            [val,ind]=max(variable(:,2));
            latency(s) = (onset_PSP_cursor - ind)/sampling_f; 
            
            % Resistance checking
            voltage_input = 5 ; % in mV voltage injected
            current_deflection(s) = voltage_input/(baseline_resistance - deflection_resistance);
            holding_current(s) = mean(Name_1(1:2000,2));
            series_resistance(s) = voltage_input/(baseline_resistance - peak_resistance) ; 

        elseif any(sweep_to_avoid==s)==0 && AP==1
            voltage_input = 5 ;
            series_resistance(s) = voltage_input/(baseline_resistance - peak_resistance) ; 
            current_deflection(s) = voltage_input/(baseline_resistance - deflection_resistance);
            holding_current(s) = mean(Name_1(1:2000,2));
            AP_index(s) = 1;
            
        end
        
        % Final plot for EPSP analysis
        if check_data==2 && any(sweep_to_avoid==s)==0 && AP==0
            fig1=figure(1); clf(fig1);hold on;
            plot(variable(1:0.4*sampling_f,2));
            plot([peak_PSP_cursor],[peak_PSP],'b*')
            plot([PSP_end],[variable(PSP_end,2)],'b*')
            plot([onset_PSP_cursor+index_start],[variable(onset_PSP_cursor + index_start,2)],'m*')
            plot([onset_PSP_cursor+index_start_bis],[variable(onset_PSP_cursor + index_start_bis,2)],'c*')
            plot([onset_PSP_cursor+index_start],[variable(onset_PSP_cursor + index_start,2)],'m*')
            plot([onset_PSP_cursor+index_end],[variable(onset_PSP_cursor+index_end,2)],'m*')
            plot([peak_PSP_cursor+index_end_bis],[variable(peak_PSP_cursor+index_end_bis,2)],'c*')
            plot([onset_PSP_cursor],[PSP_onset],'b*')
            xlim([30000 50000])
            ylim([-400 +400])
            %ylim([peak_PSP-30, PSP_onset+30])
            title(strcat(num2str(recording_index),'-',num2str(p)))
            pause(0.5)
        end
        
        
        % Detect spontaneous events
        if any(sweep_to_avoid==s)==0 %&& (PP_positive ==0 || PP_positive==1)
%             if interp_analysis == 1;
%                 variable = Name_1;
%                 sampling_f = sampling_f/20; 
%             else
%                 variable = Name_1;
%             end
%             start_spontaneous_cursor = 0.3;
%             end_spontaneous_cursor = cursor_baseline_resistance_start+0.03; 
%             voltage_spontaneous = variable(start_spontaneous_cursor*sampling_f:end_spontaneous_cursor*sampling_f,2); 
%             [bandwidth,density,xmesh,cdf] = kde(voltage_spontaneous);
%             [~,mean_kde]=max(density);
%             baseline_amplitude = xmesh(mean_kde);
%             voltage_smooth = movmean(voltage_spontaneous,200) ; 
%             voltage_long_range = movmean(voltage_spontaneous,500);
%             ipts=[]; 
%             [ipts(:,1),ipts(:,2)] = findpeaks(voltage_long_range - voltage_smooth,'MinPeakProminence',2); 
%             threshold = mean(voltage_long_range-voltage_smooth)+1.5*std(voltage_long_range-voltage_smooth);  %1.2
%             event = ipts(ipts(:,1)>threshold,:); 
%             signal_new = NaN*ones(length(voltage_spontaneous),1);
%             amplitude = [];
%             timing= [];
%             a=0;
%             for r=1:size(event,1) 
%                a=a+1; 
%                [peak_amplitude,peak_time]=min(voltage_spontaneous(max(1,(event(a,2)-100)):min(length(voltage_spontaneous),(event(a,2)+15))));
%                timing(a) = max(1,event(a,2)-100)+peak_time;
%                if (peak_amplitude - baseline_amplitude) > -200
%                    amplitude(a) = (peak_amplitude - baseline_amplitude);
%                end
%                signal_new(timing(a)) = 1;
%             end
%                 
%             if check_data==2 && any(sweep_to_avoid==p)==0
%             fig2=figure(2); clf(fig2);hold on;
%             plot(voltage_smooth);
%             plot(voltage_spontaneous);
%             plot(mean(voltage_spontaneous)*signal_new,'r*');
%             ylabel('Current (pA)');
%             xlabel('Time');
%             pause(2)
%             end
            
            
            spontaneous_amplitude = NaN; % [spontaneous_amplitude amplitude]; 
            spontaneous_frequency = NaN; %[spontaneous_frequency; length(amplitude)/(end_spontaneous_cursor-start_spontaneous_cursor)]; 

        end
        
        
    end
    
    s=s+1; 
end


end
%% New codes Ex vivo - occlusion experiments
close all 
clear 


% Figure timecourse no-tape 
opts= spreadsheetImportOptions("NumVariables", 32);
opts.Sheet = "No_tape_controls";
opts.DataRange = "A3:AF60";
opts.VariableNames = ["Notapecontrols", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, "Notapecontrols", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Notapecontrols", "EmptyFieldRule", "auto");
No_tape = readtable("/Users/charlotte.piette/Dropbox/Data_availability/Ex_vivo_occlusion.xlsx", opts, "UseExcel", false);
clear opts
No_tape = No_tape(:,2:end); 

Fam_eCB_control_index = (table2array(No_tape(4,:))==15 & table2array(No_tape(6,:))==1); 
R1_eCB_control_index = (table2array(No_tape(4,:))==15 & table2array(No_tape(6,:))==3); 
Fam_NMDA_control_index = (table2array(No_tape(4,:))==100 & table2array(No_tape(6,:))==1); 

R1_eCB_control_timecourses = table2array(No_tape([26:30,34:58],R1_eCB_control_index))./table2array(No_tape(24,R1_eCB_control_index));
R1_eCB_control_ratio = table2array(No_tape(19,R1_eCB_control_index));
Fam_eCB_control_timecourses = table2array(No_tape([26:30,34:58],Fam_eCB_control_index))./table2array(No_tape(24,Fam_eCB_control_index));
Fam_eCB_control_ratio = table2array(No_tape(19,Fam_eCB_control_index));
Fam_NMDA_control_timecourses = table2array(No_tape([26:30,34:58],Fam_NMDA_control_index))./table2array(No_tape(24,Fam_NMDA_control_index));
Fam_NMDA_control_ratio = table2array(No_tape(19,Fam_NMDA_control_index));

x_lim=25; 
lim_max=250;

figure()
subplot(3,3,[1 2]); hold on ;
errorbar(nanmean(Fam_eCB_control_timecourses,2)*100,nanstd(Fam_eCB_control_timecourses,0,2)./sqrt(sum(Fam_eCB_control_index))*100,'o');
xlim([0 x_lim])
plot([0 x_lim],[100 100],'k-')
plot([5 5],[50 lim_max],'k-.')
ylim([50 250])
xlabel('Time (min)')
set(gca,'Xtick',0:5:30,'XtickLabel',{'0','10','20','30','40','50','60'})
title('Exp at Fam+30min - No tape, eCB')
subplot(3,3,3); hold on ;
scatter(ones(sum(Fam_eCB_control_index),1),Fam_eCB_control_ratio*100,'jitter','on')
errorbar(nanmean(Fam_eCB_control_ratio)*100,nanstd(Fam_eCB_control_ratio)/sqrt(sum(Fam_eCB_control_index))*100,'ks');
set(gca,'Xtick',1,'XtickLabel',{'Ctrl (n=13)'})
plot([0 1.5],[100 100],'k-')
xlim([0.5 1.5])
ylim([50 250])

subplot(3,3,[4 5]); hold on ;
errorbar(nanmean(R1_eCB_control_timecourses,2)*100,nanstd(R1_eCB_control_timecourses,0,2)./sqrt(sum(R1_eCB_control_index))*100,'o');
xlim([0 26])
plot([0 26],[100 100],'k-')
plot([5 5],[50 lim_max],'k-.')
ylim([50 lim_max])
xlabel('Time (min)')
set(gca,'Xtick',0:5:30,'XtickLabel',{'0','10','20','30','40','50','60'})
title('Exp at R1+30min - No tape, eCB')
subplot(3,3,6); hold on ;
scatter(ones(sum(R1_eCB_control_index),1),R1_eCB_control_ratio*100,'jitter','on')
errorbar(nanmean(R1_eCB_control_ratio)*100,nanstd(R1_eCB_control_ratio)/sqrt(sum(R1_eCB_control_index))*100,'ks');
set(gca,'Xtick',1,'XtickLabel',{'Ctrl (n=11)'})
plot([0 2.5],[100 100],'k-')
xlim([0.5 1.5])
ylim([50 250])

x_lim=23; 
subplot(3,3,[7 8]); hold on ;
errorbar(nanmean(Fam_NMDA_control_timecourses,2)*100,nanstd(Fam_NMDA_control_timecourses,0,2)./sqrt(sum(Fam_NMDA_control_index))*100,'o');
xlim([0 x_lim])
plot([0 x_lim],[100 100],'k-')
plot([5 5],[50 lim_max],'k-.')
ylim([50 250])
xlabel('Time (min)')
set(gca,'Xtick',0:5:30,'XtickLabel',{'0','10','20','30','40','50','60'})
title('Exp at Fam+30min - No tape, NMDA')
subplot(3,3,9); hold on ;
scatter(ones(sum(Fam_NMDA_control_index),1),Fam_NMDA_control_ratio*100,'jitter','on')
errorbar(nanmean(Fam_NMDA_control_ratio)*100,nanstd(Fam_NMDA_control_ratio)/sqrt(sum(Fam_NMDA_control_index))*100,'ks');
set(gca,'Xtick',1,'XtickLabel',{'Ctrl (n=6)'})
plot([0 1.5],[100 100],'k-')
xlim([0.5 1.5])
ylim([50 260])



% Figure timecourse eCB
opts = spreadsheetImportOptions("NumVariables", 51);
opts.Sheet = "Tape_eCB";
opts.DataRange = "A3:AY62";
opts.VariableNames = ["TapeeCBplasticity", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38", "VarName39", "VarName40", "VarName41", "VarName42", "VarName43", "VarName44", "VarName45", "VarName46", "VarName47", "VarName48", "VarName49", "VarName50", "VarName51"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, "TapeeCBplasticity", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "TapeeCBplasticity", "EmptyFieldRule", "auto");
eCB = readtable("/Users/charlotte.piette/Dropbox/Data_availability/Ex_vivo_occlusion.xlsx", opts, "UseExcel", false);
clear opts
eCB = eCB(:,2:end); 

Fam_eCB_scotch_court = (table2array(eCB(9,:))<=25 & table2array(eCB(6,:))==1); 
Fam_eCB_scotch_long = (table2array(eCB(9,:))>25 & table2array(eCB(6,:))==1);
Fam_24h_eCB = (table2array(eCB(6,:))==2); 
R1_eCB_scotch_court_appris = (table2array(eCB(7,:))>0 & table2array(eCB(6,:))==3); 
R1_eCB_scotch_court_pas_appris = (table2array(eCB(7,:))<=0 & table2array(eCB(10,:))>=1 & table2array(eCB(6,:))==3); 
R1_eCB_scotch_court_passif = (table2array(eCB(7,:))<=0 & table2array(eCB(10,:))<1 & table2array(eCB(6,:))==3); 

Fam_eCB_scotch_timecourses_court = table2array(eCB([26:30,34:60],Fam_eCB_scotch_court))./table2array(eCB(24,Fam_eCB_scotch_court));
Fam_eCB_scotch_timecourses_long = table2array(eCB([26:30,34:60],Fam_eCB_scotch_long))./table2array(eCB(24,Fam_eCB_scotch_long));
Fam_eCB_scotch_ratio_court = table2array(eCB(19,Fam_eCB_scotch_court));
Fam_eCB_scotch_ratio_long = table2array(eCB(19,Fam_eCB_scotch_long));

Fam_eCB_scotch_timecourses_court_24h =table2array(eCB([26:30,34:60],Fam_24h_eCB))./table2array(eCB(24,Fam_24h_eCB));
Fam_eCB_scotch_ratio_court_24h = table2array(eCB(19,Fam_24h_eCB));

R1_eCB_scotch_timecourses_court_appris = table2array(eCB([26:30,34:60],R1_eCB_scotch_court_appris))./table2array(eCB(24,R1_eCB_scotch_court_appris));
R1_eCB_scotch_timecourses_court_pas_appris = table2array(eCB([26:30,34:60],R1_eCB_scotch_court_pas_appris))./table2array(eCB(24,R1_eCB_scotch_court_pas_appris));
R1_eCB_scotch_timecourses_court_passif = table2array(eCB([26:30,34:60],R1_eCB_scotch_court_passif))./table2array(eCB(24,R1_eCB_scotch_court_passif));
R1_eCB_scotch_ratio_court_appris = table2array(eCB(19,R1_eCB_scotch_court_appris));
R1_eCB_scotch_ratio_court_pas_appris = table2array(eCB(19,R1_eCB_scotch_court_pas_appris));
R1_eCB_scotch_ratio_court_passif = table2array(eCB(19,R1_eCB_scotch_court_passif));


x_lim=25; 
lim_max = 250;
figure();  % Fam
subplot(2,3,[1 2]); hold on ;
errorbar(nanmean(Fam_eCB_scotch_timecourses_court,2)*100,nanstd(Fam_eCB_scotch_timecourses_court,0,2)./sqrt(sum(Fam_eCB_scotch_court))*100,'o');
errorbar(nanmean(Fam_eCB_scotch_timecourses_long,2)*100,nanstd(Fam_eCB_scotch_timecourses_long,0,2)./sqrt(sum(Fam_eCB_scotch_long))*100,'o');
xlim([0 x_lim])
plot([0 x_lim],[100 100],'k-')
plot([5 5],[50 250],'k-.')
ylim([50 250])
ylabel('Normalized EPSC')
xlabel('Time (min)')
set(gca,'Xtick',0:5:30,'XtickLabel',{'0','10','20','30','40','50','60'})
title('Exp at Fam+30min, eCB')
subplot(2,3,3); hold on ;
scatter(1*ones(sum(Fam_eCB_scotch_court),1),Fam_eCB_scotch_ratio_court*100,'jitter','on')
scatter(2*ones(sum(Fam_eCB_scotch_long),1),Fam_eCB_scotch_ratio_long*100,'jitter','on')
errorbar([nanmean(Fam_eCB_scotch_ratio_court) nanmean(Fam_eCB_scotch_ratio_long)]*100,[nanstd(Fam_eCB_scotch_ratio_court)/sqrt(sum(Fam_eCB_scotch_ratio_court))*100 nanstd(Fam_eCB_scotch_ratio_long)/sqrt(sum(Fam_eCB_scotch_ratio_long))*100],'ks');
set(gca,'Xtick',1:2,'XtickLabel',{'Short (n=9)','Long (n=10)'})
plot([0 2.5],[100 100],'k-')
xlim([0.5 2.8])
ylim([50 250])

subplot(2,3,[4 5]); hold on ;
errorbar(nanmean(Fam_eCB_scotch_timecourses_court_24h,2)*100,nanstd(Fam_eCB_scotch_timecourses_court_24h,0,2)./sqrt(sum(Fam_24h_eCB))*100,'o');
xlim([0 x_lim])
plot([0 x_lim],[100 100],'k-')
plot([5 5],[50 lim_max],'k-.')
ylim([40 lim_max])
xlabel('Time (min)')
set(gca,'Xtick',0:5:30,'XtickLabel',{'0','10','20','30','40','50','60'})
title('Exp at Fam+24h, eCB')
subplot(2,3,6); hold on ;
scatter(1*ones(sum(Fam_24h_eCB),1),Fam_eCB_scotch_ratio_court_24h*100,'jitter','on')
errorbar(nanmean(Fam_eCB_scotch_ratio_court_24h)*100,nanstd(Fam_eCB_scotch_ratio_court_24h)/sqrt(sum(Fam_24h_eCB))*100,'ks');
set(gca,'Xtick',1,'XtickLabel',{'+24h Short (n=7)'})
plot([0 1.5],[100 100],'k-')
xlim([0.5 1.5])
ylim([40 250])


figure(); % R1
lim_max = 250;
subplot(2,3,[1 2]); hold on ;
errorbar(nanmean(R1_eCB_scotch_timecourses_court_appris,2)*100,nanstd(R1_eCB_scotch_timecourses_court_appris,0,2)./sqrt(sum(R1_eCB_scotch_court_appris))*100,'o');
errorbar(nanmean(R1_eCB_scotch_timecourses_court_pas_appris,2)*100,nanstd(R1_eCB_scotch_timecourses_court_pas_appris,0,2)./sqrt(sum(R1_eCB_scotch_court_pas_appris))*100,'o');
xlim([0 x_lim])
plot([0 x_lim],[100 100],'k-')
plot([5 5],[50 lim_max],'k-.')
ylim([50 250])
ylabel('Normalized EPSC')
xlabel('Time (min)')
set(gca,'Xtick',0:5:30,'XtickLabel',{'0','10','20','30','40','50','60'})
title('Exp at R1+30min (Short Contact), eCB')
subplot(2,3,3); hold on ;
scatter(1*ones(sum(R1_eCB_scotch_court_appris),1),R1_eCB_scotch_ratio_court_appris*100,'jitter','on')
scatter(2*ones(sum(R1_eCB_scotch_court_pas_appris),1),R1_eCB_scotch_ratio_court_pas_appris*100,'jitter','on')
errorbar([nanmean(R1_eCB_scotch_ratio_court_appris) nanmean(R1_eCB_scotch_ratio_court_pas_appris)]*100,[nanstd(R1_eCB_scotch_ratio_court_appris)/sqrt(length(R1_eCB_scotch_ratio_court_appris))*100 nanstd(R1_eCB_scotch_ratio_court_pas_appris)/sqrt(length(R1_eCB_scotch_ratio_court_pas_appris))*100],'ks');
set(gca,'Xtick',1:2,'XtickLabel',{'Learnt (n=11)','Not learnt (n=7)'})
plot([0 2.5],[100 100],'k-')
xlim([0.5 2.8])
ylim([50 250])


subplot(2,3,[4 5]); hold on ;
errorbar(nanmean(R1_eCB_scotch_timecourses_court_passif,2)*100,nanstd(R1_eCB_scotch_timecourses_court_passif,0,2)./sqrt(sum(R1_eCB_scotch_court_passif))*100,'o');
xlim([0 x_lim])
plot([0 x_lim],[100 100],'k-')
plot([5 5],[50 lim_max],'k-.')
ylim([50 lim_max])
xlabel('Time (min)')
set(gca,'Xtick',0:5:30,'XtickLabel',{'0','10','20','30','40','50','60'})
title('Exp at R1+30min (Short Contact), eCB')
subplot(2,3,6); hold on ;
scatter(1*ones(sum(R1_eCB_scotch_court_passif),1),R1_eCB_scotch_ratio_court_passif*100,'jitter','on')
errorbar(nanmean(R1_eCB_scotch_ratio_court_passif)*100,nanstd(R1_eCB_scotch_ratio_court_passif)/sqrt(sum(R1_eCB_scotch_court_passif))*100,'ks');
set(gca,'Xtick',1,'XtickLabel',{'Passive (n=6)'})
plot([0 1.5],[100 100],'k-')
xlim([0.5 1.5])
ylim([50 250])



% Figure timecourse NMDA
opts = spreadsheetImportOptions("NumVariables", 40);
opts.Sheet = "Tape_NMDA";
opts.DataRange = "A3:AN59";
opts.VariableNames = ["TapeNMDAplasticity", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38", "VarName39", "VarName40"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, "TapeNMDAplasticity", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "TapeNMDAplasticity", "EmptyFieldRule", "auto");
NMDA = readtable("/Users/charlotte.piette/Dropbox/Data_availability/Ex_vivo_occlusion.xlsx", opts, "UseExcel", false);
clear opts
NMDA = NMDA(:,2:end); 

Fam_NMDA_scotch_court = (table2array(NMDA(9,:))<=25 & (table2array(NMDA(6,:))==1 | table2array(NMDA(6,:))==2)); 
Fam_NMDA_scotch_long = (table2array(NMDA(9,:))>25 & (table2array(NMDA(6,:))==1 | table2array(NMDA(6,:))==2));
R1_NMDA_scotch_court_appris = (table2array(NMDA(7,:))>0 & table2array(NMDA(6,:))==3); 

Fam_NMDA_scotch_timecourses_court = table2array(NMDA([26:30,34:57],Fam_NMDA_scotch_court))./table2array(NMDA(24,Fam_NMDA_scotch_court));
Fam_NMDA_scotch_timecourses_long = table2array(NMDA([26:30,34:57],Fam_NMDA_scotch_long))./table2array(NMDA(24,Fam_NMDA_scotch_long));
Fam_NMDA_scotch_ratio_court = table2array(NMDA(19,Fam_NMDA_scotch_court));
Fam_NMDA_scotch_ratio_long = table2array(NMDA(19,Fam_NMDA_scotch_long));

R1_NMDA_scotch_timecourses_court_appris = table2array(NMDA([26:30,34:57],R1_NMDA_scotch_court_appris))./table2array(NMDA(24,R1_NMDA_scotch_court_appris));
R1_NMDA_scotch_ratio_court_appris = table2array(NMDA(19,R1_NMDA_scotch_court_appris));


% NMDA component
figure(); 
x_lim=25
lim_max = 250; 
subplot(2,3,[1 2]); hold on ;
errorbar(nanmean(Fam_NMDA_scotch_timecourses_court,2)*100,nanstd(Fam_NMDA_scotch_timecourses_court,0,2)./sqrt(sum(Fam_NMDA_scotch_court))*100,'o');
errorbar(nanmean(Fam_NMDA_scotch_timecourses_long,2)*100,nanstd(Fam_NMDA_scotch_timecourses_long,0,2)./sqrt(sum(Fam_NMDA_scotch_long))*100,'o');
xlim([0 x_lim])
plot([0 x_lim],[100 100],'k-')
plot([5 5],[50 lim_max],'k-.')
ylim([40 lim_max])
ylabel('Normalized EPSC')
xlabel('Time (min)')
set(gca,'Xtick',0:5:30,'XtickLabel',{'0','10','20','30','40','50','60'})
title('Exp at Fam+30min/24h, NMDA')
subplot(2,3,3); hold on ;
scatter(1*ones(sum(Fam_NMDA_scotch_court),1),Fam_NMDA_scotch_ratio_court*100,'jitter','on')
scatter(2*ones(sum(Fam_NMDA_scotch_long),1),Fam_NMDA_scotch_ratio_long*100,'jitter','on')
errorbar([nanmean(Fam_NMDA_scotch_ratio_court) nanmean(Fam_NMDA_scotch_ratio_long)]*100,[nanstd(Fam_NMDA_scotch_ratio_court)/sqrt(length(Fam_NMDA_scotch_ratio_court))*100 nanstd(Fam_NMDA_scotch_ratio_long)/sqrt(length(Fam_NMDA_scotch_ratio_long))*100],'ks');
set(gca,'Xtick',1:2,'XtickLabel',{'Short (n=14)','Long (n=17)'})
plot([0 2.5],[100 100],'k-')
xlim([0.5 2.8])
ylim([40 250])

subplot(2,3,[4 5]); hold on ;
errorbar(nanmean(R1_NMDA_scotch_timecourses_court_appris,2)*100,nanstd(R1_NMDA_scotch_timecourses_court_appris,0,2)./sqrt(sum(R1_NMDA_scotch_court_appris))*100,'o');
xlim([0 x_lim])
plot([0 x_lim],[100 100],'k-')
plot([5 5],[50 lim_max],'k-.')
ylim([50 250])
xlabel('Time (min)')
set(gca,'Xtick',0:5:30,'XtickLabel',{'0','10','20','30','40','50','60'})
title('Exp at R1+30min (Short Contact), NMDA')
subplot(2,3,6); hold on ;
scatter(1*ones(sum(R1_NMDA_scotch_court_appris),1),R1_NMDA_scotch_ratio_court_appris*100,'jitter','on')
errorbar(nanmean(R1_NMDA_scotch_ratio_court_appris)*100,nanstd(R1_NMDA_scotch_ratio_court_appris)/sqrt(length(R1_NMDA_scotch_ratio_court_appris))*100,'ks');
set(gca,'Xtick',1,'XtickLabel',{'Learnt (n=8)'})
plot([0 2.5],[100 100],'k-')
xlim([0.5 2.8])
ylim([50 350])



%% Bar charts - proportion of plasticity as a function of condition  (Fig. 5e)

figure(); % No-tape
subplot(2,2,1) 
bar(1,[12/13 1/13 0],'stacked')
title("eCB - No scotch (n=13)")
subplot(2,2,2) 
bar(1,[6/6 0 0],'stacked')
title("NMDA - No scotch (n=6)")
subplot(2,2,3) 
bar(1,[11/11 0 0],'stacked')
title("eCB R1 - No scotch (n=11)")
legend('LTP','No change','LTD')


figure(); % R1
subplot(1,4,1) 
bar(1,[3/11 2/11 6/11],'stacked')
title("eCB - Short Fam - Learnt (n=11)")
subplot(1,4,2) 
bar(1,[5/7 2/7 0],'stacked')
title("eCB - Short Fam - Not Learnt (n=7)")
subplot(1,4,3) 
bar(1,[5/6 1/6 0],'stacked')
title("eCB - Short Fam - Passive (n=6)")
subplot(1,4,4) 
bar(1,[7/8 1/8 0],'stacked')
title("NMDA - Short Fam - Learnt (n=8)")
legend('LTP','No change','LTD')

figure(); % Fam
subplot(1,5,1) 
bar(1,[2/9 5/9 2/9],'stacked')
title("eCB - Short Fam (n=9)")
subplot(1,5,2) 
bar(1,[1/7 0/0 6/7],'stacked')
title("eCB - Short Fam +24h (n=7)")
subplot(1,5,3) 
bar(1,[6/10 0 4/10],'stacked') 
title("NMDA - Short Fam (n=10)")
subplot(1,5,4) 
bar(1,[7/10 2/10 1/10],'stacked')
title("eCB - Long Fam (n=10)")
subplot(1,5,5) 
bar(1,[4/15 2/15 9/15],'stacked')
title("NMDA - Long Fam (n=15)")
legend('LTP','No change','LTD')



%% Scatter ratio as a function of contact duration (Fig. 5f) 
figure();
subplot(1,2,1); hold on;  
scatter(summary_plasticity(summary_plasticity(:,9)==1,7)+randn(19,1)/10,summary_plasticity(summary_plasticity(:,9)==1,6),'o')
scatter(summary_plasticity(summary_plasticity(:,9)==0,7)+randn(7,1)/10,summary_plasticity(summary_plasticity(:,9)==0,6),'>')

x = summary_plasticity(1:26,7);
y = summary_plasticity(1:26,6);
logx = log10(x); 
p = polyfit(logx, y, 1); % linear fit in log-x space
xfit = linspace(min(x), max(x), 100);
yfit = polyval(p, log10(xfit));
plot(xfit, yfit, 'r-', 'LineWidth', 2);

xlabel('Contact duration')
ylabel('Plasticity ratio')
title('ECB-LTP occlusion after Fam')
legend('+30min','+24h')
plot([30 30],[0 2.5],'k-')
plot([0.1 1000],[1 1],'k-')
set(gca,'XScale','log')
[r,p]=corrcoef(summary_plasticity(:,7),summary_plasticity(:,6),'rows','complete'); %p=0.0109, r=0.491
[r,p]=corrcoef(summary_plasticity(summary_plasticity(:,9)==1,7),summary_plasticity(summary_plasticity(:,9)==1,6),'rows','complete'); %p=0.0454, r=0.464


subplot(1,2,2); hold on;  
scatter(summary_plasticity(summary_plasticity(:,15)==1,13)+randn(25,1)/10,summary_plasticity(summary_plasticity(:,15)==1,12),'o')
scatter(summary_plasticity(summary_plasticity(:,15)==0,13)+randn(6,1)/10,summary_plasticity(summary_plasticity(:,15)==0,12),'>')
x = summary_plasticity(:,13);
y = summary_plasticity(:,12);
logx = log10(x); 
p = polyfit(logx, y, 1); % linear fit in log-x space
xfit = linspace(min(x), max(x), 100);
yfit = polyval(p, log10(xfit));
plot(xfit, yfit, 'r-', 'LineWidth', 2);

xlabel('Contact duration')
ylabel('Plasticity ratio')
title('NMDA-LTP occlusion after Fam')
legend('+30min','+24h')
plot([30 30],[0 2.5],'k-')
plot([0.1 1000],[1 1],'k-')
set(gca,'XScale','log')

[r,p]=corrcoef(summary_plasticity(:,13),summary_plasticity(:,12),'rows','complete'); %p=0.0349, r=-0.38
[r,p]=corrcoef(summary_plasticity(summary_plasticity(:,15)==1,13),summary_plasticity(summary_plasticity(:,15)==1,12),'rows','complete'); %p=0.0379, r=0.4173


%% Analysis at R1: link between avoidance index/plasticity (Fig. 5g) 

opts = spreadsheetImportOptions("NumVariables", 28);
opts.Sheet = "STATS_NEW";
opts.DataRange = "A6:AB36";
opts.VariableNames = ["VarName1", "TesteCBSansscotch", "R1eCBSansscotch", "TestNMDASansscotch", "VarName5", "TesteCBScotch", "DuredecontactFam", "DurederetraitactfFam", "A30minA24h", "VarName10", "VarName11", "TestNMDAScotchcontactcourt", "DuredecontactFam_1", "DurederetraitactfFam_1", "A30minA24h_1", "VarName16", "VarName17", "R1eCBScotchcontact", "DuredecontactFam_2", "DurederetraitactfFam_2", "Performanceindex", "Passif", "VarName23", "VarName24", "R1NMDAScotchcontact", "DuredecontactFam_3", "DurederetraitactfFam_3", "Performanceindex_1"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
summary_plasticity = readtable("/Users/charlotte.piette/Dropbox/Data_availability/Ex_vivo_occlusion.xlsx", opts, "UseExcel", false);
summary_plasticity = table2array(summary_plasticity);
clear opts

figure(); hold on; 
scatter(summary_plasticity(:,19)+randn(31,1)/10,summary_plasticity(:,21)+randn(31,1)/70,80,summary_plasticity(:,18)-1,'filled','MarkerEdgeColor','k')
plot([30 30],[-0.8 0.6],'k-')
plot([0.1 1000],[0 0],'k-')
set(gca,'XScale','log')
colormap bluewhitered 
colorbar
ylabel('Avoidance index R1')
xlabel('Contact duration Fam')
title('eCB plasticity after R1')
title('With slight jitter to see all data points')






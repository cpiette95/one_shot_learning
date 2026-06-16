%  Figures 1 & 2 - behaviour

clear 

opts = spreadsheetImportOptions("NumVariables", 93);
opts.Sheet = "Data_WT";
opts.DataRange = "A5:CO132";
opts.VariableNames = ["Mousename", "Sex", "Strain", "Age", "DOB", "DOT", "NB", "Condition", "Latencybeforecontact", "Sniffings", "Detours", "Demitours", "Aside", "Speedbeforecontact", "Contactactivity", "Contactgaze", "Contactzone1", "Avoidanceindex", "latencytofirstpassagenearthetape","Episodes","speedatentryinthearenacms", "distancerunbeforecontactm", "timespentstilluntilcontact", "timespentnearthewallsuntilcontact", "Crossesbeforecontact", "timespentinscochhalfuntilcontact", "timespentimmobileinscochhalfuntilcontact", "timespentimmobileinotherhalfuntilcontact", "speedimmediatelyaftercontactcms", "durationofcontact", "durationinpresenceoftape", "latencybeforerealizingcontact", "latencybeforefirstactiveremoval", "timetoremove", "removalenergy", "surpriseenergy", "timesecofgroomingduringcontact", "rearingsduringcontact", "distancerunduringcontactm", "maxspeedduringcontactcms", "meanspeedduringcontactcms", "timespentimmobileduringcontact", "sniffings1minpostremoval", "detours1minpostremoval", "rearing1minpostremoval", "timespentgroomings1minpostremoval", "whencontactwithnonstickytapepostremoval", "attemptsatremovingthetape", "attempts02satremovingthetape", "attempts02s05satremovingthetape", "attempts05s1satremovingthetape", "attempts1s5satremovingthetape", "attempts5satremovingthetape", "VarName54", "Latencybeforecontacts", "sniffingsneartape", "detoursneartape", "Uturnsneartape", "sidepassages", "speedbeforecontactcms", "ontactactivity", "contactgaze", "initialzoneofcontact", "Avoidanceindex1", "latencytofirstpassagenearthetape1", "episodesneartape", "speedatentryinthearenacms1", "distancerunbeforecontactm1", "timespentstilluntilcontact1", "timespentnearthewallsuntilcontact1", "Crossesbeforecontact1", "timespentinscochhalfuntilcontact1", "timespentimmobileinscochhalfuntilcontact1", "timespentimmobileinotherhalfuntilcontact1", "speedimmediatelyaftercontactcms1", "durationofcontact1", "durationinpresenceoftape1", "latencybeforerealizingcontact1", "timetoremove1", "removalenergy1", "surpriseenergy1", "timesecofgroomingduringcontact1", "rearingsduringcontact1", "timespentstillin25firstmeterstraveled", "timespentnearthewallsin25firstmeterstraveled", "centralcrossesin25firstmeterstraveled", "timespentinhalfarenawheretapein25firstmeterstraveled", "timespentimmobileinhalfarenawheretapein25firstmeterstraveled", "timespentimmobileinotherhalfin25firstmeterstraveled", "timenearscotch4cminfirst30sec", "timenearscotch6cminfirst30sec", "timenearscotch8cminfirst30sec", "timenearscotch10cminfirst30sec"];
opts.VariableTypes = ["string", "categorical", "categorical", "double", "datetime", "datetime", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Mousename"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Mousename", "Sex", "Strain", "NB"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "DOB", "InputFormat", "");
opts = setvaropts(opts, "DOT", "InputFormat", "");
Behaviour_data = readtable("/Users/charlotte.piette/Dropbox/Data_availability/Data_Behavior.xlsx", opts, "UseExcel", false);
clear opts

mice_to_keep = [1:56,58:70,72:87,89:121]; 
Behaviour_data=Behaviour_data(mice_to_keep,:); 

condition=table2array(Behaviour_data(:,8)); 

data_to_analyse_Fam = table2array(Behaviour_data(:,9:17)); 
data_to_analyse_R1 = table2array(Behaviour_data(:,55:63)); 
header={'latency','sniffing','detours','demitours','side','speed','activity','gaze','zone'};

data_to_analyse_Fam_trunc=data_to_analyse_Fam;
data_to_analyse_Fam_trunc(data_to_analyse_Fam(:,2)>=2,2)=2; 
data_to_analyse_Fam_trunc(data_to_analyse_Fam(:,3)>=2,3)=2; 
data_to_analyse_Fam_trunc(data_to_analyse_Fam(:,4)>=1,4)=1; 
data_to_analyse_Fam_trunc(data_to_analyse_Fam(:,5)>=2,5)=2; 
data_to_analyse_Fam_trunc(isnan(data_to_analyse_Fam(:,6)),6)=0;

contact_duration_Fam = table2array(Behaviour_data(:,30));
contact_duration_R1 = table2array(Behaviour_data(:,76));
active_removal_Fam = table2array(Behaviour_data(:,34));

data_to_analyse_R1_trunc=data_to_analyse_R1;
data_to_analyse_R1_trunc(data_to_analyse_R1(:,2)>=2,2)=2; 
data_to_analyse_R1_trunc(data_to_analyse_R1(:,3)>=2,3)=2; 
data_to_analyse_R1_trunc(data_to_analyse_R1(:,4)>=1,4)=1; 
data_to_analyse_R1_trunc(data_to_analyse_R1(:,5)>=2,5)=2; 
data_to_analyse_R1_trunc(isnan(data_to_analyse_R1(:,6)),6)=0;

% Definition of avoidance index from R1 data: 
[~,mu,std_pca]=zscore(data_to_analyse_R1_trunc);
[coeff_R1,score_R1,latent,explained]=pca(zscore(data_to_analyse_R1_trunc));
score_R1_not_norm = score_R1; 
score_R1(:,1) = score_R1(:,1)/(max(score_R1_not_norm(:,1))-min(score_R1_not_norm(:,1))); 
score_R1(:,2) = score_R1(:,2)/(max(score_R1_not_norm(:,2))-min(score_R1_not_norm(:,2))); 

figure(); scatter(score_R1(:,1),score_R1(:,2)) 
R1_pca_index_1= score_R1(:,1)-score_R1(:,2); 
R1_pca_index_2= score_R1(:,1)+score_R1(:,2); 

a1=1; a2=0.45;
avoidance_index_R1 = a1*R1_pca_index_1 +a2*R1_pca_index_2 ; 


% Extension to Fam data, based on the coefficients calculated above: 
norm_Fam_PCA = (data_to_analyse_Fam_trunc-mu)./std_pca; 
score_Fam = norm_Fam_PCA*coeff_R1; 
score_Fam(:,1) = score_Fam(:,1)/(max(score_R1_not_norm(:,1))-min(score_R1_not_norm(:,1))); 
score_Fam(:,2) = score_Fam(:,2)/(max(score_R1_not_norm(:,2))-min(score_R1_not_norm(:,2))); 
Fam_pca_index_1=score_Fam(:,1)-score_Fam(:,2); 
Fam_pca_index_2= score_Fam(:,1)+score_Fam(:,2); 
avoidance_index_Fam = a1*Fam_pca_index_1 +a2*Fam_pca_index_2 ; 


%% Application also to nSTA conditions: 
opts = spreadsheetImportOptions("NumVariables", 31);
opts.Sheet = "Data_nSTA";
opts.DataRange = "A4:AE25";
opts.VariableNames = ["Mousename", "Sexe", "StrainConditionWT", "Age", "DOB", "DOT", "NB", "Condition", "Latencybeforecontacts", "sniffingsneartape", "detoursneartape", "Uturnsneartape", "sidepassages", "speedbeforecontactcms", "ontactactivity", "contactgaze", "initialzoneofcontact", "Avoidanceindex", "durationofcontacts", "timetoremoves", "Latencybeforecontacts1", "sniffingsneartape1", "detoursneartape1", "Uturnsneartape1", "sidepassages1", "speedbeforecontactcms1", "ontactactivity1", "contactgaze1", "initialzoneofcontact1", "Avoidanceindex1", "durationofcontacts1"];
opts.VariableTypes = ["string", "categorical", "categorical", "double", "datetime", "datetime", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Mousename", "NB"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Mousename", "Sexe", "StrainConditionWT", "NB"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "DOB", "InputFormat", "");
opts = setvaropts(opts, "DOT", "InputFormat", "");
Behaviour_data_nSTA = readtable("/Users/charlotte.piette/Dropbox/Data_availability/Data_Behavior.xlsx", opts, "UseExcel", false);
clear opts

data_to_analyse_Fam_nSTA = table2array(Behaviour_data_nSTA(:,9:17)); 
data_to_analyse_R1_nSTA = table2array(Behaviour_data_nSTA(:,21:29)); 

data_to_analyse_Fam_nSTAtrunc=data_to_analyse_Fam_nSTA;
data_to_analyse_Fam_nSTAtrunc(data_to_analyse_Fam_nSTA(:,2)>=2,2)=2; 
data_to_analyse_Fam_nSTAtrunc(data_to_analyse_Fam_nSTA(:,3)>=2,3)=2; 
data_to_analyse_Fam_nSTAtrunc(data_to_analyse_Fam_nSTA(:,4)>=1,4)=1; 
data_to_analyse_Fam_nSTAtrunc(data_to_analyse_Fam_nSTA(:,5)>=2,5)=2; 
data_to_analyse_Fam_nSTAtrunc(isnan(data_to_analyse_Fam_nSTA(:,6)),6)=0;

data_to_analyse_R1_nSTAtrunc=data_to_analyse_R1_nSTA;
data_to_analyse_R1_nSTAtrunc(data_to_analyse_R1_nSTA(:,2)>=2,2)=2; 
data_to_analyse_R1_nSTAtrunc(data_to_analyse_R1_nSTA(:,3)>=2,3)=2; 
data_to_analyse_R1_nSTAtrunc(data_to_analyse_R1_nSTA(:,4)>=1,4)=1; 
data_to_analyse_R1_nSTAtrunc(data_to_analyse_R1_nSTA(:,5)>=2,5)=2; 
data_to_analyse_R1_nSTAtrunc(isnan(data_to_analyse_R1_nSTA(:,6)),6)=0;

norm_Fam_NC_PCA = (data_to_analyse_Fam_nSTAtrunc-mu)./std_pca; 
score_Fam_NC = norm_Fam_NC_PCA*coeff_R1; 
score_Fam_NC(:,1) = score_Fam_NC(:,1)/(max(score_R1_not_norm(:,1))-min(score_R1_not_norm(:,1))); 
score_Fam_NC(:,2) = score_Fam_NC(:,2)/(max(score_R1_not_norm(:,2))-min(score_R1_not_norm(:,2))); 
Fam_NC_pca_index_1=score_Fam_NC(:,1)-score_Fam_NC(:,2); 
Fam_NC_pca_index_2= score_Fam_NC(:,1)+score_Fam_NC(:,2); 

norm_R1_NC_PCA = (data_to_analyse_R1_nSTAtrunc-mu)./std_pca; 
score_R1_NC = norm_R1_NC_PCA*coeff_R1; 
score_R1_NC(:,1) = score_R1_NC(:,1)/(max(score_R1_not_norm(:,1))-min(score_R1_not_norm(:,1))); 
score_R1_NC(:,2) = score_R1_NC(:,2)/(max(score_R1_not_norm(:,2))-min(score_R1_not_norm(:,2))); 
R1_NC_pca_index_1=score_R1_NC(:,1)-score_R1_NC(:,2); 
R1_NC_pca_index_2= score_R1_NC(:,1)+score_R1_NC(:,2); 

a1=1; a2=0.45;
avoidance_index_Fam_nSTA = a1*Fam_NC_pca_index_1 +a2*Fam_NC_pca_index_2 ; 
avoidance_index_R1_nSTA = a1*R1_NC_pca_index_1 +a2*R1_NC_pca_index_2 ; 


%% Basic parameters (Figure 1c-f)
figure(); 
params={'Latency before contact (s)','#Detours'}
index=[1,3]; 

max_val=[600 20]; 
for k=1:2
subplot(1,2,k); hold on ;
plot(1:2,[data_to_analyse_Fam(condition==1,index(k)),data_to_analyse_R1(condition==1,index(k))],'Color',[0.8,0.8,0.8])
plot(3:4,[data_to_analyse_Fam_nSTA(:,index(k)),data_to_analyse_R1_nSTA(:,index(k))],'Color',[0.8,0.8,0.8])

errorbar(1:2,[nanmean(data_to_analyse_Fam(condition==1,index(k))),nanmean(data_to_analyse_R1(condition==1,index(k)))],[nanstd(data_to_analyse_Fam(condition==1,index(k)))/sqrt(sum(condition==1)),nanstd(data_to_analyse_R1(condition==1,index(k)))/sqrt(sum(condition==1))],'k-','LineWidth',2)
errorbar(3:4,[nanmean(data_to_analyse_Fam_nSTA(:,index(k))),nanmean(data_to_analyse_R1_nSTA(:,index(k)))],[nanstd(data_to_analyse_Fam_nSTA(:,index(k)))/sqrt(size(data_to_analyse_Fam_nSTA,1)),nanstd(data_to_analyse_R1_nSTA(:,index(k)))/sqrt(size(data_to_analyse_Fam_nSTA,1))],'k-','LineWidth',2)

ylabel(params(k))
set(gca,'Xtick',1:4,'Xticklabel',{'Fam','R1','Fam-nSTA','R1-nSTA'})

xlim([0 5])
ylim([-0.5 max_val(k)])

end

figure(); hold on; 
plot(1:2,[contact_duration_Fam(condition==1),contact_duration_R1(condition==1)],'Color',[0.8,0.8,0.8])
errorbar(1:2,[nanmean(contact_duration_Fam(condition==1)),nanmean(contact_duration_R1(condition==1))],[nanstd(contact_duration_Fam(condition==1))/sqrt(sum(condition==1)),nanstd(contact_duration_R1(condition==1))/sqrt(sum(condition==1))],'k-','LineWidth',2)
set(gca,'Xtick',1:2,'Xticklabel',{'Fam','R1'})
xlim([0 3]);
ylabel('Contact duration (s)')


%% PCA biplot (Figure 1g)

final_24h=56;
figure(); hold on ; 
biplot(coeff_R1(:,1:2),'varlabels',header)
scatter(score_R1(1:final_24h,1),score_R1(1:final_24h,2),60,avoidance_index_R1(1:final_24h),'filled','MarkerEdgeCOlor','k'); 
plot([0 0],[-0.6 0.6],'k-')
plot([-0.6 0.6],[0 0],'k-')
caxis([-0.8 0.6])
colorbar

final_24h= 56;
figure();
for k=1:length(header)
subplot(3,3,k); hold on;  
scatter(score_R1(1:final_24h,1),score_R1(1:final_24h,2),60,data_to_analyse_R1_trunc(1:final_24h,k),'filled')
plot([-0.5 0.5],[0.5 -0.5],'k-'); 
plot([0.5 -0.5],[0.5 -0.5],'k-'); 
xlabel('1st PC')
ylabel('2nd PC')
title(header{k})
colormap jet
colorbar
end



%% Avoidance and avoiders comparison Fam/R1 (Figure 1i)

figure(); subplot(1,2,1); hold on; 
proportion_seuil=0; 
b=bar([sum(avoidance_index_Fam(condition==1)>proportion_seuil)/sum(condition==1) sum(avoidance_index_R1(condition==1)>proportion_seuil)/sum(condition==1) sum(avoidance_index_Fam_nSTA>proportion_seuil)/length(avoidance_index_Fam_nSTA) sum(avoidance_index_R1_nSTA>proportion_seuil)/length(avoidance_index_R1_nSTA)],'FaceColor','none') ;
ylim([0 1])
set(get(b,'Children'),'FaceAlpha',0.1)
set(gca,'xtick',[1,2,3,4],'xticklabel',{'Fam-STA','R1-STA','Fam-nSTA','R1-nSTA'})
ylabel('Proportion of avoiders')
xlim([0.5 4.5])
subplot(1,2,2); 
hold on; 
plot(1:2,[avoidance_index_Fam(condition==1),avoidance_index_R1(condition==1)],'-','Color',[0.8 0.8 0.8])
plot(3:4,[avoidance_index_Fam_nSTA,avoidance_index_R1_nSTA],'-','Color',[0.8 0.8 0.8])
errorbar(1:2,[mean(avoidance_index_Fam(condition==1)),mean(avoidance_index_R1(condition==1))],[std(avoidance_index_Fam(condition==1))/sqrt(sum(condition==1)),std(avoidance_index_R1(condition==1))/sqrt(sum(condition==1))],'k-','LineWidth',2)
errorbar(3:4,[mean(avoidance_index_Fam_nSTA),mean(avoidance_index_R1_nSTA)],[std(avoidance_index_Fam_nSTA)/sqrt(length(avoidance_index_Fam_nSTA)),std(avoidance_index_R1_nSTA)/sqrt(length(avoidance_index_R1_nSTA))],'k-','LineWidth',2)
xlim([0.5 4.5])
set(gca,'xtick',[1,2,3,4],'xticklabel',{'Fam-STA','R1-STA','Fam-nSTA','R1-nSTA'})
ylabel('Avoidance index')



%% Avoidance index vs. contact duration (Figure 1j) 

figure();
scatter(contact_duration_Fam(condition==1),active_removal_Fam(condition==1),90,avoidance_index_R1(condition==1),'filled','MarkerEdgeColor','k')
set(gca,'XScale','log')
set(gca,'YScale','log')
xlabel('Contact duration (s)')
ylabel('Time to remove (s)')
colorbar
caxis([-0.8 0.6])

figure(); 
avoidance_index_R1_subset= avoidance_index_R1(condition==1); 
contact_duration_Fam_subset = contact_duration_Fam(condition==1); 
active_removal_Fam_subset = active_removal_Fam(condition==1); 

subplot(1,2,1); 
n=sum(avoidance_index_R1_subset(contact_duration_Fam_subset<5)>0)/sum(contact_duration_Fam_subset<5);
n1=sum(avoidance_index_R1_subset(contact_duration_Fam_subset>=5 & contact_duration_Fam_subset<15)>0)/sum(contact_duration_Fam_subset>=5 & contact_duration_Fam_subset<15);
n2=sum(avoidance_index_R1_subset(contact_duration_Fam_subset>=15 & contact_duration_Fam_subset<60)>0)/sum(contact_duration_Fam_subset>=15 & contact_duration_Fam_subset<60);
n3=sum(avoidance_index_R1_subset(contact_duration_Fam_subset>=60)>0)/sum(contact_duration_Fam_subset>=60);
proportion=[n,n1,n2,n3]; 
bar(proportion);
set(gca,'xtick',1:4,'xticklabel',{'< 5s','5-15s','15-60s','>60s'}); 
ylim([0 1])

subplot(1,2,2); idx=9 ; % Active removal
n=sum(avoidance_index_R1_subset(active_removal_Fam_subset<2)>0)/sum(active_removal_Fam_subset<2);
n1=sum(avoidance_index_R1_subset(active_removal_Fam_subset>=2 & active_removal_Fam_subset<5)>0)/sum(active_removal_Fam_subset>=2 & active_removal_Fam_subset<5);
n2=sum(avoidance_index_R1_subset(active_removal_Fam_subset>=5 & active_removal_Fam_subset<15)>0)/sum(active_removal_Fam_subset>=5 & active_removal_Fam_subset<15);
n3=sum(avoidance_index_R1_subset(active_removal_Fam_subset>=15)>0)/sum(active_removal_Fam_subset>=15);
proportion=[n,n1,n2,n3]; 
bar(proportion);
set(gca,'xtick',1:4,'xticklabel',{'< 2s','2-5s','5-15s','>15s'}); 
ylim([0 1])



%% Persistence (Figure 2b-d)

figure(); 
subplot(2,1,1); hold on; variable=data_to_analyse_R1(:,1); 
scatter(condition,variable,'jitter','on')
errorbar(1:5,[nanmean(variable(condition==1)) nanmean(variable(condition==2)) nanmean(variable(condition==3)) nanmean(variable(condition==4)) nanmean(variable(condition==5))],[nanstd(variable(condition==1))/sqrt(sum(condition==1)) nanstd(variable(condition==2))/sqrt(sum(condition==2)) nanstd(variable(condition==3))/sqrt(sum(condition==3)) nanstd(variable(condition==4))/sqrt(sum(condition==4)) nanstd(variable(condition==5))/sqrt(sum(condition==5))],'k')
set(gca,'xtick',1:5,'xticklabel',{'24h','72h','1week','1month','1month+E'})
title('Latency (s)')
xlim([0 6])
subplot(2,1,2); hold on; variable=data_to_analyse_R1(:,3); 
scatter(condition,variable,'jitter','on')
errorbar(1:5,[nanmean(variable(condition==1)) nanmean(variable(condition==2)) nanmean(variable(condition==3)) nanmean(variable(condition==4)) nanmean(variable(condition==5))],[nanstd(variable(condition==1))/sqrt(sum(condition==1)) nanstd(variable(condition==2))/sqrt(sum(condition==2)) nanstd(variable(condition==3))/sqrt(sum(condition==3)) nanstd(variable(condition==4))/sqrt(sum(condition==4)) nanstd(variable(condition==5))/sqrt(sum(condition==5))],'k')
set(gca,'xtick',1:5,'xticklabel',{'24h','72h','1week','1month','1month+E'})
title('# Detours')
xlim([0 6])

variable = avoidance_index_R1; proportion_seuil=0; 
figure(); subplot(1,2,1); hold on; 
b=bar([sum(variable(condition==1)>proportion_seuil)/sum(condition==1) sum(variable(condition==2)>proportion_seuil)/sum(condition==2) sum(variable(condition==3)>proportion_seuil)/sum(condition==3)  sum(variable(condition==4)>proportion_seuil)/sum(condition==4) sum(variable(condition==5)>proportion_seuil)/sum(condition==5)],'FaceColor','none') %[0.8 0.8 0.8])  
ylim([0 1])
xlim([0 6])
set(gca,'xtick',1:5,'xticklabel',{'24h','72h','1week','1month','1monthE'})
set(get(b,'Children'),'FaceAlpha',0.1)
ylabel('Proportion of avoiders')
subplot(1,2,2); hold on; 
scatter(condition,variable,'k','jitter','on')
ylabel('Avoidance index')
errorbar(1:5,[nanmean(variable(condition==1)) nanmean(variable(condition==2)) nanmean(variable(condition==3)) nanmean(variable(condition==4)) nanmean(variable(condition==5))],[nanstd(variable(condition==1))/sqrt(sum(condition==1)) nanstd(variable(condition==2))/sqrt(sum(condition==2)) nanstd(variable(condition==3))/sqrt(sum(condition==3)) nanstd(variable(condition==4))/sqrt(sum(condition==4)) nanstd(variable(condition==5))/sqrt(sum(condition==5))],'ks')
set(gca,'xtick',1:5,'xticklabel',{'24h','72h','1week','1month','1monthE'})
xlim([0 6])

figure();hold on; 
scatter(contact_duration_Fam(condition==2),active_removal_Fam(condition==2),90,avoidance_index_R1(condition==2),'filled','o','MarkerEdgeColor','k')
scatter(contact_duration_Fam(condition==3),active_removal_Fam(condition==3),90,avoidance_index_R1(condition==3),'filled','^','MarkerEdgeColor','k')
scatter(contact_duration_Fam(condition==4),active_removal_Fam(condition==4),90,avoidance_index_R1(condition==4),'filled','s','MarkerEdgeColor','k')
scatter(contact_duration_Fam(condition==5),active_removal_Fam(condition==5),90,avoidance_index_R1(condition==5),'filled','d','MarkerEdgeColor','k')
set(gca,'XScale','log')
set(gca,'YScale','log')
xlabel('Contact duration (s)')
ylabel('Time-to-remove (s)')
colorbar
caxis([-0.8 0.6])



% Figure for KO data & pharmacology (CB1 or D2; NMDA canules)
clear

CB1=0; 
D2=1; 
NMDA=1;

if CB1==1 
    opts = spreadsheetImportOptions("NumVariables", 41);
    opts.Sheet = "Data_CB1";
    opts.DataRange = "A4:AO52";
    opts.VariableNames = ["Mousename", "Sexe", "Strain", "Age", "DOB", "DOT", "NB", "Condition", "Latencybeforecontacts", "sniffingsneartape", "detoursneartape", "Uturnsneartape", "sidepassages", "speedbeforecontactcms", "ontactactivity", "contactgaze", "initialzoneofcontact", "Avoidanceindex", "durationofcontacts", "timetoremoves", "Latencybeforecontacts1", "sniffingsneartape1", "detoursneartape1", "Uturnsneartape1", "sidepassages1", "speedbeforecontactcms1", "ontactactivity1", "contactgaze1", "initialzoneofcontact1", "Avoidanceindex1", "durationofcontacts1", "Latencybeforecontacts2", "sniffingsneartape2", "detoursneartape2", "Uturnsneartape2", "sidepassages2", "speedbeforecontactcms2", "ontactactivity2", "contactgaze2", "initialzoneofcontact2", "Avoidanceindex2"];
    opts.VariableTypes = ["string", "categorical", "categorical", "double", "datetime", "datetime", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
    opts = setvaropts(opts, ["Mousename", "NB"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Mousename", "Sexe", "Strain", "NB"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "DOB", "InputFormat", "");
    opts = setvaropts(opts, "DOT", "InputFormat", "");
    Behaviour_data = readtable("/Users/charlotte.piette/Dropbox/Data_availability/Data_Behavior.xlsx", opts, "UseExcel", false);
    clear opts 
elseif D2==1
    opts = spreadsheetImportOptions("NumVariables", 41);
    opts.Sheet = "Data_D2";
    opts.DataRange = "A4:AO69";
    opts.VariableNames = ["Mousename", "Sexe", "Strain", "Age", "DOB", "DOT", "NB", "Condition", "Latencybeforecontacts", "sniffingsneartape", "detoursneartape", "Uturnsneartape", "sidepassages", "speedbeforecontactcms", "ontactactivity", "contactgaze", "initialzoneofcontact", "Avoidanceindex", "durationofcontacts", "timetoremoves", "Latencybeforecontacts1", "sniffingsneartape1", "detoursneartape1", "Uturnsneartape1", "sidepassages1", "speedbeforecontactcms1", "ontactactivity1", "contactgaze1", "initialzoneofcontact1", "Avoidanceindex1", "durationofcontacts1", "Latencybeforecontacts2", "sniffingsneartape2", "detoursneartape2", "Uturnsneartape2", "sidepassages2", "speedbeforecontactcms2", "ontactactivity2", "contactgaze2", "initialzoneofcontact2", "Avoidanceindex2"];
    opts.VariableTypes = ["string", "categorical", "categorical", "double", "datetime", "datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
    opts = setvaropts(opts, ["Mousename"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Mousename", "Sexe", "Strain"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "DOB", "InputFormat", "");
    opts = setvaropts(opts, "DOT", "InputFormat", "");
    Behaviour_data = readtable("/Users/charlotte.piette/Dropbox/Data_availability/Data_Behavior.xlsx", opts, "UseExcel", false);
    clear opts
elseif NMDA==1 
    opts = spreadsheetImportOptions("NumVariables", 42);
    opts.Sheet = "Data_Canula_AP5";
    opts.DataRange = "A4:AP30";
    opts.VariableNames = ["Mousename", "Sexe", "StrainConditionWT", "Age", "DOB", "DOT", "NB", "Condition", "Latencybeforecontacts", "sniffingsneartape", "detoursneartape", "Uturnsneartape", "sidepassages", "speedbeforecontactcms", "ontactactivity", "contactgaze", "initialzoneofcontact", "Avoidanceindex", "durationofcontacts", "timetoremoves", "Latencybeforecontacts1", "sniffingsneartape1", "detoursneartape1", "Uturnsneartape1", "sidepassages1", "speedbeforecontactcms1", "ontactactivity1", "contactgaze1", "initialzoneofcontact1", "Avoidanceindex1", "durationofcontacts1", "Latencybeforecontacts2", "sniffingsneartape2", "detoursneartape2", "Uturnsneartape2", "sidepassages2", "speedbeforecontactcms2", "ontactactivity2", "contactgaze2", "initialzoneofcontact2", "Avoidanceindex2", "VarName42"];
    opts.VariableTypes = ["string", "categorical", "categorical", "double", "datetime", "datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "double"];
    opts = setvaropts(opts, ["Mousename"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Mousename", "Sexe", "StrainConditionWT"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "DOB", "InputFormat", "");
    opts = setvaropts(opts, "DOT", "InputFormat", "");
    Behaviour_data = readtable("/Users/charlotte.piette/Dropbox/Data_availability/Data_Behavior.xlsx", opts, "UseExcel", false);
    clear opts   
end
    
condition=table2array(Behaviour_data(:,8)); 
idx_Ctrl=condition==0; 
idx_Cre=condition==1; 

duree_contact_Fam = table2array(Behaviour_data(:,19)); 
duree_retrait_Fam = table2array(Behaviour_data(:,20)); 
contact_court = duree_contact_Fam<=25; 
contact_long = duree_contact_Fam>25; 

n_short_ctrl = sum(condition==0 & contact_court)
n_short_ko = sum(condition==1 & contact_court)
n_long_ctrl = sum(condition==0 & contact_long)
n_long_ko = sum(condition==1 & contact_long)


data_to_analyse_Fam = table2array(Behaviour_data(:,9:17)); 
data_to_analyse_R1 = table2array(Behaviour_data(:,21:29)); 
data_to_analyse_R2 = table2array(Behaviour_data(:,32:40)); 


data_to_analyse_Fam_trunc=data_to_analyse_Fam;
data_to_analyse_Fam_trunc(data_to_analyse_Fam(:,2)>=2,2)=2; 
data_to_analyse_Fam_trunc(data_to_analyse_Fam(:,3)>=2,3)=2; 
data_to_analyse_Fam_trunc(data_to_analyse_Fam(:,4)>=1,4)=1; 
data_to_analyse_Fam_trunc(data_to_analyse_Fam(:,5)>=2,5)=2; 
data_to_analyse_Fam_trunc(isnan(data_to_analyse_Fam(:,6)),6)=0;

data_to_analyse_R1_trunc=data_to_analyse_R1;
data_to_analyse_R1_trunc(data_to_analyse_R1(:,2)>=2,2)=2; 
data_to_analyse_R1_trunc(data_to_analyse_R1(:,3)>=2,3)=2; 
data_to_analyse_R1_trunc(data_to_analyse_R1(:,4)>=1,4)=1; 
data_to_analyse_R1_trunc(data_to_analyse_R1(:,5)>=2,5)=2; 
data_to_analyse_R1_trunc(isnan(data_to_analyse_R1(:,6)),6)=0;

data_to_analyse_R2_trunc=data_to_analyse_R2;
data_to_analyse_R2_trunc(data_to_analyse_R2(:,2)>=2,2)=2; 
data_to_analyse_R2_trunc(data_to_analyse_R2(:,3)>=2,3)=2; 
data_to_analyse_R2_trunc(data_to_analyse_R2(:,4)>=1,4)=1; 
data_to_analyse_R2_trunc(data_to_analyse_R2(:,5)>=2,5)=2; 
data_to_analyse_R2_trunc(isnan(data_to_analyse_R2(:,6)),6)=0;


% Compute performance index: 
cd('/Volumes/POSTDOC/THESE/ARTICLE_ONE_SHOT/Behaviour_analysis_scoring')
load('PCA_R1_parameters.mat')

norm_data_R1 = (data_to_analyse_R1_trunc-mu)./std_pca; 
new_coord_R1 = norm_data_R1*coeff_R1; 
new_coord_R1(:,1) = new_coord_R1(:,1)/(max(score_R1_not_norm(:,1))-min(score_R1_not_norm(:,1))); 
new_coord_R1(:,2) = new_coord_R1(:,2)/(max(score_R1_not_norm(:,2))-min(score_R1_not_norm(:,2))); 
R1_pca_index_1 = new_coord_R1(:,1) - new_coord_R1(:,2);
R1_pca_index_2 = new_coord_R1(:,1) + new_coord_R1(:,2);
performance_score_R1 = a1*R1_pca_index_1 +a2*R1_pca_index_2 ; 

norm_data_R2 = (data_to_analyse_R2_trunc-mu)./std_pca; 
new_coord_R2 = norm_data_R2*coeff_R1; 
new_coord_R2(:,1) = new_coord_R2(:,1)/(max(score_R1_not_norm(:,1))-min(score_R1_not_norm(:,1))); 
new_coord_R2(:,2) = new_coord_R2(:,2)/(max(score_R1_not_norm(:,2))-min(score_R1_not_norm(:,2))); 
R2_pca_index_1 = new_coord_R2(:,1) - new_coord_R2(:,2);
R2_pca_index_2 = new_coord_R2(:,1) + new_coord_R2(:,2);
performance_score_R2 = a1*R2_pca_index_1 +a2*R2_pca_index_2 ; 


norm_data_Fam = (data_to_analyse_Fam_trunc-mu)./std_pca; 
new_coord_Fam = norm_data_Fam*coeff_R1; 
new_coord_Fam(:,1) = new_coord_Fam(:,1)/(max(score_R1_not_norm(:,1))-min(score_R1_not_norm(:,1))); 
new_coord_Fam(:,2) = new_coord_Fam(:,2)/(max(score_R1_not_norm(:,2))-min(score_R1_not_norm(:,2))); 
Fam_pca_index_1 = new_coord_Fam(:,1) - new_coord_Fam(:,2);
Fam_pca_index_2 = new_coord_Fam(:,1) + new_coord_Fam(:,2);
performance_score_Fam = a1*Fam_pca_index_1 +a2*Fam_pca_index_2 ; 


% Behavioural parameters (latency, detours)

% Avoidance index vs. contact duration
figure(); hold on; 
scatter(duree_contact_Fam,performance_score_R1,80,condition,'filled'); 
plot([0.4 1000],[0 0],'k-')
%plot([20 20],[-0.8 0.6],'k-')
plot([25 25],[-0.8 0.6],'k-')
set(gca,'XScale','log')
ylim([-0.8 0.6])
colormap jet 
ylabel('Avoidance index at R1')
xlabel('Contact duration at Fam')

figure(); 
subplot(1,2,1); hold on;
scatter(ones(sum(condition==0 & contact_court),1),performance_score_R1(condition==0 & contact_court),'jitter','on')
scatter(2*ones(sum(condition==1 & contact_court),1),performance_score_R1(condition==1 & contact_court),'jitter','on')
errorbar(1:2,[nanmean(performance_score_R1(condition==0 & contact_court)) nanmean(performance_score_R1(condition==1 & contact_court))],[nanstd(performance_score_R1(condition==0 & contact_court))/sqrt(sum(condition==0 & contact_court)) nanstd(performance_score_R1(condition==1 & contact_court))/sqrt(sum(condition==1 & contact_court))],'ks','LineStyle','none')
scatter(3*ones(sum(condition==0 & contact_long),1),performance_score_R1(condition==0 & contact_long),'jitter','on')
scatter(4*ones(sum(condition==1 & contact_long),1),performance_score_R1(condition==1 & contact_long),'jitter','on')
errorbar(3:4,[nanmean(performance_score_R1(condition==0 & contact_long)) nanmean(performance_score_R1(condition==1 & contact_long))],[nanstd(performance_score_R1(condition==0 & contact_long))/sqrt(sum(condition==0 & contact_long)) nanstd(performance_score_R1(condition==1 & contact_long))/sqrt(sum(condition==1 & contact_long))],'ks','LineStyle','none')
set(gca,'xtick',[1,2,3,4],'xticklabel',{'Ctrl short','KO short','Ctrl long','KO long'})
ylabel('Avoidance index')
ylim([-0.8 0.6])
xlim([0.5 4.5])
subplot(1,2,2);  
b=bar([sum(performance_score_R1(condition==0 & contact_court)>0)/sum(condition==0 & contact_court);sum(performance_score_R1(condition==1 & contact_court)>0)/sum(condition==1 & contact_court);  sum(performance_score_R1(condition==0 & contact_long)>0)/sum(condition==0 & contact_long);sum(performance_score_R1(condition==1 & contact_long)>0)/sum(condition==1 & contact_long)],'FaceColor','none'); 
set(gca,'xtick',[1,2,3,4],'xticklabel',{'Ctrl short','KO short','Ctrl long','KO long'})
set(get(b,'Children'),'FaceAlpha',0.1)
xlim([0.5 4.5])
ylim([0 1])
ylabel('Proportion of avoiders')


figure(); subplot(1,2,1); hold on;
plot(1:3,[performance_score_Fam(condition==0 & contact_court) performance_score_R1(condition==0 & contact_court) performance_score_R2(condition==0 & contact_court)],'b-'); 
errorbar(1:3,[nanmean(performance_score_Fam(condition==0 & contact_court)) nanmean(performance_score_R1(condition==0 & contact_court)) nanmean(performance_score_R2(condition==0 & contact_court))],[nanstd(performance_score_Fam(condition==0 & contact_court))/sqrt(sum(condition==0 & contact_court)) nanstd(performance_score_R1(condition==0 & contact_court))/sqrt(sum(condition==0 & contact_court)) nanstd(performance_score_R2(condition==0 & contact_court))/sqrt(sum(condition==0 & contact_court))],'ks-','LineWidth',2)
plot(1:3,[performance_score_Fam(condition==1 & contact_court) performance_score_R1(condition==1 & contact_court) performance_score_R2(condition==1 & contact_court)],'r-'); 
errorbar(1:3,[nanmean(performance_score_Fam(condition==1 & contact_court)) nanmean(performance_score_R1(condition==1 & contact_court)) nanmean(performance_score_R2(condition==1 & contact_court))],[nanstd(performance_score_Fam(condition==1 & contact_court))/sqrt(sum(condition==1 & contact_court)) nanstd(performance_score_R1(condition==1 & contact_court))/sqrt(sum(condition==1 & contact_court)) nanstd(performance_score_R2(condition==1 & contact_court))/sqrt(sum(condition==1 & contact_court))],'ms-','LineWidth',2)
set(gca,'Xtick',1:3,'Xticklabel',{'Fam','R1','R2'})
xlim([0.5 3.5])
ylim([-0.8 0.6])
ylabel('Avoidance index')
title('Short contact')
subplot(1,2,2); hold on; 
plot(1:3,[performance_score_Fam(condition==0 & contact_long) performance_score_R1(condition==0 & contact_long) performance_score_R2(condition==0 & contact_long)],'b-'); 
errorbar(1:3,[nanmean(performance_score_Fam(condition==0 & contact_long)) nanmean(performance_score_R1(condition==0 & contact_long)) nanmean(performance_score_R2(condition==0 & contact_long))],[nanstd(performance_score_Fam(condition==0 & contact_long))/sqrt(sum(condition==0 & contact_long)) nanstd(performance_score_R1(condition==0 & contact_long))/sqrt(sum(condition==0 & contact_long)) nanstd(performance_score_R2(condition==0 & contact_long))/sqrt(sum(condition==0 & contact_long))],'ks-','LineWidth',2)
plot(1:3,[performance_score_Fam(condition==1 & contact_long) performance_score_R1(condition==1 & contact_long) performance_score_R2(condition==1 & contact_long)],'r-'); 
errorbar(1:3,[nanmean(performance_score_Fam(condition==1 & contact_long)) nanmean(performance_score_R1(condition==1 & contact_long)) nanmean(performance_score_R2(condition==1 & contact_long))],[nanstd(performance_score_Fam(condition==1 & contact_long))/sqrt(sum(condition==1 & contact_long)) nanstd(performance_score_R1(condition==1 & contact_long))/sqrt(sum(condition==1 & contact_long)) nanstd(performance_score_R2(condition==1 & contact_long))/sqrt(sum(condition==1 & contact_long))],'ms-','LineWidth',2)
set(gca,'Xtick',1:3,'Xticklabel',{'Fam','R1','R2'})
ylabel('Avoidance index')
title('Long contact')
xlim([0.5 3.5])
ylim([-0.8 0.6])


figure();
subplot(1,3,1); hold on; % Latency
scatter(ones(sum(condition==0 & contact_court),1),data_to_analyse_R1(condition==0 & contact_court,1),'jitter','on'); 
scatter(2*ones(sum(condition==1 & contact_court),1),data_to_analyse_R1(condition==1 & contact_court,1),'jitter','on'); 
scatter(3*ones(sum(condition==0 & contact_long),1),data_to_analyse_R1(condition==0 & contact_long,1),'jitter','on'); 
scatter(4*ones(sum(condition==1 & contact_long),1),data_to_analyse_R1(condition==1 & contact_long,1),'jitter','on'); 
errorbar(1:4,[nanmean(data_to_analyse_R1(condition==0 & contact_court,1)) nanmean(data_to_analyse_R1(condition==1 & contact_court,1)) nanmean(data_to_analyse_R1(condition==0 & contact_long,1)) nanmean(data_to_analyse_R1(condition==1 & contact_long,1))],[nanstd(data_to_analyse_R1(condition==0 & contact_court,1))/sqrt(sum(condition==0 & contact_court)) nanstd(data_to_analyse_R1(condition==1 & contact_court,1))/sqrt(sum(condition==1 & contact_court)) nanstd(data_to_analyse_R1(condition==0 & contact_long,1))/sqrt(sum(condition==0 & contact_long)) nanstd(data_to_analyse_R1(condition==1 & contact_long,1))/sqrt(sum(condition==1 & contact_long))],'ks','LineStyle','none')
set(gca,'xtick',1:4,'xticklabel',{'Ctrl Short','Cre Short','Ctrl Long','Cre Long'})
xlim([0.5 4.5])
title("Latency before contact (s)")
subplot(1,3,2); hold on; % Detours
scatter(ones(sum(condition==0 & contact_court),1),data_to_analyse_R1(condition==0 & contact_court,3),'jitter','on'); 
scatter(2*ones(sum(condition==1 & contact_court),1),data_to_analyse_R1(condition==1 & contact_court,3),'jitter','on'); 
scatter(3*ones(sum(condition==0 & contact_long),1),data_to_analyse_R1(condition==0 & contact_long,3),'jitter','on'); 
scatter(4*ones(sum(condition==1 & contact_long),1),data_to_analyse_R1(condition==1 & contact_long,3),'jitter','on'); 
errorbar(1:4,[nanmean(data_to_analyse_R1(condition==0 & contact_court,3)) nanmean(data_to_analyse_R1(condition==1 & contact_court,3)) nanmean(data_to_analyse_R1(condition==0 & contact_long,3)) nanmean(data_to_analyse_R1(condition==1 & contact_long,3))],[nanstd(data_to_analyse_R1(condition==0 & contact_court,3))/sqrt(sum(condition==0 & contact_court)) nanstd(data_to_analyse_R1(condition==1 & contact_court,3))/sqrt(sum(condition==1 & contact_court)) nanstd(data_to_analyse_R1(condition==0 & contact_long,3))/sqrt(sum(condition==0 & contact_long)) nanstd(data_to_analyse_R1(condition==1 & contact_long,3))/sqrt(sum(condition==1 & contact_long))],'ks','LineStyle','none')
set(gca,'xtick',1:4,'xticklabel',{'Ctrl Short','Cre Short','Ctrl Long','Cre Long'})
xlim([0.5 4.5])
title("# detours")
subplot(1,3,3); hold on; % Detours
b=bar([sum(data_to_analyse_R1(condition==0 & contact_court,3)>=2)/sum(condition==0 & contact_court);sum(data_to_analyse_R1(condition==1 & contact_court,3)>=2)/sum(condition==1 & contact_court);  sum(data_to_analyse_R1(condition==0 & contact_long,3)>=2)/sum(condition==0 & contact_long);sum(data_to_analyse_R1(condition==1 & contact_long,3)>=2)/sum(condition==1 & contact_long)],'FaceColor','none'); 
set(get(b,'Children'),'FaceAlpha',0.1)
set(gca,'xtick',1:4,'xticklabel',{'Ctrl Short','Cre Short','Ctrl Long','Cre Long'})
xlim([0.5 4.5])
title("% detours >=2")


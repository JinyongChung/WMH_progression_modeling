%% Calculate WMH severity and run SuStaIn modeling
clear all; close all; clc;

% Calculate WMH severity based on low-risk controls (n=13,811) from UK Biobank
load('Dataset2.mat'); % Input WMH volume data in **mL**
% Check WMH ROIs: MNI_ch2better_WM_20ROIs.nii
% BG: 1 2 3 4
% Frontal: 5 6 7 8
% Occipital:9 10 11 12
% Temporal: 13 14 15 16
% Parietal: 17 18 19 20
load('Residual_Info.mat'); % Pre-speicifed (based on low-risk controls (n=13,811) from UK Biobank) mean and standard deviation of residuals to normalize WMH volume into WMH severity (z-score)

% Calculate WMH severity
WMHsv_stroke = Calculate_WMH_severity_based_on_UKBiobank(AGE_stroke, SEX_stroke, WMHv_stroke, Mean_SD_of_Residual_Male, Mean_SD_of_Residual_Female);

% Load the 3-subtype model
load('3-subtype_model\WMH_SuStaIn_setting.mat');
load('3-subtype_model\WMH_MCMC_3Seq.mat');

% Calculate individual subtype and stage likelihood across 100,000 MCMCs
addpath SuStaInMatlab-master\SuStaInFunctions

data = WMHsv_stroke;
loglike = zeros(size(samples_likelihood,1),1);
total_prob_subj = zeros(size(data,1),1);
total_prob_stage = zeros(size(data,1),size(stage_zscore,2)+1);
total_prob_cluster = zeros(size(data,1),size(samples_f,1));
parfor mcmc = 1:size(samples_likelihood,1)
    [loglike(mcmc),total_prob_subj_temp,total_prob_stage_temp,total_prob_cluster_temp,p_perm_k] = ...
        calculate_likelihood_MixtureLinearZscoreModels(data,...
        min_biomarker_zscore,max_biomarker_zscore,std_biomarker_zscore,...
        stage_zscore,stage_biomarker_index,samples_sequence(:,:,mcmc),samples_f(:,mcmc),likelihood_flag);
    total_prob_subj = total_prob_subj + (total_prob_subj_temp);
    total_prob_stage = total_prob_stage + (total_prob_stage_temp);
    total_prob_cluster = total_prob_cluster + (total_prob_cluster_temp);
    mcmc
end

% Assign maximum likelihood subtype and stage for individual
[maxnum Subtype_idx] = max(total_prob_cluster'); Subtype_idx = Subtype_idx';
[maxnum Stage_idx] = max(total_prob_stage'); Stage_idx = Stage_idx'; Stage_idx = Stage_idx-1;
save('Individual_Subtype_Stage.mat','Subtype_idx','Stage_idx');
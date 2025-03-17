%% Calculate WMH severity and run SuStaIn modeling
clear all; close all; clc;


% % Calculate WMH severity based on new controls
% load('Dataset1.mat'); % WMHv: ROI-wise WMH volume (in **voxel count**, 2mmX2mmX6mm), AGE: chronological age (year), SEX: women (0) and men (1), GROUP: control (0) and stroke (1)
% % Check WMH ROIs: MNI_ch2better_WM_20ROIs.nii
% % BG: 1 2 3 4
% % Frontal: 5 6 7 8
% % Occipital:9 10 11 12
% % Temporal: 13 14 15 16
% % Parietal: 17 18 19 20
% WMHsv = Calculate_WMH_severity(AGE, SEX, WMHv, GROUP);
% WMHsv_stroke = WMHsv(GROUP==1,:);

% or %

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

% Run SuStaIn modeling; https://github.com/ucl-pond/SuStaInMatlab?tab=readme-ov-file, https://doi.org/10.1038/s41467-018-05892-0.
addpath SuStaInMatlab-master\SuStaInFunctions

N_startpoints = 25;
N_stage = 1;
N_S_max = 5;
N_iterations_MCMC = 1e6;
likelihood_flag = 'Exact';
output_folder = 'Model1'; mkdir([cd '\Model1']);
dataset_name = 'WMHsv';

stage_zscore = [ones(1,size(WMHsv_stroke,2))*1.5];
min_biomarker_zscore = [ones(1,size(WMHsv_stroke,2))*0];
max_biomarker_zscore = [ones(1,size(WMHsv_stroke,2))*median(quantile(WMHsv_stroke,0.95))];

std_biomarker_zscore = [ones(1,size(WMHsv_stroke,2))];
stage_biomarker_index = repmat([1:size(WMHsv_stroke,2)],[1 N_stage]);

run_SuStaIn_algorithm(WMHsv_stroke,...
min_biomarker_zscore,max_biomarker_zscore,std_biomarker_zscore,...
stage_zscore,stage_biomarker_index,N_startpoints,N_S_max,N_iterations_MCMC,...
likelihood_flag,output_folder,dataset_name);

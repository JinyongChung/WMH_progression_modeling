%% Calculate WMH severity and run SuStaIn modeling
clear all; close all; clc;

% Load sample data
load('Dataset1.mat'); % WMHv: ROI-wise WMH volume (voxel count, 2mmX2mmX6mm), AGE: chronological age (year), SEX: women (0) and men (1), GROUP: control (0) and stroke (1)
% Check WMH ROIs: MNI_ch2better_WM_20ROIs.nii

% Calculate WMH severity
WMHsv = Calculate_WMH_severity(AGE, SEX, WMHv, GROUP);

WMHsv_stroke = WMHsv(GROUP==1,:);

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

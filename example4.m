%% Bullseye presentation
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

% Load risk factors
load('Dataset3.mat'); % Risk factors of stroke patietns; Column 1~6 = HTN: hypertension, DM: diabetes, HL: hyperlipidemia, SMK: current smoking, AF: atrial fibrillation, CAD: coronary heart disease, CENTER: Imaging center

SubtypeNum = 3; % Number of Subtype
load('Individual_Subtype_Stage.mat','Subtype_idx','Stage_idx'); % Saved from example2.m

% Combine all variables in a table
PARAMS = [Subtype_idx Stage_idx AGE_stroke SEX_stroke Risk_factors];
PARAMS_T = array2table(PARAMS, 'VariableNames', {'Subtype','Stage','AGE','SEX','HTN','DM','HL','SMK','AF','CAD','CENTER'});
PARAMS_T.Subtype = categorical(PARAMS_T.Subtype);
PARAMS_T.SEX = categorical(PARAMS_T.SEX);

% linear mixed-effects regressions for each risk factor
PARAMS_T_excludeS0 = PARAMS_T(PARAMS_T.Stage>0,:);
glme1 = fitglme(PARAMS_T_excludeS0, 'HTN ~ 1 + Subtype + Stage + AGE + SEX + (1|CENTER)','Distribution','binomial');
glme2 = fitglme(PARAMS_T_excludeS0, 'HTN ~ 1 + Subtype*Stage + AGE + SEX + (1|CENTER)','Distribution','binomial');
glme3 = fitglme(PARAMS_T_excludeS0, 'HTN ~ 1 + Subtype + Stage + Stage*Stage + AGE + SEX + (1|CENTER)','Distribution','binomial');
glme4 = fitglme(PARAMS_T_excludeS0, 'HTN ~ 1 + Subtype*Stage + Stage*Stage + AGE + SEX + (1|CENTER)','Distribution','binomial');
glme = {glme1,glme2,glme3,glme4};

% Evaluate AICs
AICs = [glme{1}.ModelCriterion{1,1} glme{2}.ModelCriterion{1,1} glme{3}.ModelCriterion{1,1} glme{4}.ModelCriterion{1,1}];

% Find the best model
[minval minidx] = min(AICs)
glme{minidx}
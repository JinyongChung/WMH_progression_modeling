%% Bullseye visualization of WMH severity
clear all; close all; clc;

% Calculate WMH severity
load('Dataset1.mat'); % WMHv: ROI-wise WMH volume (mL), Check WMH ROIs: MNI_ch2better_WM_20ROIs.nii
% BG: 1 2 3 4
% Frontal: 5 6 7 8
% Occipital:9 10 11 12
% Temporal: 13 14 15 16
% Parietal: 17 18 19 20

WMHsv = Calculate_WMH_severity(AGE, SEX, WMHv, GROUP);

WMHsv_stroke = WMHsv(GROUP==1,:);

SubtypeNum = 3; % Number of Subtype
load('Individual_Subtype_Stage.mat','Subtype_idx','Stage_idx'); % Saved from example2.m

% Bullseye presentation
addpath bullseye % From Daniel Ennis (2025). Bullseye Polar Data Plot (https://www.mathworks.com/matlabcentral/fileexchange/16458-bullseye-polar-data-plot), MATLAB Central File Exchange.

data = WMHsv_stroke;
% BG: 1 2 3 4
% Frontal: 5 6 7 8
% Occipital:9 10 11 12
% Temporal: 13 14 15 16
% Parietal: 17 18 19 20

% Colormap
cmap = zeros(100,3);
cmap(1:15,:) = repmat([1 1 1],[15 1]);
cmap(15+[1:16]+16*0,:) = repmat([255 255 128]/255,[16 1]);
cmap(15+[1:16]+16*1,:) = repmat([255 255 0]/255,[16 1]);
cmap(15+[1:16]+16*2,:) = repmat([253 193 0]/255,[16 1]);
cmap(15+[1:16]+16*3,:) = repmat([247 150 71]/255,[16 1]);
cmap(15+[1:16]+16*4,:) = repmat([251 107 36]/255,[16 1]);
cmap(15+[1:5]+16*5,:) = repmat([1 0 0],[5 1]);

% Bullseyemaps of median WMH severity for each subtype
figure;
for st = 1:SubtypeNum
    temp = median(data(Subtype_idx==st,:));
    eventstage = zeros(1,4);
    eventstage(1,1) = temp(5);
    eventstage(1,2) = temp(6);
    eventstage(1,3) = temp(7);
    eventstage(1,4) = temp(8);
    AX = subplot(1,SubtypeNum,st); hold on;
    bullseye(eventstage,'N',100,'tht',[0 40],'rho',[1 5],'tht0',140)
    colormap(cmap); caxis([0 8.5])
    eventstage = zeros(1,4);
    eventstage(1,1) = temp(1);
    eventstage(1,2) = temp(2);
    eventstage(1,3) = temp(3);
    eventstage(1,4) = temp(4);
    bullseye(eventstage,'N',100,'tht',[0 20],'rho',[1 3],'tht0',120)
    colormap(cmap); caxis([0 8.5])
    eventstage = zeros(1,4);
    eventstage(1,1) = temp(13);
    eventstage(1,2) = temp(14);
    eventstage(1,3) = temp(15);
    eventstage(1,4) = temp(16);
    bullseye(eventstage,'N',100,'tht',[0 40],'rho',[1 5],'tht0',80)
    colormap(cmap); caxis([0 8.5])
    eventstage = zeros(1,4);
    eventstage(1,1) = temp(17);
    eventstage(1,2) = temp(18);
    eventstage(1,3) = temp(19);
    eventstage(1,4) = temp(20);
    bullseye(eventstage,'N',100,'tht',[0 40],'rho',[1 5],'tht0',40)
    colormap(cmap); caxis([0 8.5])
    eventstage = zeros(1,4);
    eventstage(1,1) = temp(9);
    eventstage(1,2) = temp(10);
    eventstage(1,3) = temp(11);
    eventstage(1,4) = temp(12);
    bullseye(eventstage,'N',100,'tht',[0 40],'rho',[1 5],'tht0',0)
    colormap(cmap); caxis([0 8.5])
end


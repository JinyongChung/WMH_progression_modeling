function [WMHseverity_ROIwise] = Calculate_WMH_severity_based_on_UKBiobank(AGE, SEX, WMHv, Mean_SD_of_Residual_Male, Mean_SD_of_Residual_Female)

% Stratification by sex
sidx_m = find(SEX==1);
sidx_w = find(SEX==2);

WMHseverity_ROIwise = zeros(size(WMHv));

% Calculate WMH severity in Men
for ROInum = 1:size(WMHseverity_ROIwise,2)
WMHseverity_ROIwise(sidx_m,ROInum) = (WMHv(sidx_m,ROInum)-Mean_SD_of_Residual_Male(ROInum,1))./Mean_SD_of_Residual_Male(ROInum,2);
end
% Calculate WMH severity in Women
for ROInum = 1:size(WMHseverity_ROIwise,2)
WMHseverity_ROIwise(sidx_w,ROInum) = (WMHv(sidx_w,ROInum)-Mean_SD_of_Residual_Female(ROInum,1))./Mean_SD_of_Residual_Female(ROInum,2);
end

end




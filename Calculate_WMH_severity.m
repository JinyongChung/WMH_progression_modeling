function [WMHseverity_ROIwise] = Calculate_WMH_severity(AGE, SEX, WMHv, GROUP)

AGE_control = AGE(GROUP==0);
AGE_stroke = AGE(GROUP==1);
SEX_control = SEX(GROUP==0);
SEX_stroke = SEX(GROUP==1);

WMHvolume_ROIwise_control = WMHv(GROUP==0,:);
WMHvolume_ROIwise_stroke = WMHv(GROUP==1,:);

% Stratification by sex
sidx_m_stroke = find(SEX_stroke==1);
sidx_w_stroke = find(SEX_stroke==2);
sidx_m_control = find(SEX_control==1);
sidx_w_control = find(SEX_control==2);

WMHseverity_ROIwise_stroke = zeros(size(WMHvolume_ROIwise_stroke));
WMHseverity_ROIwise_control = zeros(size(WMHvolume_ROIwise_control));

% Calculate WMH severity in Men
for ROInum = 1:size(WMHvolume_ROIwise_control,2)
tb_control = table(AGE_control,WMHvolume_ROIwise_control(:,ROInum),'VariableNames',{'AGE','WMHv'});
tb_control = tb_control(sidx_m_control,:);
glme = fitglme(tb_control, 'WMHv ~ 1 + AGE','Link','log','Distribution','Poisson','FitMethod','Laplace'); % ROI-wise poisson mixed-effects regression model
resid_control = residuals(glme); % residuals: AGE-adjusted WMH volume
WMHseverity_ROIwise_stroke(sidx_m_stroke,ROInum) = (WMHvolume_ROIwise_stroke(sidx_m_stroke,ROInum)-mean(resid_control))./std(resid_control);
WMHseverity_ROIwise_control(sidx_m_control,ROInum) = (WMHvolume_ROIwise_control(sidx_m_control,ROInum)-mean(resid_control))./std(resid_control);
end
% Calculate WMH severity in Women
for ROInum = 1:size(WMHvolume_ROIwise_control,2)
tb_control = table(AGE_control,WMHvolume_ROIwise_control(:,ROInum),'VariableNames',{'AGE','WMHv'});
tb_control = tb_control(sidx_w_control,:);
glme = fitglme(tb_control, 'WMHv ~ 1 + AGE','Link','log','Distribution','Poisson','FitMethod','Laplace'); % ROI-wise poisson mixed-effects regression model
resid_control = residuals(glme); % residuals: AGE-adjusted WMH volume
WMHseverity_ROIwise_stroke(sidx_w_stroke,ROInum) = (WMHvolume_ROIwise_stroke(sidx_w_stroke,ROInum))./std(resid_control);
WMHseverity_ROIwise_control(sidx_w_control,ROInum) = (WMHvolume_ROIwise_control(sidx_w_control,ROInum))./std(resid_control);
end

WMHseverity_ROIwise = cat(1,WMHseverity_ROIwise_control,WMHseverity_ROIwise_stroke);  

end




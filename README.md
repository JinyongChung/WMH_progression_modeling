## These are codes and resources for the study "Distinct Spatiotemporal Patterns of White Matter Hyperintensity Progression".

For SuStaIn modeling, we utilized source codes ("SuStaInMatlab-master"; https://github.com/ucl-mig/SuStaInMatlab) developed by Young et al. (https://doi.org/10.1038/s41467-018-05892-0).

For bullseye presentation, we utilized MATLAB toolbox ("bullseye"; https://www.mathworks.com/matlabcentral/fileexchange/16458-bullseye-polar-data-plot) developed by Daniel Ennis.

---

## **Examples**

**example1.m**: Calculate WMH severity from WMH volume (based on new controls or low-risk controls [n=13,811] from UK Biobank and run SuStaIn modeling

**example2.m**: Individual staging and subtyping, based on the 3-subtype model developed by this study

**example3.m**: Bullseye presentation

**example4.m**: Mixed-effects regression for risk factors across subtypes and stages

---

## **Resources**

**Dataset1.mat**: Sample data 1

**Dataset2.mat**: Sample data 2

**Dataset3.mat**: Risk factors for Sample data 2

**Residual_info.mat**: Pre-calculated (based on low-risk controls [n=13,811] from UK Biobank) mean and standard deviation of residuals to normalize WMH volume into WMH severity (z-score)

**3-subtype_model**: 3-subtype model developed by this study through SuStaIn modeling

**MNI_ch2better_WM_20ROIs.nii.gz**: 20 ROIs from WM parcellation in MNI space (0.5mm X 0.5mm X 0.5mm)

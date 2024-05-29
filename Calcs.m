function [out1] = Calcs(tab1)

%% Variables and Calculations
    plot = tab1.plot;
    
    percentDry = tab1.d_wt_SS1./tab1.g_wt_SS1;
    d_wt_S = percentDry .* tab1.g_wt_S;
    nPl_S = tab1.nPl_S;
    nPl_SS2 = tab1.nPl_SS2;
    invA = 1 ./ tab1.area;
    %SS2 data 
    leafPercentDry = tab1.d_leaf_SSS1 ./ tab1.g_leaf_SSS1;
    d_leaf_SS2 = tab1.g_leaf_SS2 .* leafPercentDry;
    d_leaf_SS2(isnan(d_leaf_SS2))=0;

    d_stem_SS2 = tab1.d_stem_SS2;
    d_dead_SS2 = tab1.d_dead_SS2;
    d_bud_SS2 = tab1.d_bud_SS2;
    d_pod_SS2 = tab1.d_pod_SS2;
    nBud_SS2 = tab1.nBud_SS2;
    nPod_SS2 = tab1.nPod_SS2;

    d_tot_SS2 = d_leaf_SS2 + d_stem_SS2 + d_dead_SS2 + d_bud_SS2 + d_pod_SS2;

    d_leaf_SSS2 = tab1.g_leaf_SSS2 .* leafPercentDry;

    SS2percentS = d_tot_SS2 ./ d_wt_S;
    SS2percentDry = d_tot_SS2 ./ tab1.g_wt_SS2;
    SSS2percentSS2 = d_leaf_SSS2 ./ d_leaf_SS2;
    SSS2percentS = SSS2percentSS2 ./ SS2percentS;
    LA_SSS2 = tab1.LA_SSS2;
    
    d_leaf_S = d_leaf_SS2 ./ SS2percentS;
    d_stem_S = tab1.d_stem_SS2 ./ SS2percentS; 

        %SS2 data
    % d_stem_SS2 = tab1.d_stem_SS2;
    % d_dead_SS2 = tab1.d_dead_SS2;
    % d_bud_SS2 = tab1.d_bud_SS2;
    % d_pod_SS2 = tab1.d_pod_SS2;
    % nBud_SS2 = tab1.nBud_SS2;
    % nPod_SS2 = tab1.nPod_SS2;

    %data / m2
    d_stem_m2 = d_stem_SS2 ./ SS2percentS .* invA;
    d_leaf_m2 = d_leaf_SS2 ./ SS2percentS .* invA;
    d_dead_m2 = d_dead_SS2 ./ SS2percentS .* invA;
    d_bud_m2 = d_bud_SS2 ./ SS2percentS .* invA;
    d_pod_m2 = d_pod_SS2;
    d_pod_m2 = d_pod_SS2 ./ SS2percentS .* invA;
    nBud_m2 = nBud_SS2 ./ SS2percentS .* invA;
    nPod_m2 = nPod_SS2 ./ SS2percentS .* invA;
    
    nPl_m2_1 = round(nPl_S .* invA);
    nPl_m2_2 = round(nPl_SS2 ./ SS2percentS .* invA);

    % data / plant (from tot count)
    d_stem_pl_1 = d_stem_m2 ./ nPl_m2_1;
    d_leaf_pl_1 = d_leaf_m2 ./ nPl_m2_1;
    d_dead_pl_1 = d_dead_m2 ./ nPl_m2_1; 
    d_bud_pl_1 = d_bud_m2 ./ nPl_m2_1; 
    d_pod_pl_1 = d_pod_m2 ./ nPl_m2_1; 
    nBud_pl_1 = nBud_m2 ./ nPl_m2_1; 
    nPod_pl_1 = nPod_m2 ./ nPl_m2_1; 

        % data / plant (from tot count)
    d_stem_pl_2 = d_stem_m2 ./ nPl_m2_2;
    d_leaf_pl_2 = d_leaf_m2 ./ nPl_m2_2;
    d_dead_pl_2 = d_dead_m2 ./ nPl_m2_2; 
    d_bud_pl_2 = d_bud_m2 ./ nPl_m2_2; 
    d_pod_pl_2 = d_pod_m2 ./ nPl_m2_2; 
    nBud_pl_2 = nBud_m2 ./ nPl_m2_2; 
    nPod_pl_2 = nPod_m2 ./ nPl_m2_2; 

    % leaf area calcs
    LA_m2 = LA_SSS2 ./ SSS2percentS .* invA;
    LA_SS2 = LA_SSS2 ./ SSS2percentSS2;
    LA_pl_1 = LA_m2 ./ nPl_m2_1;
    % LA_pl_2 = LA_m2 ./ nPl_m2_2;
    LA_pl_2 = LA_SS2 ./ nPl_SS2;

    spec_LA = LA_SSS2 ./  d_leaf_SSS2;

    loc = tab1.loc;

    d_wt_m2 = d_wt_S .* invA;

    %doesn;t work, loses table headings
    % toSave = [plot, loc d_wt_m2, nPl_S, nPl_SS2, nPl_m2, ...
    %     d_stem_pl, d_leaf_pl, d_dead_pl, d_bud_pl, d_bud_pl, d_pod_pl, nBud_pl, nPod_pl,...
    %     LA_m2, LA_pl];
        % tab2 = table(toSave);

    tab2 = table(...
        plot, loc, d_wt_S, d_tot_SS2, d_wt_m2, ...
        nPl_S, nPl_SS2, nPl_m2_1, nPl_m2_2,...
        d_stem_m2, d_leaf_m2, d_bud_m2, d_pod_m2, d_dead_m2, nBud_m2, nPod_m2, ...
        d_stem_pl_1, d_leaf_pl_1, d_bud_pl_1, d_pod_pl_1, d_dead_pl_1, nBud_pl_1, nPod_pl_1, ...
        d_stem_pl_2, d_leaf_pl_2, d_bud_pl_2, d_pod_pl_2, d_dead_pl_2, nBud_pl_2, nPod_pl_2, ...
        LA_m2, LA_pl_1, LA_pl_2, spec_LA...
        );

    out1 = tab2;
end
    
    
    
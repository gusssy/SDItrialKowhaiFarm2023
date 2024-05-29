clc
%clear all
% close all

%V6
%process raw data
%split into treatments
%save as .mat file

xAxis = 1; %Treatment type
treatNames = categorical(["0.6 mm","0.9 mm", "1.2 mm", "Spray"]);
tableNames = ["Quad Cut no." "Plot No." "Cut Location" "Sample dry weight" "SS2 dry weight" "Total Dry Weight [g / m2]" "No. Plants in Sample" "No. Plants in SS2" "No. Plants / m2"];
filenames = ["cutNo", "plot", "loc", "d_wt_S", "d_wt_SS2", "d_wt_m2", "nPl_S", "nPl_SS2", "nPl_m2"];

sheets = ["Q1", "Q2", "Q3", "Q4", "Q5", "Q6","FC"];
range = [1,7];
f1 = @readRaw;
f2 = @Calcs;
f3 = @sortTreatment; %this sorts data first by treatment, then by quad cuts
QData = {};


%% get raw data and process into useful metrics
cutDays = [25, 43, 61, 79, 99, 120, 135];
for i = range(1):range(2)
    cutDay = cutDays(i);
    sheet = sheets(i);
    data = f1(sheet);
    [data2] = f2(data);
    cutNo = i .* ones(height(data2),1);
    nDays = cutDay .* ones(height(data2),1);
    % disp(cutNo)
    data2 = addvars(data2,cutNo,'Before',"plot"); %add cut number to data
    data2 = addvars(data2,nDays,'Before',"d_wt_S"); %add nDays to data
    QData(i) = {data2};
end

%% Split into treatments
T1 = {}; T2 = {}; T3 = {}; T4 = {};
for ii = range(1):range(2) % ii = Quad cuts number
    sheet = ii;
    [t1, t2, t3, t4] = f3(sheet, QData);
    T1(ii) = {t1};
    T2(ii) = {t2};
    T3(ii) = {t3};
    T4(ii) = {t4};
end
Treatments = [{T1}, {T2}, {T3}, {T4}];

% for iii = range(1):range(2) %iii = quad cut no. This then runs through
% each treatment
Data2 = {};
for iii = range(1):range(2)
    Qdata2 = table;
    for Tr = 1:4 %Tr = treatment type no.
        Tcell = Treatments{Tr};
        treatData = Tcell{iii}; %data table for treatment 'Tr'   
        treatNo = Tr .* ones(height(treatData),1);
        treatment = repmat(treatNames(Tr), height(treatData), 1);
        % disp(treatData)
        treatData = addvars(treatData,treatment,'Before',"plot"); %add treatemnt name 
        Qdata2 = vertcat(Qdata2, treatData);
    end
    Data2{iii} = Qdata2; 
end

%get all data into one file
T = vertcat(Data2{1}, Data2{2}, Data2{3}, Data2{4}, Data2{5}, Data2{6}, Data2{7});
%add index
index = [1:height(T)].';
T = addvars(T,index,'Before',"treatment");
%Add numbers for treatment types
newArray = zeros(height(T),1);
for i = 1:height(T)
    if (T.treatment(i) == 'Spray')
        newArray(i) = 4;
    elseif (T.treatment(i) == '1.2 mm')
        newArray(i) = 3;
    elseif (T.treatment(i) == '0.9 mm')
        newArray(i) = 2;
    elseif (T.treatment(i) == '0.6 mm')
        newArray(i) = 1;
    end
end
treatNo = newArray;
T = addvars(T,treatNo,'Before',"treatment");

%% Split into categorical arrays
cuts = categorical(T.cutNo);
T.cutNo = cuts;
locs = categorical(T.loc);
T.loc = locs;
plots = categorical(T.plot);
T.plot = plots;
treats = categorical(T.treatNo);
T.treatNo = treats;

%% Add seed wt data
load("yieldTable.mat");
q7ind = (double(T.cutNo) ~= 7);
q7ind = q7ind(q7ind);
q7ind = q7ind * 0;
seedWt = vertcat(q7ind, yieldTable.x1000seedWt);

T = addvars(T,seedWt,'After',"spec_LA");


%% Add water data
load qWater.mat
% 
dripInds = double(T.treatNo) == [1 2 3];
allDripInds = sum(dripInds, 2);
sprayInds = double(T.treatNo) == 4;
w = [];
for i = 1:7
    qT =  T(double(T.cutNo) == i,:);
    qDripInds = double(qT.treatNo) == [1 2 3];
    qAllDripInds = sum(qDripInds, 2);
    qSprayInds = double(qT.treatNo) == 4;
    qW = (qWater.totSpray(i) .* qSprayInds) + (qWater.totDrip(i) .* qAllDripInds);
  
    w = vertcat(w, qW);
    % if ismember(double(T.treatNo), [1 2 3])
end
waterApplied = w;
T = addvars(T, waterApplied,'Before',"plot");
d_wt_mm = T.d_wt_m2 ./ T.waterApplied;
d_wt_mm(isinf(d_wt_mm))=0;
pod_wt_mm = T.d_pod_m2 ./ T.waterApplied;
pod_wt_mm(isnan(pod_wt_mm))=0;
d_leaf_pl_mm_1 = T.d_leaf_pl_1 ./ T.waterApplied;
d_leaf_pl_mm_1(isnan(d_leaf_pl_mm_1))=0;

T = addvars(T, pod_wt_mm,'Before',"d_wt_S");
T = addvars(T, d_wt_mm,'Before',"d_wt_S");
T = addvars(T, d_leaf_pl_mm_1,'Before',"d_wt_S");

save("QcutsDataTreat.mat", 'T')

% Save to Excel
filename = "processedData.xlsx";
for iiii = 1:7
    sheetName = sheets(iiii);
    % TQ = Data2{iiii};
    TQ = T(T.cutNo == num2str(iiii),:);
    writetable(TQ,filename,'Sheet',sheetName,'WriteVariableNames',true);
end

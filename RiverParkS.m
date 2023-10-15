%% Setup
clear ; close all ; clf
data = readtable('RiverParkData2.csv'); % import data

%% Point Plotting
coord = table2array(data(:,2:3)); % create coordinates array (lat, lon)
lat = coord(:,1); % latitude array
lon = coord(:,2); % longtitude array

lat1 = 32.773; % latitude bound (southbound)
lat2 = 32.774; % latitude bound (northbound)
lon1 = -117.142; % longtitude (westbound)
lon2 = -117.135; % longitude (eastbound)

geolimits([lat1 lat2],[lon1 lon2]) % coordinate points River Park Center
geoplot(lat,lon,"ok",MarkerFaceColor="k") % plot all bird observations
title("Birds at River Park Center")
geobasemap topographic % display map type

spec = string(table2array(data(:,"scientific_name"))); % string array of species
crow = find(spec=='Corvus brachyrhynchos'); % index values of crows in data
coordc = [lat(crow),lon(crow)]; % coordincates crow observations

geolimits([lat1 lat2],[lon1 lon2]) % coordinate points River Park Center
geoplot(lat(crow,:),lon(crow,:),"ok",MarkerFaceColor="k") % plot all crow observations 
title("Crows at River Park Center")
geobasemap topographic % display map type

%% Species by Month
% Set up array of species count by month

MonthArray = month(table2array(data(:,"observed_on"))); % Converts datetime to a single number indicating month
SpeciesArray = table2array(data(:,"common_name")); % array of every species in dataset
SpecCat = string(unique(SpeciesArray)); % array of unique species names

SpecCell = cell(1,12); % preallocate species by month cell array
for i = 1:12
    SpecCell{:,i} = SpeciesArray(MonthArray == i); % Sort species data by month
end

SpecStr = string(unique(SpeciesArray)); % string array of unique species names

SpecNum = zeros(73,12); % preallocate species by month numeric array
for i = 1:12
    for j = 1:length(SpecStr)
        idx = strfind(string(categorical(SpecCell{:,i})), SpecStr(j)); % checks SpecCell for occurrance of a species name
        idx = find(not(cellfun('isempty', idx))); % checks SpecCell for lack of occurrance of a species name
        SpecNum(j,i) = length(idx); % numeric array of species occurrence by month
    end
end

%% Simple Pie Chart
% Graph pie charts of bird diversity by month

% Print pie charts for each month
for i = 1:12
    figure

    % make pie chart
    p = pie(SpecNum(:,i)); % print pie chart
    
    % remove 0% label from pie chart
    tp = findobj(p,'Type','Text'); % assign tp as default string labels for pie chart
    isSmall = startsWith({tp.String}, '0'); % find 0% labels
    set(tp(isSmall),'String', '') % set 0% labels to blank strings

    % label chart
    notzero = find(SpecNum(:,i) ~= 0); % find non-zero species entries
    pielabel = strings(size(SpecCat)); % preallocate species-within-month array
    pielabel(notzero) = SpecCat(notzero); % species-within-month array
    legend(pielabel,'Location','eastoutside') % make legend only containing species detected in that month
    title(datestr(datetime(1,i,1),'mmmm') + " bird diversity (2020 - 2023)") % make title
end

%% Exploded Pie Chart
% Pops out pie slice of a specific bird of interest 

for i = 1:12
    figure(i) % make new figure for each pie chart
    X = categorical(SpecCell{:,i}); 
    if height(find(ismember(X,'Falco peregrinus'))) > 0 % check if bird exists in month
        explode = {'Falco peregrinus'}; % declare species of interest
        pie(X,explode); % make pie chart
        title(datestr(datetime(1,i,1),'mmmm') + " bird diversity (2020 - 2023)") % make title
    else
        pie(X); % make pie chart
        title(datestr(datetime(1,i,1),'mmmm') + " bird diversity (2020 - 2023)") % make title
    end
end

%% Bar chart
% Graph total bird population by month

SpecCount = zeros(1,12); % initialize array
for i = 1:12
    SpecCount(i) = height(SpecCell{:,i}); % counts how many entries are in each SpecbyMonth column
end

bar(SpecCount) % print bar graph
set(gca,'xtick',1:12,...
 'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}) % label x-axis with months
title("Bird sightings by month (2020-2023)")
ylabel("# of birds")
xlabel("Month")

% Graph population of bird of interest by month (here, bushtit and Cooper's hawk)

Bushtit = zeros(1,12); % initialize array
Hawk = zeros(1,12) % initialize array
for i = 1:12
    titcount = find(strcmp(SpecCell{:,i}, 'Psaltriparus minimus')); % count how many times bushtit is recorded per month
    hawkcount = find(strcmp(SpecCell{:,i}, 'Accipiter cooperii')); % count how many times Cooper's hawk is recorded per month
    Bushtit(i) = length(titcount);
    Hawk(i) = length(hawkcount);
end

bar(Bushtit)
set(gca,'xtick',1:12,...
 'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}) % label x-axis with months
title("Bushtit sightings by month (2020-2023)")
ylabel("# of birds")
xlabel("Month")

bar(Hawk)
set(gca,'xtick',1:12,...
 'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}) % label x-axis with months
title("Cooper's hawk sightings by month (2020-2023)")
ylabel("# of birds")
xlabel("Month")

%% Stacked bar chart 
% here, bushtit vs Cooper's hawk populations

b1 = bar(Bushtit,'stacked'); % graph bushtit data
set(gca,'nextplot','add') % graph next dataset on top of former graph
b2 = bar(Hawk,'stacked'); % graph hawk data

set(b1,'FaceColor','#0072BD'); % set bushtit bar color
set(b2,'FaceColor','#D95319'); % set hawk bar color

set(gca,'xtick',1:12,...
 'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}) % label x-axis with months
title("Bushtit to Cooper's Hawk (2020-2023)")
ylabel("# of birds")
xlabel("Month")
legend("Bushtit","Cooper's hawk")

%% Group bar chart
% here, bushtit vs Cooper's hawk populations

BushtitHawk = zeros(12,2); % initialize matrix
for i = 1:12
    BushtitHawk(i,:) = [Bushtit(i),Hawk(i)]; % organize bushtit and hawk data into single matrix
end

bar(BushtitHawk) % make bar graph
legend("Bushtit","Cooper's hawk")
set(gca,'xtick',1:12,...
 'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}) % label x-axis with months
title("Bushtit to Cooper's Hawk (2020-2023)")
ylabel("# of sightings")
xlabel("Month")
legend("Bushtit","Cooper's hawk")
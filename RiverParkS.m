%% Setup
clear ; close all ; clf
data = readtable('RiverParkData.csv'); % import data

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
SpeciesArray = table2array(data(:,"scientific_name")); % array of every species in dataset

SpecbyMonth = cell(1,12); % preallocate species by month cell array
for i = 1:12
    SpecbyMonth{:,i} = SpeciesArray(MonthArray == i); % Sort species data by month
end

%% Simple Pie Chart
% Graph pie charts of bird diversity by month

% Print pie charts for each month
for i = 1:12
    figure(i) % makes new figure
    pie(countcats(categorical(SpecbyMonth{:,i}))); % make pie chart
    title(datestr(datetime(1,i,1),'mmmm') + " bird diversity (2020 - 2023)") % make title
end

%% Exploded Pie Chart
% Pops out pie slice of a specific bird of interest 

for i = 1:12
    figure(i) % make new figure for each pie chart
    X = categorical(SpecbyMonth{:,i}); 
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
    SpecCount(i) = height(SpecbyMonth{:,i}); % counts how many entries are in each SpecbyMonth column
end

bar(SpecCount) % print bar graph
set(gca,'xtick',1:12,...
 'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}) % label x-axis with months
title("Bird population by month (2020-2023)")
ylabel("# of birds")
xlabel("Month")

% Graph population of bird of interest by month (here, bushtit and Cooper's hawk)

Bushtit = zeros(1,12); % initialize array
Hawk = zeros(1,12) % initialize array
for i = 1:12
    titcount = find(strcmp(SpecbyMonth{:,i}, 'Psaltriparus minimus')); % count how many times bushtit is recorded per month
    hawkcount = find(strcmp(SpecbyMonth{:,i}, 'Accipiter cooperii')); % count how many times Cooper's hawk is recorded per month
    Bushtit(i) = length(titcount);
    Hawk(i) = length(hawkcount);
end

bar(Bushtit)
set(gca,'xtick',1:12,...
 'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}) % label x-axis with months
title("Bushtit population by month (2020-2023)")
ylabel("# of birds")
xlabel("Month")

bar(Hawk)
set(gca,'xtick',1:12,...
 'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}) % label x-axis with months
title("Cooper's hawk population by month (2020-2023)")
ylabel("# of birds")
xlabel("Month")

% Stacked bar chart (here, bushtit vs Cooper's hawk populations)

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

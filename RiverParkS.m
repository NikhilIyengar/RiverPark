%% Point Plotting
close all
clear
clf
data = readtable('RiverParkData.csv'); % import data
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


%% Statistics
MonthArray = month(table2array(data(:,"observed_on"))); % Converts datetime to a single number indicating month
SpeciesArray = table2array(data(:,"scientific_name")); % array of every species in dataset

Species = cell(1,12); % preallocate species by month cell array
for i = 1:12
    Species{:,i} = SpeciesArray(MonthArray == i); % Sort species data by month
end

% Print pie charts for each month
for i = 1:12
    figure(i)
    pie(countcats(categorical(Species{:,i}))); % make pie chart
    legend(categories(categorical(Species{:,i}))) % make legend
    title(datestr(datetime(1,i,1),'mmmm') + " bird diversity (2020 - 2023)") % make title
end

% Pops out pie slice of a specific bird of interest 
for i = 1:12
    figure(i) % make new figure for each pie chart
    drawnow
    X = categorical(Species{:,i}); 
    if height(find(ismember(X,'Falco peregrinus'))) > 0 % check if bird exists in month
        explode = {'Falco peregrinus'}; % declare species of interest
        pie(X,explode); % make pie chart
        legend(categories(categorical(Species{:,i}))) % make legend
        title(datestr(datetime(1,i,1),'mmmm') + " bird diversity (2020 - 2023)") % make title
    else
        pie(X); % make pie chart
        legend(categories(categorical(Species{:,i}))) % make legend
        title(datestr(datetime(1,i,1),'mmmm') + " bird diversity (2020 - 2023)") % make title
    end
end

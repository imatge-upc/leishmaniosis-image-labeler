parasite_colours = {'cyan', 'blue', 'green', [255,112,0]/255, 'magenta', 'black',...
    'red'};

parasite_types = {'1 - Amastigot','2 - Promastigot','3 - Adherit',...
    '4 - No Paràsit','5 - Nucli Sa','6 - Fons','7 - Àrea no utilitzable'};

savejson('', struct('parasite_types',{parasite_types},'parasite_colours',...
    {parasite_colours}), 'FileName', 'config.json', 'Compact', 1);
function Vmap = genVisMap(cam)
% initial settings
Vmap = cam{1}.match{2};
matches = Vmap(1,:);
pcloud = cam{1}.pts;
idRM_1 = findRmPts(pcloud, matches);

pcloud = cam{2}.pts;
matches = Vmap(2,:);
idRM_2 = findRmPts(pcloud, matches);

padd_length_1 = length(find(idRM_1 > 0));
padd_length_2 = length(find(idRM_2 > 0));
temp = zeros(2, padd_length_1 + padd_length_2);

temp(1,1:padd_length_1) = find(idRM_1 == 1);
temp(2,padd_length_1 + 1: end) = find(idRM_2 == 1);

Vmap = [Vmap temp];

for i = 2:29
    matchesPre = cam{i-1}.match{i};
    matches = cam{i}.match{i+1};
    %numMatches = size(matches, 2);
    temp = zeros(1, size(Vmap, 2));
    for j = 1:size(matches,2)
        index = find(Vmap(i,:) == matches(1,j));
        if ~isempty(index)
            temp(1, index) = matches(2,j); 
        end
    end
    pcloud = cam{i+1}.pts;
%     idMatch = zeros(1, size(pcloud,2));  
%     idMatch(matches(2,:)) = idMatch(matches(2,:)) + 1;
%     idRM = 1 - idMatch;
    fprintf('%d...\n', i);
    idRM = findRmPts(pcloud, matches(2,:));
    padd_length = length(find(idRM > 0));
    Vmap = [Vmap zeros(size(Vmap,1),padd_length)];
    temp = [temp find(idRM == 1)];
    Vmap = [Vmap; temp];
end

end

function idRM = findRmPts(pcloud, matches)

idMatch = zeros(1, size(pcloud,2));  
idMatch(matches) = idMatch(matches) + 1; % (2,:)
idRM = 1 - idMatch;

end
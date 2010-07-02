for i = raus
    descriptors(:,[features.object] == i) = [];
    features(:,[features.object] == i) = [];
end


% summe = zeros(1,100)
% for i = 1:100
%     i
%     summe(i) = sum([features.object] == i)
% end
m2 = [];
for i = 1:2652
    if sourcemodel_and_leadfield.inside(i) == 1
        for j = 1:3
            vect = sourcemodel_and_leadfield.leadfield{1,i}(:,j);
            m2 = [m2 vect];
        end
    end
end
writematrix(m2, "Macierz_przejscia.csv")
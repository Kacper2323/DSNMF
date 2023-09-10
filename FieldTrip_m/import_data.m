m_4 = readmatrix("Macierz_przejscia.csv");
m_imp = (m_4)';
x = 1;
for i = 1:2652
    if sourcemodel.inside(i) == 1
        for j = 1:3
            sourcemodel_and_leadfield.leadfield{1,i}(:,j) = m_imp(:,x);
            x = x+1;
        end
    end
end

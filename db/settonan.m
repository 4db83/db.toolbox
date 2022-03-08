function matrix_out = settonan(matrix_in, value_to_be_replaced_by_NaN);

[rows,cols] = size(matrix_in);
matrix_out = zeros(rows,cols);
for i = 1 : rows;
    for j = 1:cols,
        if matrix_in(i,j) == value_to_be_replaced_by_NaN,
            matrix_out(i,j) = NaN;
        else matrix_out(i,j) = matrix_in(i,j);
        end;
    end;
end;

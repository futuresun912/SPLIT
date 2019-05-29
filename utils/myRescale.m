function B = myRescale(A,min_new,max_new)

min_old = min(A(:));
max_old = max(A(:));

B = ((A-min_old)*(max_new-min_new)) / (max_old-min_old) + min_new;

end
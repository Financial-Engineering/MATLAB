function f = FCaplets(T,volCaplets,i)
    f = ((T(i)-T(1))/360)*volCaplets(i)*volCaplets(i);

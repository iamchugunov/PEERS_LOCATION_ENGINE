function [f] = S_t(x, t, i, j, config)
    X = config.PostsENU;
    f = x(9 + j) + R_t(x, t, X(:,i))/config.c;
end


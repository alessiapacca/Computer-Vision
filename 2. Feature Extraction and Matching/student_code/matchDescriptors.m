% Match descriptors.
%
% Input:
%   descr1        - k x q descriptor of first image
%   descr2        - k x q' descriptor of second image
%   matching      - matching type ('one-way', 'mutual', 'ratio')
%
% Output:
%   matches       - 2 x m matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, matching)
    distances = ssd(descr1, descr2);
    m = size(descr1,2)
    n = size(descr2,2)

    matches1 = zeros(2,m)
    matches2 = zeros(2,n)


    if strcmp(matching, 'one-way') %looks at a descriptor, see if it matches b but not the opposite
        for i = 1:m
            [~,ind_min] = min(distances(:,i));
            matches1(:,i) = [i;ind_min];
        end
        matches = matches1

    elseif strcmp(matching, 'mutual')
        distances1 = distances'  %transposed matrix
        for i = 1:m
            [~,ind_min] = min(distances(:,i));
            matches1(:,i) = [i;ind_min];
        end
        for i = 1:n
            [~,ind_min] = min(distances1(:,i));
            matches2(:,i) = [ind_min;i]
        end
        matches = intersect(matches1',matches2', 'rows')'

    elseif strcmp(matching, 'ratio')
        for i = 1:m
            [values,ind] = mink(distances(:,i), 2)
            if values(1)/values(2) < 0.5
                matches1(:,i) = [i;ind(1)];
            end
        end
        indtoremove = find(matches1(1,:) <= 0)
        matches1(:,indtoremove) = [];
        matches = matches1
    else
        error('Unknown matching type.');
    end
end

function distances = ssd(descr1, descr2)
    distances = pdist2(descr2',descr1'); %m1 rows and m columns
end

function move2back(hax,h)

if isempty(hax), hax = gca; end

axkids = get(hax,'Children');
n_axkids = length(axkids);
for i=1:n_axkids
    if axkids(i)==h
        ih=axkids(i);
        break;
    end
end
if isempty(ih), error('handle(%f) not a child of hax(%f)', h, hax); end
neworder = setdiff(axkids,axkids(i));
new_axkids = [neworder' axkids(i)];
set(hax,'Children',new_axkids');
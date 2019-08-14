function RC = getactivebins(Stack,nonzero)
nstack = length(Stack);
ncell = size(Stack{1},3);
RC = cell(ncell,1);

for nc = 1:ncell
    ns = 1;
    [R_nonnan,C_nonnan] = find(~isnan(Stack{ns}(:,:,nc)));
    [R_active,C_active] = find(Stack{ns}(:,:,nc) > nonzero);
    RC_nonnan = [R_nonnan,C_nonnan];
    RC_active = [R_active,C_active];
    
    for ns = 2:nstack
        [r_nonnan,c_nonnan] = find(~isnan(Stack{ns}(:,:,nc)));
        [r_active,c_active] = find(Stack{ns}(:,:,nc) > nonzero);
        RC_nonnan = intersect(RC_nonnan,[r_nonnan,c_nonnan],'rows');
        RC_active = union(RC_active,[r_active,c_active],'rows');
    end
    RC{nc,1} = intersect(RC_nonnan,RC_active,'rows');
end
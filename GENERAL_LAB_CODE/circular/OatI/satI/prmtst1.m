function ut=permtest(p)
 iota=vec(eye(p));
 onep=ones(p,1);
% ut=30*iota*iota'+6*kron(onep,onep)*kron(onep',onep')-6*kron(onep,onep)*iota'-6*iota*kron(onep',onep');
ut=fac(p-2)*p*iota*iota'+fac(p-2)*kron(onep,onep)*kron(onep',onep')-fac(p-2)*kron(onep,onep)*iota'-fac(p-2)*iota*kron(onep',onep');
end

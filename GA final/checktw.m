% function checktw checks twins in the library of the already tested chrom.
function den=checktw(cc,lib,a)
	den=0;
	n=0;
	while den==0 & n<size(lib,1)
  n=n+1;
  if a==lib(n,:)
    den=1;
  end
end

function diskFill( tDir, nGig )
% Fill a harddisk with garbage files (useful before discarding disk).
%
% USAGE
%  diskFill( tDir, nGig )
%
% INPUTS
%  tDir    - target directory to fill with garbage
%  nGig    - maximum number of gigabytes to write to disk
%
% OUTPUTS
%
% EXAMPLE
%  diskFill( 'k:', 500 )
%
% See also
%
% Piotr's Image&Video Toolbox      Version 2.61
% Copyright 2011 Piotr Dollar.  [pdollar-at-caltech.edu]
% Please email me if you find bugs, or have suggestions or questions!
% Licensed under the Lesser GPL [see external/lgpl.txt]

nm = sprintf('%s/garbage_%s_%05i_%%05i.mat',tDir,date,round(rand*10^5));
tid = ticStatus();
for i=1:nGig
  % write up to 1 GB of garbage bytes in chunks of 1 MB
  fid=fopen(sprintf(nm,i),'w'); mb=2^20; n=0; o=mb;
  while(n<2^30 && o==mb), o=fwrite(fid,rand(mb,1)); n=n+o; end
  try fclose(fid); catch, end; tocStatus( tid, i/nGig ); %#ok<CTCH>
  % if write failed (k<1), disk is presumably full
  if( o<mb && i<nGig), tocStatus(tid,1);
    disp('Congrats, disk is full!'); break;
  end
end
end

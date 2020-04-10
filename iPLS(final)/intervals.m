function intervals(Model)

%  intervals prints the intervals with variable number and/or wavelength label
%
%  Input is Model (the output from iPLS.m/iPCA.m)
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, February 2000
%
%  intervals(Model);

if nargin==0
   disp(' ')
   disp(' intervals(Model);')
   disp(' ')
   return
end

disp(' ')
if isempty(Model.xaxislabels)
  disp(' Int.no Start  End  No. vars.')
  number_of_vars=Model.allint(:,3)-Model.allint(:,2)+1;
  table=[Model.allint number_of_vars];
  disp(table)
else
  disp('       Interval   Start var.   End var.   Start wav.   End wav.  Number of vars.')
  number_of_vars=Model.allint(:,3)-Model.allint(:,2)+1;
  table=[Model.allint Model.xaxislabels(Model.allint(:,2))' Model.xaxislabels(Model.allint(:,3))' number_of_vars];
  disp(table)
end
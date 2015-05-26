yes_reload = 0;
if yes_reload || ~exist('num','var')
  clear all
  [num,txt,raw] = xlsread('PNFA_info.xls');
  [numrows,numcols] = size(num);
   num = [NaN*ones(1,numcols); num];
  [numrows,numcols] = size(num);
end

icol4date = strmatch('Date',txt(1,:));
icol4order = strmatch('expr_order',txt(1,:));
icol4type = strmatch('Type',txt(1,:));
icol4comp = strmatch('mean_comp',txt(1,:));
icol4stde = strmatch('stde_comp',txt(1,:));

if ~ispc
    datecolumn = raw(:,icol4date);
    numbervalues = cellfun(@(V) any(isnumeric(V(:)) && ~isnan(V(:))), datecolumn)';
    datedata = datecolumn(numbervalues,1);
    correcteddatedata = cellfun(@(V) V-1+693961, datedata);
    converteddatedata = datestr(correcteddatedata,'mm/dd/yyyy');
    cellsconverteddatedata = cellstr(converteddatedata);
    
    firstdatesindices = find(numbervalues == 1,1,'first');
    lastdatesindices = find(numbervalues == 1,1,'last');
    datecolumn(firstdatesindices:lastdatesindices,1) = cellsconverteddatedata;
    raw(:,icol4date) = datecolumn;
    [row_w col_l] = size(txt);
    txt(:,icol4date) = datecolumn(1:row_w,1);
end

irows4comp = find(~isnan(num(:,icol4comp)));
nrows4comp = length(irows4comp);

irows4all_patients = strmatch('patient',txt(:,icol4type));
irows4all_controls = strmatch('control',txt(:,icol4type));

irows4patients = intersect(irows4all_patients,irows4comp);
nrows4patients = length(irows4patients);
irows4controls = intersect(irows4all_controls,irows4comp);
nrows4controls = length(irows4controls);

patient_comp(:,1) = num(irows4patients,icol4comp);
patient_comp(:,2) = num(irows4patients,icol4stde);

control_comp(:,1) = num(irows4controls,icol4comp);
control_comp(:,2) = num(irows4controls,icol4stde);

%Limits for data that would be extracted
t_start = -0.2; 
t_end = 1;

hf = figure
for ipert = 1:2
  hax(ipert) = subplot(1,2,ipert);
end
curdir = cd;
fprintf('patients:\n');
cd('Patients');
for iexpr = 1:nrows4patients
  the_expr_dir = date_to_dir(txt,num,irows4patients,icol4date,icol4order,iexpr);
  cd(the_expr_dir);
  the_pert_resp_file = get_pert_resp_file();
  fprintf('load(the_pert_resp_file)...'); pause(0.2); load(the_pert_resp_file); fprintf('done\n');
  pert_resp.frame_taxis_start_point = dsearchn(pert_resp.frame_taxis',t_start);
  pert_resp.frame_taxis_end_point = dsearchn(pert_resp.frame_taxis',t_end);
  patient_dat.pert_resp(iexpr).nframeswin = pert_resp.frame_taxis_end_point-pert_resp.frame_taxis_start_point+1;
  patient_dat.pert_resp(iexpr).n_good_trials = pert_resp.n_good_trials;
  
  
  
  patient_dat.pert_resp(iexpr).cents4comp.pitch_in.dat{1} = pert_resp.cents4comp.pitch_in.dat{1}(:,pert_resp.frame_taxis_start_point:pert_resp.frame_taxis_end_point);
  patient_dat.pert_resp(iexpr).cents4comp.pitch_in.dat{2} = pert_resp.cents4comp.pitch_in.dat{2}(:,pert_resp.frame_taxis_start_point:pert_resp.frame_taxis_end_point);
  patient_dat.pert_resp(iexpr).cents4comp.pitch_in.dat{3} = pert_resp.cents4comp.pitch_in.dat{3}(:,pert_resp.frame_taxis_start_point:pert_resp.frame_taxis_end_point);
  patient_dat.n_good_trials(iexpr,:) = pert_resp.n_good_trials;
  patient_dat.comp_resp(iexpr,:,:) = pert_resp.cents4comp.pitch_in.mean(:,pert_resp.frame_taxis_start_point:pert_resp.frame_taxis_end_point);
  if iexpr == 1, patient_dat.frame_taxis = pert_resp.frame_taxis(pert_resp.frame_taxis_start_point:pert_resp.frame_taxis_end_point); end
  for ipert = 1:2
    axes(hax(ipert));
    hpl = plot(patient_dat.frame_taxis,squeeze(patient_dat.comp_resp(iexpr,ipert,:)));
    axis([patient_dat.frame_taxis(1) patient_dat.frame_taxis(end) -50 50]);
  end
  patient_dat.is_good(iexpr) = 1;
  reply = input('good data? [y]/n: ','s');
  if ~isempty(reply) && ~strcmp(reply,'y')
    patient_dat.is_good(iexpr) = 0;
  end
  cd ..
end
cd ..
% 
% fprintf('controls:\n');
% cd('Controls');
% for iexpr = 1:nrows4controls
%   the_expr_dir = date_to_dir(txt,num,irows4controls,icol4date,icol4order,iexpr);
%   cd(the_expr_dir);
%   the_pert_resp_file = get_pert_resp_file();
%   fprintf('load(the_pert_resp_file)...'); pause(0.2); load(the_pert_resp_file); fprintf('done\n');
%   pert_resp.frame_taxis_start_point = dsearchn(pert_resp.frame_taxis',t_start);
%   pert_resp.frame_taxis_end_point = dsearchn(pert_resp.frame_taxis',t_end);
%   control_dat.pert_resp(iexpr).nframeswin = pert_resp.frame_taxis_end_point-pert_resp.frame_taxis_start_point+1;
%   control_dat.pert_resp(iexpr).n_good_trials = pert_resp.n_good_trials;
%   
%   
%   
%   control_dat.pert_resp(iexpr).cents4comp.pitch_in.dat{1} = pert_resp.cents4comp.pitch_in.dat{1}(:,pert_resp.frame_taxis_start_point:pert_resp.frame_taxis_end_point);
%   control_dat.pert_resp(iexpr).cents4comp.pitch_in.dat{2} = pert_resp.cents4comp.pitch_in.dat{2}(:,pert_resp.frame_taxis_start_point:pert_resp.frame_taxis_end_point);
%   control_dat.pert_resp(iexpr).cents4comp.pitch_in.dat{3} = pert_resp.cents4comp.pitch_in.dat{3}(:,pert_resp.frame_taxis_start_point:pert_resp.frame_taxis_end_point);
%   control_dat.n_good_trials(iexpr,:) = pert_resp.n_good_trials;
%   control_dat.comp_resp(iexpr,:,:) = pert_resp.cents4comp.pitch_in.mean(:,pert_resp.frame_taxis_start_point:pert_resp.frame_taxis_end_point);
%   if iexpr == 1, control_dat.frame_taxis = pert_resp.frame_taxis(pert_resp.frame_taxis_start_point:pert_resp.frame_taxis_end_point); end
%   for ipert = 1:2
%     axes(hax(ipert));
%     hpl = plot(control_dat.frame_taxis,squeeze(control_dat.comp_resp(iexpr,ipert,:)));
%     axis([control_dat.frame_taxis(1) control_dat.frame_taxis(end) -50 50]);
%   end
%   control_dat.is_good(iexpr) = 1;
%   reply = input('good data? [y]/n: ','s');
%   if ~isempty(reply) && ~strcmp(reply,'y')
%     control_dat.is_good(iexpr) = 0;
%   end
%   cd ..
% end
% cd ..
save('patient','patient_dat');
%save('control','control_dat');
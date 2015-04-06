yes_reload = 0;
if yes_reload || ~exist('num','var')
  clear all
  [num,txt,raw] = xlsread('vosselinfo_copy.xlsx');
  [numrows,numcols] = size(num);
  num = [NaN*ones(1,numcols); num];
  [numrows,numcols] = size(num);
end

icol4date = strmatch('Date',txt(1,:));
icol4order = strmatch('expr order',txt(1,:));
icol4type = strmatch('Type',txt(1,:));
icol4comp = strmatch('mean_comp',txt(1,:));
icol4stde = strmatch('stde_comp',txt(1,:));

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

hf = figure
for ipert = 1:2
  hax(ipert) = subplot(1,2,ipert);
end
curdir = cd;
fprintf('patients:\n');
for iexpr = 1:nrows4patients
  cd(Patients);
  the_expr_dir = date_to_dir(txt,num,irows4patients,icol4date,icol4order,iexpr);
  cd(the_expr_dir);
  the_pert_resp_file = get_pert_resp_file();
  fprintf('load(the_pert_resp_file)...'); pause(0.2); load(the_pert_resp_file); fprintf('done\n');
  patient_dat.pert_resp(iexpr) = pert_resp;
  patient_dat.n_good_trials(iexpr,:) = pert_resp.n_good_trials;
  patient_dat.comp_resp(iexpr,:,:) = pert_resp.cents4comp.pitch_in.mean;
  if iexpr == 1, patient_dat.frame_taxis = pert_resp.frame_taxis; end
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
  cd(curdir)
end

fprintf('controls:\n');
for iexpr = 1:nrows4controls
  cd(Controls);
  the_expr_dir = date_to_dir(txt,num,irows4controls,icol4date,icol4order,iexpr);
  cd(the_expr_dir);
  the_pert_resp_file = get_pert_resp_file();
  fprintf('load(the_pert_resp_file)...'); pause(0.2); load(the_pert_resp_file); fprintf('done\n');
  control_dat.pert_resp(iexpr) = pert_resp;
  control_dat.n_good_trials(iexpr,:) = pert_resp.n_good_trials;
  control_dat.comp_resp(iexpr,:,:) = pert_resp.cents4comp.pitch_in.mean;
  if iexpr == 1, control_dat.frame_taxis = pert_resp.frame_taxis; end
  for ipert = 1:2
    axes(hax(ipert));
    hpl = plot(control_dat.frame_taxis,squeeze(control_dat.comp_resp(iexpr,ipert,:)));
    axis([control_dat.frame_taxis(1) control_dat.frame_taxis(end) -50 50]);
  end
  control_dat.is_good(iexpr) = 1;
  reply = input('good data? [y]/n: ','s');
  if ~isempty(reply) && ~strcmp(reply,'y')
    control_dat.is_good(iexpr) = 0;
  end
  cd(curdir)
end

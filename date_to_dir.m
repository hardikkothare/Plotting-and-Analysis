function the_expr_dir = date_to_dir(vosselinfo_txt,vosselinfo_num,irows2use,icol4date,icol4order,iexpr)

the_expr_date_str = vosselinfo_txt{irows2use(iexpr),icol4date};
the_expr_order = vosselinfo_num(irows2use(iexpr),icol4order);
rem_expr_date_str = the_expr_date_str;
[the_expr_month_str,rem_expr_date_str] = strtok(rem_expr_date_str,'/');
the_expr_month = str2num(the_expr_month_str);
[the_expr_day_str,rem_expr_date_str] = strtok(rem_expr_date_str,'/');
the_expr_day = str2num(the_expr_day_str);
[the_expr_year_str,rem_expr_date_str] = strtok(rem_expr_date_str,'/');
the_expr_year = str2num(the_expr_year_str);
if ~the_expr_order
  the_expr_dir = sprintf('%d%02d%02d',the_expr_year,the_expr_month,the_expr_day);
else
  the_expr_dir = sprintf('%d%02d%02d_%d',the_expr_year,the_expr_month,the_expr_day,the_expr_order);
end
fprintf('%s: cd(%s)\n',the_expr_date_str,the_expr_dir);

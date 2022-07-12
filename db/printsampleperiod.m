function [] = printsampleperiod(timetable_in, date_format)

SetDefaultValue(2,'date_format','mmm-yyyy');

% just print to screen
fprintf('			        Sample period: %s to', ...
  datestr(timetable_in.Properties.RowTimes(1),date_format));
  fprintf(' %s\n', datestr(timetable_in.Properties.RowTimes(end),date_format));
end
function [] = headtail(input_timetable, length_2_show)
% show head 2 tail like in R

SetDefaultValue(2,'length_2_show', 15);

% check if it is a timetable
if isa(input_timetable,'timetable')

% top part 
disp(head(input_timetable, length_2_show));
% bottom part
disp(tail(input_timetable, length_2_show));

else
disp('-----------------------------------------------------------------------------------------------')
% disp('------------------------------------------- Head ----------------------------------------------')	
disp('																				Head ')	
disp('-----------------------------------------------------------------------------------------------')
disp(input_timetable(1:length_2_show,:));
% bottom part
disp('-----------------------------------------------------------------------------------------------')
% disp('------------------------------------------- Head ----------------------------------------------')	
disp('																				Tail')	
disp('-----------------------------------------------------------------------------------------------')
disp(input_timetable(end-length_2_show:end,:));



end
%EOF

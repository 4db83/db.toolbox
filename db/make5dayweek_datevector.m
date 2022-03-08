function d1 = make5dayweek_datevector(Begdate,Enddate,dateformat)
%{F: Make a 5 day week date vector 
% --------------------------------------------------------------------------------------------------
% INPUT: 
%			Begdate:			string or matlab datenum of begining date
%			Enddate:			string or matlab datenum of end date
%			dateformat:		string of dateformat to be used (optional, default is 'dd.mm.yyyy')
%
% EXAMPLE:
%			dateout = make5dayweek_datevector('01.02.2010','24.04.2013','dd.mm.yyyy')
%
% --------------------------------------------------------------------------------------------------
% Created :		05.08.2013.
% Modified:		21.05.2014.
% Copyleft:		Daniel Buncic.
% ------------------------------------------------------------------------------------------------%}

SetDefaultValue(3,'dateformat','dd.mm.yyyy');

if isnumeric(Begdate) & isnumeric(Enddate)
	d0 = Begdate:1:Enddate;
else
	d0 = datenum(Begdate,dateformat):1:datenum(Enddate,dateformat);
end

d0 = d0';
% make weekday vector
wd = weekday(d0);
% make indicator of monday to friday
Id = (wd>1)&(wd<7);
% retain only monday to friday dates
d1 = d0(Id);

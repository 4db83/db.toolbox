function [] = print2matwithbrackets(matrixin,formatin,bracket_type)
%% now print to screen to be copied into latex with probs in backets underneath

if nargin < 2
	formatin = [4;4];
end;

if nargin < 3
	bracket_type = '()';
end;


if length(formatin)==1
	frmtin2 = formatin(1);
else 
	frmtin2 = formatin(2);
end;
frmtin1 = formatin(1);

frmt = {['% 2.' num2str(frmtin1) 'f'];
				['% 2.' num2str(frmtin2) 'f']};

char_frmt1 = char(frmt(1));
char_frmt2 = char(frmt(2));

% difference for alignment 
dd = frmtin1 - frmtin2;

[RI,CI] = size(matrixin);

for ri = 1:RI;
	for ci = 1:CI;
		if ci==CI % this is the last column, needs to be different to all others with line termination for latex
			if mod(ri,2)
				fprintf(['\t ' char_frmt1	'\t\t\t \\\\ [\\lnsp]\\rowfont{\\sefnt} \n'],matrixin(ri,ci))
			else
				if dd == 2;
					fprintf(['\t' bracket_type(1) char_frmt2 bracket_type(2) '\t\t\t\t \\\\ [\\psp] \n'],matrixin(ri,ci))
				elseif dd == 0
					fprintf(['\t' bracket_type(1) char_frmt2 bracket_type(2) '\t\t\t \\\\ [\\psp] \n'],matrixin(ri,ci))
				elseif dd == -2
					fprintf(['\t' bracket_type(1) char_frmt2 bracket_type(2) '\t\t \\\\ [\\psp] \n'],matrixin(ri,ci))
				end
			end
		else
			if mod(ri,2)
				fprintf(['\t '	char_frmt1	'\t\t &']		,matrixin(ri,ci))
			else
				if dd == 2;
					fprintf(['\t' bracket_type(1) char_frmt2 bracket_type(2) '\t\t\t &']	,matrixin(ri,ci))
				elseif dd == 0
					fprintf(['\t' bracket_type(1) char_frmt2 bracket_type(2) '\t\t &']	,matrixin(ri,ci))
				elseif dd == -2
					fprintf(['\t' bracket_type(1) char_frmt2 bracket_type(2) '\t &']	,matrixin(ri,ci))
				end;
			end;
		end;
	end 
end



function    varargout = cmd_read_only( path_2_local_file, action )
% cmd_read_only sets or clears the attribute, read-only, of file
%
%   Example:
%       sts = cmd_read_only( 'c:\m\my_file.txt', 'on' )            
%       sts = cmd_read_only( 'c:\m\my_file.txt', 'off' )            
% 
%       +   Sets an attribute.
%       -   Clears an attribute.
%       R   Read-only file attribute.
%     ATTRIB [+R | -R] [+A | -A ] [+S | -S] [+H | -H] [+I | -I]
%            [drive:][path][filename] [/S [/D] [/L]]
%   See also: fileattrib
% ---------------------------------------------------------------------------------------------

   str = validatestring( action, {'on','off'} ); 

    if strcmp( str, 'on' )
        dos_cmd = sprintf( 'attrib +R %s', path_2_local_file );
        message = ' ... read-only: ON';
    else
        dos_cmd = sprintf( 'attrib -R %s', path_2_local_file );
        message = ' ... read-only: OFF';
    end
  
  % EXECUTE READ-ONLY DO/UNDO. FOR THIS WE NEED A FULL PATH 'PATH_2_LOCAL_FILE'
  [ sts, msg ] = system( dos_cmd ); 

  % if only a relative part
   if sts == 0
    if strcmp( str, 'on' )
        dos_cmd = sprintf( 'attrib +R %s', [pwd path_2_local_file] );
        message = ' ... read-only: ON';
    else
        dos_cmd = sprintf( 'attrib -R %s', [pwd path_2_local_file] );
        message = ' ... read-only: OFF';
    end
    % NOW TRY AGAIN AFTER FULL PATH SUPPLIED.
    [ sts, msg ] = system( dos_cmd ); 
   end

   % output argument
   assert( sts == 0                                ... 
    ,   'Pia:cmd_read_only:FailedSetAttribute'  ...
    ,   'Failed to set attribute: "%"'          ...
    ,   msg      )

    if nargout == 0
        disp( message )
        varargout = {};
    elseif nargout == 1
        varargout = { sts };
    else
        error('Wrong number of outputs')
    end
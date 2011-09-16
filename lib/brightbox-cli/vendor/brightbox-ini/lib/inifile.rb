# $Id: inifile.rb 1 2007-01-17 15:21:30Z ironmo $

# The 'inifile' gem will eventually be deprecated in favor of the
# 'ini' gem as it becomes able to handle streams, stringio and string buffers of INI
# formatted data.

require 'ini'

class IniFile < Ini
end

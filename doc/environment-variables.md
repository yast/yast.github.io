# Environment Variables

Deprecated environment variables are ~~crossed out~~.

Variables that are only supposed to be used in the testsuite are labeled with
*(TEST SUITE)*.

## Variables set by YaST

yast-core:

- YAST_IS_RUNNING

  Is set by YaST. Either 'instsys' if YaST is
  running from instsys or live installer. 'yes' in any other cases.

- ~~Y2LEVEL~~

  Is set when YaST core runs external programs
  (e.g. agents). It is set to a number representing the level of program
  components created during its creation. It is a YaST internal variable used
  to determine the level on which components run.

## Variables read by YaST

yast-core:

- LANGUAGE, LC_ALL, LC_MESSAGES, LANG

  Sets the language used by YaST.

- Y2DEBUGGER

  `1` is equivalent to `--debugger`

  `2` is equivalent to `--debugger-remote`

- ~~Y2XREFDEBUG~~

  Internal variable used for debugging symbol resolution in ycp
  lexer.

- Y2SLOG_FILE

  Defines a log file.

- Y2SLOG_DEBUG

  Enables debug mode with enhanced logging.

- Y2MAXLOGSIZE

  Default is 10×1024×1024 (10 MB). If size is exceeded log files
  are rotated; works only in instsys where log-rotate does not work. Also used
  for user changes log file.

- Y2MAXLOGNUM

  Number of rotated logs to keep. Used only in instsys where logrotate does
  not work. Also used for user changes log file. Defaults to 10.

- Y2RECURSIONLIMIT

  Used to detect recursion in YCP call stack. Only limited
  usage now in ruby world, as it is detected only when calling outside of ruby
  world via component system.

- Y2DIR

  Adds additional search paths to the list of YaST base directories as a
  preferred entry. Entries are separated by colons (:).
  
- Y2DEBUGONCRASH

  Used internally to print also debugging output to the signal logfile when
  YaST crashes.

- ~~Y2SCRSWEEP~~

  Used to test old behavior in scripting agent.

- ~~Y2SCRNOSORT~~

  If set, then ScriptingAgent parse config files in readdir order instead of
  sorted one.

- ~~Y2PARSECOMMENTS~~

  If set, then YCP parser and scanner parse also comments. Used for conversion
  from YCP to ruby.

- ~~YCP_YYDEBUG~~

  No longer used internal variable for debugging the ycp 
  parser. Used only in specially compiled ycp parser.

- ~~Y2DEBUGSHELL~~ *(TEST SUITE)*

  Internal variable used for debugging the shell command agent. It skips the
  execution of background shell commands.

- ~~Y2DEBUGALL~~ *(TEST SUITE)*

  If set, then all components are
  logged. Used in old testsuite to filter out log entries from other modules.

- Y2DISABLELANGUAGEPLUGINS *(TEST SUITE)*

  Disables all language plug ins, like e.g. ruby bindings or perl
  bindings. Uses core without language pack only. See
  https://github.com/yast/yast-core/issues/20
  Not for general usage!

yast-yast2:

- ~~Y2MODETEST~~ *(TEST SUITE)*

  Lets YaST run in test mode. For internal use only (unit tests).

- ~~Y2ALLGLOBAL~~ *(TEST SUITE)*

  Internal variable used in old testsuite to allow in ycp access to private
  methods. Still used by ruby-bindings to allow old testsuite access to
  private variables and methods.

yast-storage:

- YAST2_STORAGE_NO_PROPOSE_DISKS

  Manually defines a white-space separated list of disks that should be left
  out from partitioning proposal.

yast-support:

- SC_CONF

  Defaults to `~/.supportconfig`.

yast-ruby-bindings:

- ~~Y2PROFILER~~

  Starts the Ruby profiler if set to `1` or `true`.

- Y2DEBUGGER

  Can be set to `1`, `remote` or `manual`.

yast-fcoe-client:

- FCOE_CLIENT_TEST_MODE

  Lets the module run in test mode. Does not change anything in the system.

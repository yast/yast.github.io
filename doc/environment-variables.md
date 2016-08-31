# Environment Variables

Deprecated environment variables are ~~crossed out~~.

Variables that are only supposed to be used in the testsuite are labeled with
*(TEST SUITE)*.

## Variables set by YaST

yast-core:

- YAST_IS_RUNNING

  Is set by yast. Either 'instsys' if YaST is
  running from instsys or live installer. 'yes' in any other cases.

- ~~Y2LEVEL~~

  Is set when yast core runs external programs
  (e.g. agents). It is set to a number representing the level of program
  components created during its creation. It is a yast internal variable used
  to determine the level on which components run.

## Variables read by YaST

yast-core:

- LANGUAGE, LC_ALL, LC_MESSAGES, LANG

  sets the language used by YaST.

- Y2DEBUGGER

  `1` is equivalent to `--debugger`

  `2` is equivalent to `--debugger-remote`

- ~~Y2XREFDEBUG~~

  internal variable used for debugging symbol resolution in ycp
  lexer.

- Y2SLOG_FILE

  define a log file

- Y2SLOG_DEBUG

  enables debug mode with enhanced logging

- Y2MAXLOGSIZE

  default is 10×1024×1024 (10 MB). If size is exceeded log files
  are rotated; works only in inst-sys where log-rotate does not work. Also used
  for user changes log file

- Y2MAXLOGNUM

  default is 10. Number of rotated logs to keep. Used only in
  inst-sys where logrotate does not work.Also used for user changes log file

- Y2RECURSIONLIMIT

  used to detect recursion in YCP call stack. Only limited
  usage now in ruby world, as it is detected only when calling outside of ruby
  world via component system.

- Y2DIR

  Adds additional search paths to the list of yast base directories as a
  preferred entry. Entries are separated by colons (:).
  
- Y2DEBUGONCRASH

  Used internally to print also debugging output to the signal logfile when
  yast crashes.

- ~~Y2SCRSWEEP~~

  used to test old behavior in scripting agent.

- ~~Y2SCRNOSORT~~

  if set, then ScriptingAgent parse config files in readdir order instead of
  sorted one.

- ~~Y2PARSECOMMENTS~~

  if set, then YCP parser and scanner parse also comments. Used for conversion
  from YCP to ruby.

- ~~YCP_YYDEBUG~~

  No longer used internal variable for debugging the ycp 
  parser. Used only in specially compiled ycp parser.

- ~~Y2DEBUGSHELL~~ *(TEST SUITE)*

  internal variable used for debugging the shell command agent. It skips the
  execution of background shell commands.

- ~~Y2DEBUGALL~~ *(TEST SUITE)*

  if set, then all components are
  logged. Used in old testsuite to filter out log entries from other modules.

- Y2DISABLELANGUAGEPLUGINS *(TEST SUITE)*

  disables all language plug ins, like e.g. ruby bindings or perl
  bindings. Uses core without language pack only. See
  https://github.com/yast/yast-core/issues/20
  Not for general usage!

yast-inetd:

- YAST2_INETD

  Enables expert tools if set to `EXPERT`

yast-yast2:

- ~~Y2MODETEST~~ *(TEST SUITE)*

  Lets YaST run in test mode. For internal use only (unit tests).

- ~~Y2ALLGLOBAL~~ *(TEST SUITE)*

  internal variable used in old testsuite to allow in ycp access to private
  methods. Still used by ruby-bindings to allow old testsuite access to
  private variables and methods.

yast-storage:

- YAST2_STORAGE_NO_PROPOSE_DISKS

  manually define a white-space separated list of disks that should be left
  out from partitioning proposal.

yast-support:

- SC_CONF

  defaults to `~/.supportconfig`

yast-ruby-bindings:

- Y2PROFILER

  start the Ruby profiler if set to `1` or `true`

- Y2DEBUGGER

  Can be set to `1`, `remote` or `manual`

yast-fcoe-client:

- FCOE_CLIENT_TEST_MODE

  Let the module run in test mode. Does not change anything in the system.

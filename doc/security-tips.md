# Security Tips

Here is a short summary of security recommendations for the YaST developers.
This is very likely not a full list, feel free to add more tips.


## Obtaining Root Privileges

YaST needs to be already started under the `root` account, there is no switch
from an unprivileged user to the privileged one at runtime.

Some modules can be run under the unprivileged user, but they do not support switching
to the privileged user later. That means they usually work only in read-only
mode and do not allow to change anything.

The result is that there should not be any security problem in this area.


## Sensitive Data

Registration codes, access tokens, private keys, passwords (in URLs as well!)
or other sensitive data should never be logged to the `y2log`. Although
reading the `y2log` file requires root access it can be attached to bugzilla
where everybody could read it.

- Be careful when logging with `.inspect`: The result might contain confidential internal
  object data.
- For logging URLs use the [URL.HidePassword()](
  https://github.com/yast/yast-yast2/blob/5762181d62762816a73fc040362c1efb5d97deed/library/types/src/modules/URL.rb#L613)
  method


## Temporary Files

Never use fixed or predictable names when writing to the `/tmp` directory
(or in general any world-writable directory).

If you write to a predictable file, the attacker could prepare a symlink with
that name in advance pointing to some other file. Later when the user would
run the code the other file would be overwritten.

- Use the [Tempfile](
  https://ruby-doc.org/stdlib-2.2.2/libdoc/tempfile/rdoc/Tempfile.html
  ) Ruby class
- Use the [Dir.mktmpdir](
  https://ruby-doc.org/stdlib-2.2.2/libdoc/tmpdir/rdoc/Dir.html#method-c-mktmpdir
  ) Ruby method
- Or use the SCR [.target.tmpdir](
  https://github.com/yast/yast-core/blob/a0f511c66fd64382a1267f8151129d8b3ced7366/doc/systemagent.md#tmpdir
  ) agent


## Non-root Writable Directories

This is similar to the temporary files section above but it is about `/home`
or similar directories.

To avoid a [possible TOCTOU timing issue](https://en.wikipedia.org/wiki/Time_of_check_to_time_of_use)
([CVE](https://cwe.mitre.org/data/definitions/367.html)) you need to
atomically check and create the file.

- Use `O_CREAT`, `O_EXCL`, `O_WRONLY` flags when creating the file. In this case
  write fails if the file already exists. See `man 2 open` for more details.
- Create a unique file on the same file system and use `link` to set the
  final target name. See `man 2 link` and `man 2 open` for more details.


### Examples

#### Ruby

```ruby
# raises Errno::EEXIST if the file already exists
File.open(filename, File::WRONLY | File::CREAT | File::EXCL) do |file|
  file.write contents
end
```

#### C/C++

```cpp
int fd = open(file, O_CREAT | O_EXCL | O_WRONLY);
if ((fd < 0) && (errno == EEXIST))
{
    // the file already exists
}
```


## Downloading

Always prefer HTTPS over HTTP. It ensures you really connect to the intended
server and the communication is encrypted so nobody can read it or modify it.

Do not disable the peer verification. If you still need to do it (e.g.
because of a self-signed certificate), always ask the user for confirmation
and display the certificate details so the user can at least verify the
certificate fingerprint.


## SSL Certificates

Downloading and importing a SSL certificate from an insecure source (e.g. HTTP)
does not improve security; to the contrary, it makes it even worse.

If you need to import a certificate into the system, the user should *verify* the
certificate details (including the fingerprint) and *confirm* the import.

- See the registration module for example ([SslCertificate](
  https://github.com/yast/yast-registration/blob/327ab34c020a89f8b7e3f4bff55deea82e457237/src/lib/registration/ssl_certificate.rb#L11)
  or [SslCertificateDetails](
  https://github.com/yast/yast-registration/blob/327ab34c020a89f8b7e3f4bff55deea82e457237/src/lib/registration/ssl_certificate_details.rb#L11))


## Package Download and Installation

Downloading and installing packages requires extra security checks.
That includes repository meta-data verification and RPM signature verification.
Fortunately [libzypp](https://github.com/openSUSE/libzypp/) already handles
that for us.

- Always use libzypp functionality (through [yast2-pkg-bindings](
  https://github.com/yast/yast-pkg-bindings/)), never download or install the
  packages manually.


## Running External Tools

If you can avoid it, do not use external commands. In particular, do not use
external commands that have a good and easy-to-use Ruby counterpart. I.e. don't
pipe the output of one command to any of `grep`, `sed`, `tr`, `cut`. Simply use
plain Ruby for those things. Also, don't use `ls` or `find` to find files. Use
Ruby `Dir` and `Find` instead.

If you really need to use external commands:

The [shell injection vulnerability](
https://en.wikipedia.org/wiki/Code_injection#Shell_injection) is usually not
a problem as YaST is already running as root and the input comes from the root
user. So privilege escalation should not be possible.

But usually the problem happens when using a file with spaces in the file name or
or the user input contains some special characters like `<&%{}>`. Then the module
probably does not work as expected or can fail.

Also when executing external tools, always use the absolute path to avoid a
*file not found* error when `$PATH` variable is not set properly or to avoid
running possibly malicious replacements when the path contains the `.` directory
(which is not recommended).

Another issue might be with the order of the `$PATH` components, e.g.
`/usr/local/bin:/usr/bin` prefers `/usr/local/bin` which might also be
problematic.

- Use the [Yast::Execute](
  https://github.com/yast/yast-yast2/blob/master/library/system/src/lib/yast2/execute.rb
  ) module or the [cheetah](https://github.com/openSUSE/cheetah) gem directly
  for running external commands
- Use the [Shellwords.escape](
  https://ruby-doc.org/stdlib-2.2.0/libdoc/shellwords/rdoc/Shellwords.html)
  Ruby method, e.g. `/bin/rpm -q #{Shellwords.escape(user_input)}`
- Use the absolute path, e.g. `/bin/rpm`
  *Note: The very old YaST approach was NOT using the absolute path. This has
  been changed. But it might be still used in some places; feel free to fix that.*


## Attack Vectors for External Commands

### Malicious Programs in $PATH

If `$PATH` contains any directory where unprivileged users may have write
access or where they can mount (!) external media to (USB sticks, NFS / Samba
shares), they might put malicious programs there that are named just like
something that is called by YaST; somebody might put their own `grep` or `cp`
or whatever there that may not only do what the original does, but exploit the
privileges of the caller (i.e. root).

_**Remember that YaST is always running as root!**_

Whoever can make YaST call his binaries can get root access very easily.

Don't forget shell built-ins like `echo` and `test`, and remember that `[` is
just an alias for `test`. There is a counterpart for each of them in `/bin` or
`/usr/bin`.


### Malicious Programs Disguised as Plain Files

If you use the content of directories as part of a command line, you need to be
safe against files that have names that are weird, but legal. In a Linux/Unix
environment, there are few characters that are explicitly forbidden in file
names; the slash (`/`) is definitely forbidden, everything else is in most
cases just weird, but permitted.

A file may also be named something like

`; rm -rf *`    or
`"; rm -rf *`  or
`"; chown root rootshell; chmod u+s rootshell`

Of course this will make the original command fail, but the malicious command
that follows will succeed, so the damage is already done by the time anybody
notices that something is wrong.

Remember that it only takes one single of those commands to be executed with
root permissions to cause damage. Somebody might plug his USB stick in with
whole directories of such commands with various combinations of different types
of quotes.

So if you read a directory's content with Ruby or with C++ or with one script
and command and just use those names that we found as they are, you might easily
build command lines that by accident execute any of those malicious commands.


### Malicious Commands in Device Names / Mount Points

Any of the above can also happen with device names (OEM strings!) or mount
points (volume labels!). A USB stick might contain this.

Just look at `/dev/disk/by-label` and `/dev/disk/by-id` to get an idea.

Volume labels are commonly used in _udev_ rules as mount points.


### Malicious Commands Hidden in Other Places

All files that you read, all data that you process that comes from the outside,
all user input are datea that cannot be trusted, so you need to make sure to
properly escape all of that. The same attack vectors as with filenames apply to
all those things.


### Special Caveat: Escaping Single Quotes in the Shell

In most programming contexts, when you have a quote inside a quote, it only
matters if it is the same kind of quote, and then you simply prefix it with a
backslash:

`"Value: \"#{value}"\" (changed)"`

The shell is weird in that aspect. When you have a quote inside a quote, you
need to terminate the string, then add the quote escaped with a backslash, then
start a new string. So the above example would be

`"Value: "\"value\"" (changed)"`

This is very unexpected for most people, and so it is frequently done wrong.


### Shell-Escaping vs. Regexp-Escaping

While the shell has special treatment for some types of characters, regular
expressions have some other types of characters. Sometimes it's hard to get it
right for both cases.

Fortunately, regexps typically consist of a fixed part (that's where usually
the characters go that have special meaning for the regexps) and sometimes of a
variable part.

So, for most `grep` calls (which should be avoided in the first place - see
above), it should be used something like this:

`/usr/bin/egrep '^[0-9]+\s+'#{foo.shellescape}'bar$'`

So if the `foo` variable contains characters that need to be shell-escaped,
they are properly escaped, and the `egrep` command receives one single string
as the argument. Remember that the shell consumes the quotes and any
backslashes outside of quotes, so even if the complete command expands to
something like

`/usr/bin/egrep '^[0-9]+\s+'very\ weird\'stuff'bar$'`

the `egrep` command gets

`^[0-9]+\s+very weird'stuffbar$`

which is the expected thing.

_Notice that there is also Ruby `Regexp.escape` which can be combined with
this. The problem is just that there are many different variations of the
Regexp syntax, and Ruby `Regexp.escape` of course supports Ruby's own
variation. It's slightly different for `grep`, `egrep`, `sed`, `perl`. This is
something to watch out for. And this is also another reason to do that inside
Ruby and not call external tools like `grep` / `egrep` / `sed`; then you can
safely simply use Ruby `Regexp.escape`._



## Passing Sensitive Data to External Tools

Sometimes you need to pass sensitive data like password to an external tool.

* Pass the data through a pipe connected to STDIN of the child process if it is
  possible to provide the data via the standard input.
    - Use `pipe()` and `fork()` in C++ ([example](
      https://github.com/openSUSE/libstorage/blob/250089268d1b58da8bbf330e42c3f059986d7b28/storage/Utils/SystemCmd.cc#L226)),
      [Open3.popen](http://ruby-doc.org/stdlib-2.2.0/libdoc/open3/rdoc/Open3.html#method-c-popen3)
    - Use the [Yast::Execute](
      https://github.com/yast/yast-yast2/blob/master/library/system/src/lib/yast2/execute.rb
      ) module or the [cheetah](https://github.com/openSUSE/cheetah) gem directly
      for passing stdin
    - Use the `/proc/<PID>/fd/0` file

The other options are less secure or even insecure:

* Save the data into a file, let the tool read the file
    - The file content is kept on the disk even after unlinking the file
    - Overwriting the file content might not help on some file systems (see `man shred`)
    - A FS snapshot might be created before removing the file
* Pass the data on the command line - this is *very insecure* as it can be displayed
  in the output of the `ps` command, so it could be read by anybody on the local machine.
  (Exception: This could be possibly used during the initial installation where only the
  installer is running and no other user is logged in. But make sure this is not
  used in the installed system.)


### Examples

#### Ruby

```ruby
# Real world example from yast2-bootloader when using external utility to get
# the salted hash of a password. The utility asks twice for the password, so we
# need to get it twice with newlines.

# old insecure way with password on cmdline. DO NOT USE IT!
quoted_password = Yast::String.Quote(password)
result = Yast::WFM.Execute(YAST_BASH_PATH,
  "echo '#{quoted_password}\n#{quoted_password}\n' | LANG=C grub2-mkpasswd-pbkdf2")

# secure way with Yast::Execute
result = Yast::Execute.locally("/usr/bin/grub2-mkpasswd-pbkdf2",
  env:    { "LANG" => "C" },
  stdin:  "#{password}\n#{password}\n",
  stdout: :capture)
```

## Debugging

The debugging features might also potentially affect security or leak some
sensitive data.

- If you need to use a separate log file (not the standard `y2log`) make sure
  the file has root-only access.
- Use a directory accessible only to root. Otherwise avoid file collisions;
  see the [temporary files](#temporary-files) section.

When using a debugger (or any other special debugging features) make sure that
they are disabled by default.

- Enable the debugging features only on user request; use a command line
  option or an environment variable.
- If the tool allows remote control, then enable the remote access also only
  on request. And if possible, by default allow only local access via the
  loopback device (`localhost`/`127.0.0.1`).

See more details in the [debugging](debugging.md) document about the integrated
Ruby debugger support in YaST.


## Random Numbers

Linux has two devices generating random data: `/dev/urandom` (non-blocking) and
[cryptographically secure](
https://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator
) `/dev/random` (can block if there is not enough entropy).

Similarly in Ruby there is a simple [rand()](
https://ruby-doc.org/core-2.2.0/Random.html#method-c-rand) call and
[SecureRandom](
https://ruby-doc.org/stdlib-2.2.0/libdoc/securerandom/rdoc/SecureRandom.html)
class providing cryptographically secure methods for generating random values.

- Use the simple method when generating non-security related random values,
  e.g. a random host name, random time out, etc.
- For security related values (access keys, tokens), use the cryptographically
  secure sources.


## Further Reading

[YaST Security Audit Fixes: Lessons Learned and Reminder](https://github.com/yast/yast.github.io/issues/172)

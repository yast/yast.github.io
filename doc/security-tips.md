# Security Tips

Here is a short summary of security recommendations for the YaST developers.
This is very likely not a full list, feel free to add more tips.

## Obtaining the Root Privileges

YaST needs to be already started under the `root` account, there is no switch
from unprivileged user to privileged one at runtime.

Some modules can be run under unprivileged user but they do not support switching
to privileged user later. That means they usually work only in the read-only
mode and do not allow to change anything.

The result is that there should not be any security problem in this area.

## Sensitive Data

Registration codes, access tokens, private keys, passwords (in URLs as well!)
or other sensitive data should never be logged in to the `y2log`. Although
reading the `y2log` file requires root access it can be attached to bugzilla
where everybody could read it.

- Be careful when logging with `.inspect`, the result might contain the internal
  object data
- For logging URLs use the [URL.HidePassword()](
  https://github.com/yast/yast-yast2/blob/5762181d62762816a73fc040362c1efb5d97deed/library/types/src/modules/URL.rb#L613)
  method

## Temporary Files

Never use fixed or predictable names when writing to the `/tmp` directory
(or in general any world-writable directory).

If you write to a predictable file the attacker could prepare a symlink with
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

This is similar to the temporary files above but it is about the `/home`
or similar directories.

If you write anything to the user's home directory you should check if the
file already exists and is a symlink. In that case the easiest solution it to
abort the write operation.

## Downloading

Always prefer HTTPS over HTTP. It ensures you really connect to the intended
server and the communication is encrypted so nobody can read it or modify it.

Do not disable the peer verification, if you still need to do it (e.g.
because of a self-signed certificate) always ask the user for confirmation
and display the certificate details so the user can at least verify the
certificate fingerprint.

## SSL Certificates

Downloading and importing a SSL certificate from an insecure source (e.g. HTTP)
does not improve the security, in reality it makes it even worse.

If you need to import a certificate into the system the user should *verify* the
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

The [shell injection vulnerability](
https://en.wikipedia.org/wiki/Code_injection#Shell_injection) is usually not
a problem as YaST is already running as root and the input comes from the root
user. So privilege escalation should not be possible.

But usually the problem happens when using a file with spaces in the file name or
or the user input contains some special characters like `<&%{}>`. Then the module
probably does not work as expected or can fail.

Also when executing external tools always use the absolute path to avoid running
an unexpected binary when `$PATH` variable is not set properly.
 
- Use the [Yast::Execute](
  https://github.com/yast/yast-yast2/blob/master/library/system/src/lib/yast2/execute.rb
  ) module or the [cheetah](https://github.com/openSUSE/cheetah) gem directly
  for running the external commands
- Use the [Shellwords.escape](
  http://ruby-doc.org/stdlib-2.2.0/libdoc/shellwords/rdoc/Shellwords.html)
  Ruby method, e.g. `/bin/rpm -q #{Shellwords.escape(user_input)}`
- Use the absolute path, e.g. `/bin/rpm`  
  *Note: The very old YaST approach was NOT using the absolute path, this has
  been changed. But it might be still used somewhere, feel free to fix that.*


## Passing Sensitive Data to External Tools

Sometimes you need to pass sensitive data like password to an external tool.

- Pass the data through a pipe connected to STDIN of the child process if it is
  possible to provide the data via the standard input.
  - Use `pipe()` and `fork()` in C++ ([example](
    https://github.com/openSUSE/libstorage/blob/250089268d1b58da8bbf330e42c3f059986d7b28/storage/Utils/SystemCmd.cc#L226)),
    [Open3.popen](http://ruby-doc.org/stdlib-2.2.0/libdoc/open3/rdoc/Open3.html#method-c-popen3)
    or [IO.popen](https://ruby-doc.org/core-2.2.0/IO.html#method-c-popen) in Ruby
  - Use `/proc/<PID>/fd/0` file

The other options are less secure or even insecure:

- Save the data into a file, let the tool read the file
  - The file content is kept on the disk even after unlinking the file
  - Overwriting the file content might not help on some file systems (see `man shred`)
  - A FS snapshot might be created before removing the file
- Pass the data on the command line - this is *very insecure* as it can be displayed
  in the `ps` output so it could be read by anybody on the local machine.  
  (Exception: This could be possibly used during the initial installation where only the
  installer is running and no other user is logged in. But make sure this is not
  used in installed system.)


## Debugging

The debugging features might also potentially affect security or leak some
sensitive data.

- If you need to use a separate log file (not the standard `y2log`) make sure
  the file has root-only access.
- Use a directory accessible only to root, otherwise avoid file collisions,
  see the [temporary files](#temporary-files) section.

When using a debugger (or any other special debugging features) make sure that
they are disabled by default.

- Enable the debugging features only on user request, use a command line
  option or an environment variable.
- If the tool allows remote control then enable the remote access also only
  on request. And if possible by default allow only the local access via the
  loopback device (`localhost`/`127.0.0.1`).

See more details in the [debugging](./debugging) document about the integrated
Ruby debugger support in YaST.


## Random Numbers

Linux has two devices generating random data, `/dev/urandom` (non-blocking) and
[cryptographically secure](
https://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator
) `/dev/random` (can block if there is not enough entropy).

Similarly in Ruby there is a simple [rand()](
https://ruby-doc.org/core-2.2.0/Random.html#method-c-rand) call and
[SecureRandom](
https://ruby-doc.org/stdlib-2.2.0/libdoc/securerandom/rdoc/SecureRandom.html)
class providing cryptographically secure methods for generating random values.

- Use the simple method when generating non-security related random values,
  e.g. a random host name, random time out, etc...
- For security related values (access keys, tokens) use the cryptographically
  secure sources.


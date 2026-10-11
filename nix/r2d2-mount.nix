{ lib, hostName, ... }:

# The mini renders komorebi videos straight onto the NAS (r2d2's `home` share, /Volumes/home/komorebi), so the share has to be
# there whenever the logged-in session is. A user agent, not a daemon: `mount volume` reads the SMB password from the login
# keychain, which only the user's session can open. It checks every five minutes and remounts a share that dropped.
lib.mkIf (hostName == "jojo-m4-mini") {
  launchd.user.agents.mount-r2d2-home.serviceConfig = {
    ProgramArguments = [
      "/bin/sh"
      "-c"
      ''
        /sbin/mount | /usr/bin/grep -q ' on /Volumes/home (smbfs' \
          || /usr/bin/osascript -e 'mount volume "smb://jojo@r2d2._smb._tcp.local/home"'
      ''
    ];
    RunAtLoad = true;
    StartInterval = 300;
    StandardErrorPath = "/tmp/mount-r2d2-home.log";
  };
}

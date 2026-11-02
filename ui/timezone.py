import os
import re

# starting from Python 3.9 timezone information is part of Python standard library
from zoneinfo import available_timezones

#
#
#
from daemon.core import UiPath, System
from _domain.utils import Command, CommandElevated


#
#
#
class TimeZoneMgr:

    def list_timezones(self):

        # note, if the requirements.txt has a tzdata package, then this call will not only contain
        # canonical names of IANA (which Django insists on using as TIMEZONE in settings file) but
        # also some deprecated names like US/Pacific which will break Django if used in its 
        # settings file - see issue at https://github.com/diladele/websafety/issues/2416
        zones = sorted(list(available_timezones()))

        #
        # assert is incorrect - see https://github.com/diladele/websafety/issues/2460, commented out
        #
        # so we debug check here to stop right away
        #if System.WS_WINDOWS != System.name():
        #    assert("US/Pacific" not in zones)
        #

        # and return nicely
        return zones

    def get_timezone(self):

        # for debug only
        if System.WS_WINDOWS == System.name():
            return "Europe/London"

        if System.in_docker():
            return "Etc/UTC"

        # call timedatectl because calling any native python functions returns the Django configured timezone
        args  = ["timedatectl", "status", "--no-pager"]

        (exit_code, stdout, stderr) = Command().run(args)
        if exit_code != 0:
            raise Exception("cannot run command %s, exit code: %d, error message:\n%s" % (" ".join(args), exit_code, stdout + stderr))

        for line in stdout.split('\n'):

            match = re.search(r"Time zone:\s*(.*?)\s*\(", line)
            if match:
                return match.group(1)

        raise Exception(f"cannot parse timezone from {stdout}")

    def set_timezone(self, value):

        assert(len(value) > 0)

        # check the provided timezone indeed exists
        if value not in self.list_timezones():
            raise Exception(f"Unknown timezone {value} (not found in list of all timezones)")

        # save the new timezone into the system
        exe  = os.path.join(UiPath.bin_dir(), "timezone.py")
        arg1 = "--timezone=%s" % value
        args = [exe, arg1]

        (ret, stdout, stderr) = CommandElevated().run(args)

        # the system zone is set if return value is 0
        if ret == 0:

            # also generate the timezone.setting file
            tz_file = os.path.join(UiPath.var_dir(), "console", "console", "timezone.setting")
            with open(tz_file,"w") as fout:
                fout.write(value)

        # and return
        return (ret, stdout, stderr)

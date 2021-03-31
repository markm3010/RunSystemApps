use FileHandle;
use File::Basename;
use Time::localtime;

## Purpose: execute every binary application under the CWD 
##          to verify Secure Builds for Direct Sales are 
##          working as intended.

## Install ActiveState Perl 5.16.3.x
## Place this file in the C:\bhi\advantage directory, 
## install the license (or not), set up a well or restore a DB with data.
## run msgserver at least, and have a well with some data in it
## Then run the test in a cmd prompt.  cd to C:\bhi\advantage and type:
##
##    perl Run-All-Apps.pl
##
## As applications start, kill them so the next in the list can start.    
## A simple log file is created in the advantage directory giving return codes if available.
        ## take note of apps that start when license is not available,
        ## take note of apps that don't start when license is available.


my $ans;
my $i = 0;
my $attrib;
my @syslaunch_files = ("Engineering", "Engineering Utilities", "Hydraulics Toolbox", "Jar Performance", "SurveyUtilities", "TubeMove");
my @adv_files =  `dir /b /s | findstr ".exe"`; #  command to get all exe's plus some that are not.
chomp @adv_files;
my $this_file = uc(basename($0));
my $fname = "runapps.log";

if ( ! open LOG , ">$fname") {
    die "Can't open $fname: $!";
}

# purge buffers quick
$| = 1; 

my $start_time = get_date();
print LOG "$this_file\nSTART TIME: $start_time\n";

&StartLoop;

my $end_time = get_date();
print "DONE\n";
print LOG "----------------------------------------\n$this_file\nEND TIME: $end_time\n";

#################################################
# uses global arrays, loops over each exe name, sends path+exe to function to execute.
# todo: dlisscan and dliswrite - provide command lines for test

sub StartLoop  {
    foreach $this_exe (@adv_files) {
        if ( $this_exe =~ /\.exe$/i)  {
            unless ( $this_exe =~ /(rtproc\.exe|dlogger\.exe|dbedit\.exe|CDASetup\.exe|flexid9.*\.exe$|Setup64\.exe|TelemetryImport\.exe|events\.exe|dliss.*\.exe|cdasim\.exe|CaseTransfer\.exe|TAOnline.*\.exe|rtctl\.exe$|msgSvr\.exe$|lmhostID\.exe$|regDB\.exe$|SysLaunch\.exe$)/i) {  # start these or not at all
                if ( $this_exe =~ /syslaunch.exe/i ) {  # execute each engineering app in the engineering Start Menu
                    foreach $syslaunch_exe (@syslaunch_files)  {
                        $appendedExe = $this_exe . " \"$syslaunch_exe\"";
                        &runExe ($appendedExe);
                        sleep (2);
                    }
                }
                else  {
                    &runExe($this_exe);
                    sleep (2);
                }
            }
        }
    }
}


#################################################
# receives a path+exe, executes it, prints return data and exits.  todo: return the return value, let caller handle it.
sub runExe
{
    my $uc_app_nm;
    my $loc_exe = $_[0];
    my $exe_run_time = get_date();
    print LOG "\n----------------------------------------\n$exe_run_time: Running \"$loc_exe\"\n";
    print "\n----------------------------------------\nRunning \"$exe_run_time: $loc_exe\"\n";
    chomp($ret = system  $loc_exe);
    $uc_app_nm = uc(basename($loc_exe));
    if ($ret != 0) { 
        print LOG "ERROR: $uc_app_nm returned: $ret\n";
        print "ERROR: $uc_app_nm returned: $ret\n";
    }
    else  {
        print LOG "OK: $uc_app_nm returned: 0\n";
        print "OK: $uc_app_nm returned: 0\n";
    }
}


#################################################
# date function to help with logging.
sub get_date
{
   my $a_date;
    my $time_only = $false; # default is to print "date, time"
    $time_only = shift; # todo: either modify to give a different data format
                        # based on parameter passed in, or not.  If not, remove this!

    my $tm = localtime;
    my $month = ($tm->mon)+1; $day = $tm->mday; $year = ($tm->year+1900);
    my $hr = $tm->hour; $min = $tm->min; $sec = $tm->sec;
    
    if ($min < 10)  { $min = "0" . $min }
    if ($sec < 10)  { $sec = "0" . $sec }
    
    if ($time_only)  {
        $a_date = "$hr:$min:$sec";
    }
    else  {
        $a_date = "$month\/$day\/$year, $hr:$min:$sec";
    }
    return $a_date;
}
#################################################
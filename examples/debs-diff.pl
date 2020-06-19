#!/usr/bin/perl -w
#
# compare differences between to lists of RPMs
# the lists need to be generated with the following command
# dpkg -i
#

# array offsets
$VERSION = 0;
$RELEASE = 1;

$INSTALL = 0;
$VERSION_CHANGE = 1;
$RELEASE_CHANGE = 2;
$REMOVE = 3;
$NO_CHANGE = 4;

# text for categories
$categories[ $INSTALL ] = "Installed";
$categories[ $VERSION_CHANGE ] = "Version changed";
$categories[ $RELEASE_CHANGE ] = "Release changed";
$categories[ $REMOVE ] = "Removed";
$categories[ $NO_CHANGE ] = "No change";

# make sure two lists are specified
$arguments = $#ARGV + 1;
if ( $arguments != 2 )
{
    print "usage: $0 from_file to_file\n";
    exit 1;
}

# process the two specified files
foreach $filename ( @ARGV )
{
    # open file
    unless( open( FILE, "<$filename" ) )
    {
        print "error: cannot open $filename\n";
        exit 1;
    }

    # run through file
    while( <FILE> )
    {
        # ignore lines that do not mention packages
        if ($_ !~ /^ii/)
        {
            next;
        }

        # remove newline from end of line
        chop $_;

        # split package name, version
        ( $i, $package_name, $version ) = split();

        # release was used for rpms-diff, but not now
        $release = 0;

        # store in a hash named for the file that it contains
        # key is package name,
        # value is an array with version, package release
        $$filename{ $package_name } = [ $version, $release ];
    }

    # close file
    close ( FILE );
}

# assign mnemonic names for hash access
$from = $ARGV[ 0 ];
$to = $ARGV[ 1 ];

# clear report hash
%report = ();

# generate report
foreach $key ( keys %$from )
{
    if ( ! $$to{ $key } )
    {
        # package is only in from list
        $report{ $key } = $REMOVE;
    }
    else
    {
        # package is in both lists
        if ( $$from{ $key }[ $VERSION ] eq $$to{ $key }[ $VERSION ] )
        {
            # same version of package
            if ( $$from{ $key }[ $RELEASE ] eq $$to{ $key }[ $RELEASE ] )
            {
                # same release, no change in package
                $report{ $key } = $NO_CHANGE;
            }
            else
            {
                # different package release
                $report{ $key } = $RELEASE_CHANGE;
            }
        }
        else
        {
            # different version of package
            $report{ $key } = $VERSION_CHANGE;
        }
    }
}

# generate report
foreach $key ( keys %$to )
{
    if ( ! $$from{ $key } )
    {
        # package is only in to list
        $report{ $key } = $INSTALL;
    }
}

# print report
print "Changes from file \"$from\" to file \"$to\".\n\n";

for ( $i = 0; $i < $#categories; $i++ )
{
    # print title block
    print "#\n";
    print "# $categories[ $i ]\n";
    print "#\n";

    foreach $key ( keys %report )
    {
        # if the package is in the same status
        # as the category that is being printed
        if ( $i == $report{ $key } )
        {
            if ( $i != $INSTALL )
            {
                # print from package information
                print "$key";
                print " ";
                print "$$from{ $key }[ $VERSION ]";
                print "-";
                print "$$from{ $key }[ $RELEASE ]";
            }

            if ( $i != $INSTALL && $i != $REMOVE )
            {
                # print arrow
                print "  ==>  ";
            }

            if ( $i != $REMOVE )
            {
                # print to package information
                print "$key";
                print " ";
                print "$$to{ $key }[ $VERSION ]";
                print "-";
                print "$$to{ $key }[ $RELEASE ]";
            }

            print "\n";
        }
    }

    print "\n";
}

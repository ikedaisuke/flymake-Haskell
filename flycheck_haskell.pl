#!/opt/Gentoo/usr/bin/perl
#

$ghc = '/opt/Gentoo/usr/bin/ghc'; # where is ghc
@ghc_options  = ('-Wall'
	#       , '-fglasgow-exts'
	#       , '-fno-warn-type-defaults'
	#	, '-fwarn-unused-do-bind'
		, '-fwarn-wrong-do-bind'
                , '-XTemplateHaskell'
                , '-XDeriveDataTypeable'
                , '-XFlexibleContexts'
		, '-XFlexibleInstances'
                , '-XMultiParamTypeClasses'
		, '-XUndecidableInstances');
@ghc_packages = ();          # e.g. ('QuickCheck')

### the following should not been edited ###

use File::Temp qw /tempfile tempdir/;
File::Temp->safe_level( File::Temp::HIGH );

($source, $base_dir) = @ARGV;

@command = ($ghc,
            '--make',
	    '-ignore-dot-ghci',
            '-fbyte-code',
            "-i$base_dir",
	    "-i$base_dir/..",
	    "-i$base_dir/../..",
	    "-i$base_dir/../../..",
	    "-i$base_dir/../../../..",
	    "-i$base_dir/../../../../..",
	    "-i$base_dir/../../../../../..",
	    "-i$base_dir/../../../../../../..",
    );

while(@ghc_options) {
    push(@command, shift @ghc_options);
}

push(@command, $source);

while(@ghc_packages) {
    push(@command, '-package');
    push(@command, shift @ghc_packages);
}

$dir = tempdir( CLEANUP => 1 );
($fh, $filename) = tempfile( DIR => $dir );

system("@command >$filename 2>&1");
open(MESSAGE, $filename); 
while(<MESSAGE>) {
    if(/^(\S*\.hs|\.lhs)(:\d*:\d*:)(.*)/) {
	print $1;
	print $2;
	chomp $rest;
	print $rest;
    }
    if(/^\[/) {
        next;
    }
    if(/\s+(.*)/) {
	$rest = $1;
        chomp $rest;
	print $rest;
	# print " ";
	next;
    }
}
close($fh);
print "\n";

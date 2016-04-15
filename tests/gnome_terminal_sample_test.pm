#!/usr/bin/perl -w

use parent "x11test";
use testapi;

sub run ()
{
    my $self = shift;
    select_console("root-console");
    validate_script_output("ls", sub { !m/test\.file/ } );
    script_run("touch test.file");
    assert_script_run("test -f test.file");
}

sub post_run_hook
{
    select_console("installation");
    return 1;
}

sub test_flags ()
{
    return {important => 1, fatal => 1};
}

1;


#!/usr/bin/perl -w

use parent "x11test";
use testapi;

sub run ()
{
    my $self = shift;
    x11_start_program("firefox");
    assert_screen("firefox-started");
    assert_and_click("firefox-main-menu");
    assert_and_click("main-menu-opened");
    assert_and_click("about-firefox");
    assert_screen("about-mozilla-firefox-ESR");
}

sub post_run_hook
{
    return 1;
}

sub test_flags ()
{
    return {important => 1, fatal => 1};
}

1;

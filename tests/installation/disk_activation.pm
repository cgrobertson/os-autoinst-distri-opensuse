# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

use base "y2logsstep";
use strict;
use testapi;

sub run {
    my $self = shift;

    if (check_var('S390_DISK', 'ZFCP')) {    # use zfcp as install disk
        assert_screen 'disk-activation-zfcp';
        send_key 'alt-z';                    # configure ZFCP disk
        assert_screen 'zfcp-disk-management';
        send_key 'alt-a';
        assert_screen 'zfcp-add-device';
        send_key 'alt-g';                    # get wwpn's
        assert_screen 'zfcp-wwpn';
        sleep 3;
        send_key 'alt-t';                    # get lun
        send_key 'alt-t';                    # do it twice
        assert_screen 'zfcp-lun';
        send_key 'alt-n';

        if (check_screen 'zfcp-popup-scan') {
            send_key 'alt-o';
        }
        assert_screen 'zfcp-disk-management';
        assert_screen 'zfcp-activated';
        send_key 'alt-n';
        sleep 5;
    }
    else {                                   # use default DASD as install disk
        assert_screen 'disk-activation', 15;
        send_key 'alt-d';                    # configure DASD disk
        assert_screen 'dasd-disk-management';

        # we need to type backspace to delete the content of the input field in textmode
        if (check_var("VIDEOMODE", "text")) {
            send_key 'alt-m';                # minimum channel ID
            for (1 .. 9) { send_key "backspace"; }
            type_string '0.0.0150';
            send_key 'alt-x';                # maximum channel ID
            for (1 .. 9) { send_key "backspace"; }
            type_string '0.0.0150';
            send_key 'alt-f';                # filter button
            assert_screen 'dasd-unselected';
            send_key 'alt-s';                # select all
            assert_screen 'dasd-selected';
            send_key 'alt-a';                # perform action button
            assert_screen 'action-list';
            send_key 'alt-a';                # activate
        }
        else {
            send_key 'alt-m';                # minimum channel ID
            type_string '0.0.0150';
            send_key 'alt-x';                # maximum channel ID
            type_string '0.0.0150';
            send_key 'alt-f';                # filter button
            assert_screen 'dasd-unselected';
            send_key 'alt-s';                # select all
            assert_screen 'dasd-selected';
            send_key 'alt-a';                # perform action button
            assert_screen 'action-list';
            send_key 'a';                    # activate
        }

        if (check_screen 'dasd-format-device') {    # format device pop-up
            send_key 'alt-o';                          # continue
            while (check_screen 'process-format') {    # format progress
                printf "formating ...\n";
                sleep 20;
            }
        }
        ### Commented out below becuase of bsc#937340
        #elsif (!get_var('UPGRADE') && !get_var('ZDUP')) {
        #    send_key 'alt-s';   # select all
        #    assert_screen 'dasd-selected';
        #    send_key 'alt-a';   # perform action button
        #    if (check_screen 'dasd-device-formatted'){
        #        assert_screen 'action-list';
        #        send_key 'f';
        #        send_key 'f';   # Pressing f twice because of bsc#940817
        #        send_key 'ret';
        #        assert_screen 'confirm-format';
        #        send_key 'alt-y';
        #        while (check_screen 'process-format') {
        #            printf "formating ...\n";
        #            sleep 20;
        #       }
        #   }
        #}
        sleep 5;
        assert_screen 'dasd-active';
        send_key 'alt-n';    # next
        sleep 5;
    }
    assert_screen 'disk-activation', 15;
    send_key 'alt-n';        # next
    sleep 5;

    if (check_screen('detected-multipath')) {
        send_key 'alt-y';
        sleep 4;
        send_key 'alt-n';
    }
}

1;
# vim: set sw=4 et:

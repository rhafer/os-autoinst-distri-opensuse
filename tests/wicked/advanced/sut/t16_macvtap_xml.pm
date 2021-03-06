# SUSE's openQA tests
#
# Copyright © 2019 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Advanced test cases for wicked
# Test 16: Create a macvtap interface from wicked XML files
# Maintainer: Anton Smorodskyi <asmorodskyi@suse.com>
#             Jose Lausuch <jalausuch@suse.com>
#             Clemens Famulla-Conrad <cfamullaconrad@suse.de>

use base 'wickedbase';
use strict;
use warnings;
use testapi;

our $macvtap_log = '/tmp/macvtap_results_xml.txt';

sub run {
    my ($self, $ctx) = @_;
    record_info('Info', 'Create a macvtap interface from wicked XML files');
    my $config = '/etc/wicked/ifconfig/macvtap.xml';
    $self->get_from_data('wicked/xml/macvtap.xml', $config);
    $self->prepare_check_macvtap($config, $ctx->iface(), $self->get_ip(type => 'macvtap', netmask => 1));
    $self->wicked_command('ifreload', $ctx->iface());
    $self->wicked_command('ifup',     'macvtap1');
    $self->validate_macvtap($macvtap_log);
    upload_logs($macvtap_log);
}

sub post_fail_hook {
    my ($self) = shift;
    select_console('log-console');
    upload_logs($macvtap_log);
    $self->SUPER::post_fail_hook;
}

sub test_flags {
    return {always_rollback => 1};
}

1;

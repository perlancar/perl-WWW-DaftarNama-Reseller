package WWW::DaftarNama::Reseller;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Exporter::Rinci qw(import);

our %SPEC;

my %args_common = (
    username => {
        schema => 'str*',
        req => 1,
        tags => ['common', 'category:credential'],
    },
    password => {
        schema => 'str*',
        req => 1,
        is_password => 1,
        tags => ['common', 'category:credential'],
    },
    idkey => {
        schema => 'str*',
        req => 1,
        is_password => 1,
        tags => ['common', 'category:credential'],
    },
);

my %arg0_domain = (
    domain => {
        schema => 'domain::name*',
        req => 1,
        pos => 0,
    },
);

my %args_ns = (
    ns1 => {schema => 'net::hostname*', req=>1},
    ns2 => {schema => 'net::hostname*', req=>1},
    ns3 => {schema => 'net::hostname*', req=>1},
    ns4 => {schema => 'net::hostname*', req=>1},
);

my %args_contact = (
    firstname => {schema => 'str*', req=>1},
    lastname => {schema => 'str*', req=>1},
    company => {schema => 'str*', req=>1},
    address => {schema => 'str*', req=>1},
    city => {schema => 'str*', req=>1},
    state => {schema => 'str*', req=>1},
    zip => {schema => 'str*', req=>1},
    country => {schema => 'str*', req=>1},
    email => {schema => 'str*', req=>1}, # XXX email
    phone => {schema => 'str*', req=>1}, # XXX phone::number
);

my %arg_ns = (
    ns => {schema => 'net::hostname*', req=>1},
);

sub _request {
    require HTTP::Tiny;
    require JSON::MaybeXS;

    my (%args) = @_;

    my $url = "https://www.daftarnama.id/api/provider.php";
    my $res = HTTP::Tiny->new->post_form($url, \%args);
    return [$res->{status}, "Can't post to $url: $res->{reason}"]
        unless $res->{success};

    my $data;
    eval { $data = JSON::MaybeXS::decode_json($res->{content}) };
    return [500, "Invalid JSON response from server: $@"] if $@;

    [200, "OK", $data];
}

$SPEC{get_ns} = {
    v => 1.1,
    summary => 'Get nameservers for a domain',
    args => {
        %args_common,
        %arg0_domain,
    },
};
sub get_ns {
    my %args = @_;
    _request(
        action => 'getDNS',
        %args,
    );
}

$SPEC{update_ns} = {
    v => 1.1,
    summary => 'Update nameservers for a domain',
    args => {
        %args_common,
        %arg0_domain,
        %args_ns,
    },
};
sub update_ns {
    my %args = @_;
    _request(
        action => 'updateDNS',
        %args,
    );
}

$SPEC{get_lock_status} = {
    v => 1.1,
    summary => 'Get lock status for a domain',
    args => {
        %args_common,
        %arg0_domain,
    },
};
sub get_lock_status {
    my %args = @_;
    _request(
        action => 'getStatus',
        %args,
    );
}

$SPEC{update_lock_status} = {
    v => 1.1,
    summary => 'Update lock status for a domain',
    args => {
        %args_common,
        %arg0_domain,
        statusKey => {schema => 'str*', req=>1},
    },
};
sub update_lock_status {
    my %args = @_;
    _request(
        action => 'changeStatus',
        %args,
    );
}

$SPEC{register} = {
    v => 1.1,
    summary => 'Register a domain',
    args => {
        %args_common,
        %arg0_domain,

        periode => {schema => ['int*', between=>[1,10]]},
        %args_ns,
        %args_contact,
    },
};
sub register {
    my %args = @_;
    _request(
        action => 'domainRegister',
        %args,
    );
}

$SPEC{transfer} = {
    v => 1.1,
    summary => 'Transfer a domain',
    args => {
        %args_common,
        %arg0_domain,
        eppCode => {schema => 'str*', req=>1},
    },
};
sub transfer {
    my %args = @_;
    _request(
        action => 'domainRegister',
        %args,
    );
}

$SPEC{renew} = {
    v => 1.1,
    summary => 'Renew a domain',
    args => {
        %args_common,
        %arg0_domain,
        eppCode => {schema => 'str*', req=>1},
    },
};
sub renew {
    my %args = @_;
    _request(
        action => 'domainRenewal',
        %args,
    );
}

$SPEC{get_contact} = {
    v => 1.1,
    summary => 'Get contact information for a domain',
    args => {
        %args_common,
        %arg0_domain,
    },
};
sub get_contact {
    my %args = @_;
    _request(
        action => 'whoisDomain',
        %args,
    );
}

$SPEC{update_contact} = {
    v => 1.1,
    summary => 'Update contact information for a domain',
    args => {
        %args_common,
        %arg0_domain,
        %args_contact,
        contacttype => {
            schema => ['str*', in=>[qw/all reg admin tech billing/]],
            req => 1,
        },
    },
};
sub update_contact {
    my %args = @_;
    _request(
        action => 'updateWhois',
        %args,
    );
}

$SPEC{get_epp} = {
    v => 1.1,
    summary => 'Get EPP Code for a domain',
    args => {
        %args_common,
        %arg0_domain,
    },
};
sub get_epp {
    my %args = @_;
    _request(
        action => 'getEPP',
        %args,
    );
}

$SPEC{register_ns} = {
    v => 1.1,
    summary => 'Register a nameserver',
    args => {
        %args_common,
        %arg0_domain,
        %arg_ns,
        ip => {schema => 'net::ipv4*', req=>1},
    },
};
sub register_ns {
    my %args = @_;
    _request(
        action => 'hostRegister',
        %args,
    );
}

$SPEC{delete_ns} = {
    v => 1.1,
    summary => 'Delete a nameserver',
    args => {
        %args_common,
        %arg0_domain,
        %arg_ns,
    },
};
sub delete_ns {
    my %args = @_;
    _request(
        action => 'deleteHost',
        %args,
    );
}

$SPEC{get_registrar} = {
    v => 1.1,
    summary => 'Get registrar of a domain',
    args => {
        %args_common,
        %arg0_domain,
    },
};
sub get_registrar {
    my %args = @_;
    _request(
        action => 'getRegistrar',
        %args,
    );
}

$SPEC{check_availability} = {
    v => 1.1,
    summary => 'Check the availability of a domain',
    args => {
        %args_common,
        %arg0_domain,
    },
};
sub check_availability {
    my %args = @_;
    _request(
        action => 'checkAvailibility',
        %args,
    );
}

# XXX: uploadDocument
# XXX: changeStatuses
# XXX: checkDocument
# XXX: docType
# XXX: deleteDomain
# XXX: deleteDNSSec
# XXX: getEXP
# XXX: getRegistrar
# XXX: updateDNSSec
# XXX: domainRestore

1;
# ABSTRACT: Reseller API client for DaftarNama.id

=head1 SYNOPSIS

 use WWW::DaftarNama::Reseller qw(
     get_dns
     # ...
 );

 my $res = get_dns(
     # to get these credentials, first sign up as a reseller at https://daftarnama.id
     username => '...',
     password => '...',
     idkey    => '...',

     domain   => 'shopee.co.id',
 );


=head1 DESCRIPTION

DaftarNama.id, L<https://daftarnama.id>, is an Indonesian TLD (.id) registrar.
This module provides interface to the reseller API.


=head1 SEE ALSO

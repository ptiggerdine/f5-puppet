require 'spec_helper_acceptance'

describe 'f5_profileclientssl' do
  it 'creates and updates serverssl-profile1' do
    pp=<<-EOS
    f5_profileclientssl {'/Common/clientssl-profile1':
       ensure                => 'present',
       defaults_from         => '/Common/clientssl',
       cert                  => '/Common/default.crt',
       key                   => '/Common/default.key',
       proxy_ssl             => 'enabled',
       proxy_ssl_passthrough => 'enabled',
       cipher_group:         => '/Common/f5-default',
       ciphers:              => 'DEFAULT',
       ssl_options:          => '{ dont-insert-empty-fragments no-sslv3 no-tlsv1 no-tlsv1.1 }'
    }
    EOS
    make_site_pp(pp)
    run_device(:allow_changes => true)
    run_device(:allow_changes => false)

    # pp2=<<-EOS
    # f5_persistencedestaddr { '/Common/dest_addr1':
    #    ensure                          => 'present',
    #    match_across_pools              => 'disabled',
    #    match_across_services           => 'disabled',
    #    match_across_virtuals           => 'disabled',
    #    hash_algorithm                  => 'default',
    #    mask                            => '255.255.0.0',
    #    timeout                         => '100',
    #    override_connection_limit       => 'disabled',
    # }
    # EOS
    # make_site_pp(pp2)
    # run_device(:allow_changes => true)
    # run_device(:allow_changes => false)
  end

  it 'deletes f5_profileclientssl' do
    pp=<<-EOS
    f5_profileclientssl {'/Common/clientssl-profile1':
      ensure => 'absent',
    }
    EOS
    make_site_pp(pp)
    run_device(:allow_changes => true)
    run_device(:allow_changes => false)

  end
end

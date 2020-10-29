require 'spec_helper_acceptance'

describe 'f5_profiletcp' do
  it 'creates and updates f5_profiletcp' do
    pp=<<-EOS
    f5_profiletcp { '/Common/tcp-profile_1':
       ensure               => 'present',
       closewait-timeout    => 6,
       fin-wait-timeout     => 6,
       defaults-from        => '/Common/tcp',
       fin-wait2-timeout    => 301,
       idle-timeout         => 301,
       keep-alive-interval  => 1801,
       minimum-rto          => 201,
       reset-on-timeout     => true,
       time-wait-timeout    => 2001,
       time-wait-recycle    => true,
       zero-windows-timeout => 20001,
    }
    EOS
    make_site_pp(pp)
    run_device(:allow_changes => true)

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

  it 'deletes f5_profiletcp' do
    pp=<<-EOS
    f5_profiletcp { '/Common/tcp-profile_1':
      ensure => 'absent',
    }
    EOS
    make_site_pp(pp)
    run_device(:allow_changes => true)
    run_device(:allow_changes => false)

  end
end

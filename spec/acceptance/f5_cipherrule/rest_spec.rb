require 'spec_helper_acceptance'

describe 'f5_cipherrule' do
  it 'creates a basic cipher rule called my_cipherrule' do
    pp=<<-EOS
    f5_irule { '/Common/my_cipherrule':
      ensure               => 'present',
      description          => 'My cipher rule'
      cipher               => '!SSLV3:!DES:!3DES:!CAMELLIA:!TLSv1:!TLSv1_1:!SHA',
      dh_groups            => 'DEFAULT',
      signature_algorithms => 'DEFAULT',
      partition            => 'Common',
    }
    EOS
    make_site_pp(pp)
    run_device(:allow_changes => true)
    run_device(:allow_changes => false)
  end
  it 'updates a basic cipher rule called my_cipherrule' do
    pp=<<-EOS
    f5_irule { '/Common/my_cipherrule':
      ensure      => 'present',
      description => 'My secure cipher rule'
      cipher      => 'ECDHE:ECDHE_ECDSA:!SSLV3:!DES:!3DES:!CAMELLIA:!TLSv1:!TLSv1_1:!SHA',
      dh_groups            => 'DEFAULT',
      signature_algorithms => 'DEFAULT',
      partition   => 'Common',
    }
    EOS
    make_site_pp(pp)
    run_device(:allow_changes => true)
    run_device(:allow_changes => false)
  end
  it 'deletes a irule' do
    pp=<<-EOS
    f5_irule { '/Common/my_cipherrule':
      ensure   => 'absent',
    }
    EOS
    make_site_pp(pp)
    run_device(:allow_changes => true)
    run_device(:allow_changes => false)
  end
end

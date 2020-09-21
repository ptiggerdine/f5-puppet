require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/parameter/f5_name.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_address.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_availability_requirement.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_connection_limit.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_connection_rate_limit.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_description.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_health_monitors.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_ratio.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_state.rb'))

require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_truthy.rb'))

Puppet::Type.newtype(:f5_profileclientssl) do
  @doc = 'Manage Client SSL profile objects'

  apply_to_device
  ensurable

  newparam(:name, :parent => Puppet::Parameter::F5Name, :namevar => true)

  newproperty(:description, :parent => Puppet::Property::F5Description)

  newproperty(:cert) do
    desc "cert"
  end

  newproperty(:key) do
    desc "key"
  end

  newproperty(:chain) do
    desc "chain"
  end

  newproperty(:proxy_ssl, :parent => Puppet::Property::F5truthy) do
    desc "Valid values are 'enabled' or 'disabled'."
    truthy_property("Valid values are 'enabled' or 'disabled'.")
  end

  newproperty(:proxy_ssl_passthrough, :parent => Puppet::Property::F5truthy) do
    desc "Valid values are 'enabled' or 'disabled'."
    truthy_property("Valid values are 'enabled' or 'disabled'.")
  end


  newproperty(:ssl_forward_proxy, :parent => Puppet::Property::F5truthy) do
    desc "Valid values are 'enabled' or 'disabled'."
    truthy_property("Valid values are 'enabled' or 'disabled'.")
  end

  newproperty(:ssl_forward_proxy_bypass, :parent => Puppet::Property::F5truthy) do
    desc "Valid values are 'enabled' or 'disabled'."
    truthy_property("Valid values are 'enabled' or 'disabled'.")
  end

  newproperty(:peer_cert_mode) do
    desc "peer_cert_mode."
    newvalues(:'ignore', :'require')
  end

  newproperty(:authenticate) do
    desc "authenticate."
    newvalues(:'once', :'always')
  end

  newproperty(:retain_certificate, :parent => Puppet::Property::F5truthy) do
    desc "Valid values are 'enabled' or 'disabled'."
    truthy_property("Valid values are 'enabled' or 'disabled'.")
  end

  newproperty(:authenticate_depth) do
    desc "authenticate_depth."
  end

  newproperty(:partition) do
    desc "partition to install profile to."
  end

  newproperty(:parent_profile) do
    desc "Specifies the profile that you want to use as the parent profile."
  end

  newproperty(:ssl_options) do
    desc "Enables SSL options, including dont-insert-empty-fragments, no-ssl, no-tlsv1.3, no-tlsv1.2, no-tlsv1.1, no-tlsv1."
  end

  newproperty(:ciphers) do
    desc "Ciphers to enable. Default is none."
  end

  newproperty(:cipher_group) do
    desc "Group of ciphers to enable. Default is DEFAULT."
  end

end

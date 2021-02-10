require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'puppet/parameter/f5_name.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'puppet/property/f5_description.rb'))

Puppet::Type.newtype(:f5_cipherrule) do
  @doc = 'Manage cipher rule objects. Additional documentation can be found at https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/big-ip-system-ssl-traffic-management-14-1-0-1/10.html'

  apply_to_device
  ensurable

  newparam(:name, :parent => Puppet::Parameter::F5Name, :namevar => true)

  newproperty(:description, :parent => Puppet::Property::F5Description)

  newproperty(:cipher) do
    desc 'The OpenSSL cipher string defining this rule.'
  end

  newproperty(:dh_groups) do
    desc 'In TLS 1.2 and 1.3, these are the Elliptic Curve Diffie Hellman (ECDH) key agreement algorithms used to negotiate SSL/TLS connections.'
  end

  newproperty(:signature_algorithms) do
    desc 'In TLS 1.2 and 1.3, these are the digital signature algorithms for authentication.'
  end

  newproperty(:partition) do
    desc 'Displays the administrative partition within which the cipher rule resides. The application service to which the object belongs.'

    validate do |value|
      raise ArgumentError, "#{parition} must be a String" unless value.is_a?(String)
    end
  end
end

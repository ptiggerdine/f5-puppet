require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/parameter/f5_name.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_address.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_availability_requirement.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_connection_limit.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_connection_rate_limit.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_description.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_health_monitors.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_ratio.rb'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','puppet/property/f5_state.rb'))

Puppet::Type.newtype(:f5_profiletcp) do
  @doc = 'Manage http profile objects'

  apply_to_device
  ensurable

  newparam(:name, :parent => Puppet::Parameter::F5Name, :namevar => true)

  newproperty(:description, :parent => Puppet::Property::F5Description)

  newproperty(:defaults_from) do
    desc "Specifies the profile that you want to use as the parent profile. Your new profile inherits all settings and values from the parent profile specified."
    validate do |value|
      fail ArgumentError, "Values must take the form /Partition/name; #{value} does not" unless value =~ /^\/[\w\.-]+\/[\w|\.-]+$/
    end
  end

  newproperty(:closewait_timeout) do
    desc "Specifies the number of seconds that a connection remains in a LAST-ACK state before quitting."
    validate do |value|
      fail ArgumentError, "Valid options: <Integer>" unless value =~ /^\d+$/ || value.is_a?(Integer)
    end
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:fin_wait_timeout) do
    desc "Specifies the number of seconds that a connection is in the FIN-WAIT-1 or closing state before quitting."
    validate do |value|
      fail ArgumentError, "Valid options: <Integer>" unless value =~ /^\d+$/ || value.is_a?(Integer)
    end
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:fin_wait2_timeout) do
    desc "Specifies the number of seconds that a connection is in the FIN-WAIT-2 state before quitting."
    validate do |value|
      fail ArgumentError, "Valid options: <Integer>" unless value =~ /^\d+$/ || value.is_a?(Integer)
    end
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:idle_timeout) do
    desc "Specifies the number of seconds that a connection is idle before the connection is eligible for deletion."
    validate do |value|
      fail ArgumentError, "Valid options: <Integer>" unless value =~ /^\d+$/ || value.is_a?(Integer)
    end
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:keep_alive_interval) do
    desc "Specifies the keep alive probe interval, in seconds."
    validate do |value|
      fail ArgumentError, "Valid options: <Integer>" unless value =~ /^\d+$/ || value.is_a?(Integer)
    end
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:minimum_rto) do
    desc "Specifies the minimum TCP retransmission timeout in milliseconds."
    validate do |value|
      fail ArgumentError, "Valid options: <Integer>" unless value =~ /^\d+$/ || value.is_a?(Integer)
    end
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:reset_on_timeout) do
    desc "Specifies the minimum TCP retransmission timeout in milliseconds."
    newvalue("enabled")
    newvalue("disabled")
  end

  newproperty(:time_wait_timeout) do
    desc "Specifies the number of milliseconds that a connection is in the TIME-WAIT state before closing."
    validate do |value|
      fail ArgumentError, "Valid options: <Integer>" unless value =~ /^\d+$/ || value.is_a?(Integer)
    end
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:time_wait_recycle) do
    desc "Specifies whether the system recycles the connection when a SYN packet is received in a TIME-WAIT state."
    newvalue("enabled")
    newvalue("disabled")
  end

  newproperty(:zero_windows_timeout) do
    desc "Specifies the timeout in milliseconds for terminating a connection with an effective zero length TCP transmit window."
    validate do |value|
      fail ArgumentError, "Valid options: <Integer>" unless value =~ /^\d+$/ || value.is_a?(Integer)
    end
    munge do |value|
      Integer(value)
    end
  end
end

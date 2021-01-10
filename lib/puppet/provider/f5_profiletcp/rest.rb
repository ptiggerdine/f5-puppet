require File.join(File.dirname(__FILE__), '../f5')
require 'json'

Puppet::Type.type(:f5_profiletcp).provide(:rest, parent: Puppet::Provider::F5) do

  def self.instances
    instances = []
    profiles = Puppet::Provider::F5.call_items('/mgmt/tm/ltm/profile/tcp')
    return [] if profiles.nil?

    profiles.each do |profile|
      full_path_uri = profile['fullPath'].gsub('/','~')

      instances << new(
        ensure:               :present,
        name:                 profile['fullPath'],
        description:          profile['description'],
        close_wait_timeout:   profile['closeWaitTimeout'],
        fin_wait_timeout:     profile['finWaitTimeout'],
        defaults_from:        profile['defaultsFrom'],
        fin_wait2_timeout:    profile['finWait-2Timeout'],
        idle_timeout:         profile['idleTimeout'],
        keep_alive_interval:  profile['keepAliveInterval'],
        minimum_rto:          profile['minimumRto'],
        reset_on_timeout:     profile['resetOnTimeout'],
        time_wait_timeout:    profile['timeWaitTimeout'],
        time_wait_recycle:    profile['timeWaitRecycle'],
        zero_windows_timeout: profile['zeroWindowTimeout'],
      )
    end

    instances
  end

  def self.prefetch(resources)
    profiles = instances
    resources.keys.each do |name|
      if provider = profiles.find {|profile| profile.name == name}
        resources[name].provider = provider
      end
    end
  end

  def create_message(basename, partition, hash)
    # Create the message by stripping :present.
    new_hash = hash.reject {|k, _| [:ensure, :provider, Puppet::Type.metaparams].flatten.include?(k)}
    new_hash[:name] = basename
    new_hash[:partition] = partition

    return new_hash
  end


  def message(object)
    # Allows us to pass in resources and get all the attributes out
    # in the form of a hash.
    message = object.to_hash

    # Map for conversion in the message.
    map = {
        :'close-wait-timeout' => :closeWaitTimeout,
        :'fin-wait-timeout' => :finWaitTimeout,
        :'fin-wait2-timeout' => :finWait_2Timeout,
        :'idle-timeout' => :idleTimeout,
        :'defaults-from' => :defaultsFrom,
        :'keep-alive-interval' => :keepAliveInterval,
        :'minimum-rto' => :minimumRto,
        :'reset-on-timeout' => :resetOnTimeout,
        :'time-wait-timeout' => :timeWaitTimeout,
        :'time-wait-recycle' => :timeWaitRecycle,
        :'zero-windows-timeout' => :zeroWindowTimeout,
    }

    message = strip_nil_values(message)
    message = convert_underscores(message)
    message = create_message(basename, partition, message)
    message = rename_keys(map, message)
    message = string_to_integer(message)

    message.to_json
  end

  def flush
    if @property_hash != {}
      full_path_uri = resource[:name].gsub('/','~')
      result = Puppet::Provider::F5.patch("/mgmt/tm/ltm/profile/tcp/#{full_path_uri}", message(resource))
    end
    return result
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    result = Puppet::Provider::F5.post("/mgmt/tm/ltm/profile/tcp", message(resource))
    # We clear the hash here to stop flush from triggering.
    @property_hash.clear

    return result
  end

  def destroy
    full_path_uri = resource[:name].gsub('/','~')
    result = Puppet::Provider::F5.delete("/mgmt/tm/ltm/profile/tcp/#{full_path_uri}")
    @property_hash.clear

    return result
  end

  mk_resource_methods

end

require File.join(File.dirname(--FILE--), '../f5')
require 'json'

Puppet::Type.type(:f5_profiletcp).provide(:rest, parent: Puppet::Provider::F5) do

  def self.instances
    instances = []
    profiles = Puppet::Provider::F5.call-items('/mgmt/tm/ltm/profile/tcp')
    return [] if profiles.nil?

    profiles.each do |profile|
      full-path-uri = profile['fullPath'].gsub('/','~')

      instances << new(
          ensure: :present,
          name: profile['fullPath'],
          description: profile['description'],
          closewait-timeout: profile['closeWaitTimeout'],
          fin-wait-timeout: profile['finWaitTimeout'],
          defaults-from: profile['defaultsFrom'],
          fin-wait2-timeout: profile['finWait-2Timeout'],
          idle-timeout: profile['idleTimeout'],
          keep-alive-interval: profile['keepAliveInterval'],
          minimum-rto: profile['minimumRto'],
          reset-on-timeout: profile['resetOnTimeout'],
          time-wait-timeout: profile['timeWaitTimeout'],
          time-wait-recycle: profile['timeWaitRecycle'],
          zero-windows-timeout: profile['zeroWindowTimeout'],
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

  def create-message(basename, partition, hash)
    # Create the message by stripping :present.
    new-hash = hash.reject {|k, -| [:ensure, :provider, Puppet::Type.metaparams].flatten.include?(k)}
    new-hash[:name] = basename
    new-hash[:partition] = partition

    return new-hash
  end


  def message(object)
    # Allows us to pass in resources and get all the attributes out
    # in the form of a hash.
    message = object.to-hash

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

    message = strip-nil-values(message)
    # message = convert-hsts(message)
    message = convert-underscores(message)
    message = create-message(basename, partition, message)
    message = rename-keys(map, message)
    message = string-to-integer(message)

    message.to-json
  end

  # def convert-hsts(hash)
  #   hash[:hsts] =
  #       rename-keys(
  #           {
  #               :hsts-maximum-age => 'maximum-age',
  #               :hsts-include-subdomains => 'include-subdomains',
  #               :hsts-mode => 'mode',
  #               :hsts-preload => 'preload',
  #           },
  #           strip-nil-values(hash.select {|key, value| key.to-s.start-with?('hsts-')}))
  #   hash.reject {|key, value| key.to-s.start-with?('hsts-')}
  # end

  def flush
    if @property-hash != {}
      full-path-uri = resource[:name].gsub('/','~')
      result = Puppet::Provider::F5.patch("/mgmt/tm/ltm/profile/tcp/#{full-path-uri}", message(resource))
    end
    return result
  end

  def exists?
    @property-hash[:ensure] == :present
  end

  def create
    result = Puppet::Provider::F5.post("/mgmt/tm/ltm/profile/tcp", message(resource))
    # We clear the hash here to stop flush from triggering.
    @property-hash.clear

    return result
  end

  def destroy
    full-path-uri = resource[:name].gsub('/','~')
    result = Puppet::Provider::F5.delete("/mgmt/tm/ltm/profile/tcp/#{full-path-uri}")
    @property-hash.clear

    return result
  end

  mk-resource-methods

end

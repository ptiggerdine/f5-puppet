require File.join(File.dirname(__FILE__), '../f5')
require 'json'

Puppet::Type.type(:f5_cipherrule).provide(:rest, parent: Puppet::Provider::F5) do

  def initialize(value={})
    super(value)
    @create_elements = false
  end

  def self.instances
    instances = []
    cipherrules = Puppet::Provider::F5.call_items('/mgmt/tm/ltm/cipher/rule')
    return [] if cipherrules.nil?

    cipherrules.each do |cipherrule|
      full_path_uri = profile['fullPath'].gsub('/','~')

      instances << new(
        name:                  cipherrule['fullPath'],
        ensure:                :present,
        cipher:                cipherrule['cipher'],
        description:           cipherrule['description'],
        partition:             cipherrule['tmPartition'] || 'Common',
        dh_groups:             cipherrule['dhGroups'],
        signature_algorithms:  cipherrule['signatureAlgorithms'],
      )
    end
    instances
  end

  def self.prefetch(resources)
    ciphers = instances
    resources.keys.each do |name|
      if provider = ciphers.find { |ciphers| ciphers.name == name }
        resources[name].provider = provider
      end
    end
  end

  def create_message(basename, partition, hash )
    # Create the message by stripping :present.
    new_hash             = hash.reject { |k, _| [:ensure, :provider, Puppet::Type.metaparams].flatten.include?(k) }
    new_hash[:name]      = basename
    if "#{partition}" != 'absent'
      new_hash[:partition] = partition
    else
      calculated_partition = resource[:name].split('/')[1]
      Puppet.notice("ignore bug 'absent' value of partition, use #{resource[:name]} and calculated #{calculated_partition}")
      new_hash[:partition] = calculated_partition
    end
    return new_hash
  end

  def message(object)
    # Allows us to pass in resources and get all the attributes out
    # in the form of a hash.
    message = object.to_hash

    # Map for conversion in the message.
    map = {
      :partition               => :tmPartition,
      :'dh-groups'            => :dhGroups,
      :'signature-algorithms' => :signatureAlgorithms,
    }

    message = strip_nil_values(message)
    message = convert_underscores(message)
    message = rename_keys(map, message)
    message = create_message(basename, partition, message, chain)
    message = string_to_integer(message)

    message.to_json
  end

  def flush
    if @property_hash != {}
      result = Puppet::Provider::F5.put("/mgmt/tm/ltm/cipher/rule/#{api_name}", message(@property_hash))
    end
    return result
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    @create_elements = true
    result = Puppet::Provider::F5.post('/mgmt/tm/ltm/cipher/rule', message(resource))
    # We clear the hash here to stop flush from triggering.
    @property_hash.clear

    return result
  end

  def destroy
    result = Puppet::Provider::F5.delete("/mgmt/tm/ltm/cipher/rule/#{api_name}")
    @property_hash.clear

    return result
  end

  mk_resource_methods

end

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
      instances << new(
        name:                  cipherrule['fullPath'],
        ensure:                :present,
        cipher:                cipherrule['cipher'],
        description:           cipherrule['description'],
        parition:              cipherrule['tmPartition'] || 'Common',
        dh_groups:             cipherrule['dhGroups'],
        signature_algorithms:  cipherrule['signatureAlgorithms'],
      )
    end
    instances
  end

  def self.prefetch(resources)
    nodes = instances
    resources.keys.each do |name|
      if provider = nodes.find { |node| node.name == name }
        resources[name].provider = provider
      end
    end
  end

  def message(object)
    # Allows us to pass in resources and get all the attributes out
    # in the form of a hash.
    message = object.to_hash

    # Map for conversion in the message.
    map = {
      :parition               => :tmParition,
      :'dh-groups'            => :dhGroups,
      :'signature-algorithms' => :signatureAlgorithms,
    }

    message = convert_underscores(message)
    message = rename_keys(map, message)
    message = create_message(basename, message)

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

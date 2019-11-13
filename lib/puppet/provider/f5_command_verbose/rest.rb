require File.join(File.dirname(__FILE__), '../f5')
require 'json'

Puppet::Type.type(:f5_command_verbose).provide(:rest, parent: Puppet::Provider::F5) do

  def message(object)
    # Allows us to pass in resources and get all the attributes out
    # in the form of a hash.
    message = object.to_hash

    # Map for conversion in the message.
    map = {
    }

   command = message[:tmsh]
   command ="-c " + "\"" + command +"\""
   message = {"command"=> "run", "utilCmdArgs"=> command }
 
  message.to_json
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    result = Puppet::Provider::F5.post("/mgmt/tm/util/bash", message(resource))
    # We clear the hash here to stop flush from triggering.
    @property_hash.clear
    m = resource.to_hash
    Puppet.notice "TMSH: description " + m[:description] if m[:description]
    rb = JSON.parse(result.body)
    Puppet.warning "TMSH commandResult " + rb['commandResult'].chomp if rb['commandResult']
    return result
  end

  mk_resource_methods

end

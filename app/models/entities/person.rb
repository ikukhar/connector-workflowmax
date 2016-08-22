class Entities::Person < Maestrano::Connector::Rails::Entity

  def self.connec_entity_name
    'Person'
  end

  def self.external_entity_name
    'Client'
  end

  def self.mapper_class
    PersonMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    "#{entity['first_name']} #{entity['last_name']}"
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['Name']
  end

  def get_external_entities(external_entity_name, last_synchronization_date = nil)
    entities = super
    entities['Response']['Clients']['Client']
  end

  class PersonMapper
    extend HashMapper

    # Mapping to WorkflowMax
    after_normalize do |input, output|
      output['Name'] = [input["first_name"], input["last_name"]].join(' ')
      output
    end

    # Mapping to Connec!
    after_denormalize do |input, output|
      head, *tail = input['Name'].split(",")[0].split(" ")
      output['first_name'] = head
      output['last_name'] = tail.join(" ")
      output
    end

    map from('first_name'), to('first_name')
    map from('last_name'), to('last_name')
    map from('email/address'), to('Email')

  end

end

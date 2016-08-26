class Entities::LeadPerson < Maestrano::Connector::Rails::Entity

  def self.connec_entity_name
    'Person'
  end

  def self.external_entity_name
    'Lead'
  end

  def self.mapper_class
    LeadPersonMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    "#{entity['first_name']} #{entity['last_name']}"
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['Name']
  end

  class LeadPersonMapper
    extend HashMapper

    # Mapping to Connec!
    before_denormalize do |input, output|
      head, *tail = input['Name'].split(",")[0].split(" ")
      input['first_name'] = head
      input['last_name'] = tail.join(" ")
      input['is_lead'] = true

      input
    end

    map from('first_name'), to('first_name')
    map from('last_name'), to('last_name')
    map from('is_lead'), to('is_lead')
  end
end

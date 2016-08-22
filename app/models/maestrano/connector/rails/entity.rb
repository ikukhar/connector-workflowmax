class Maestrano::Connector::Rails::Entity < Maestrano::Connector::Rails::EntityBase
  include Maestrano::Connector::Rails::Concerns::Entity

  # In this class and in all entities which inherit from it, the following instance variables are available:
  # * @organization
  # * @connec_client
  # * @external_client
  # * @opts

  # Return an array of entities from the external app
  def get_external_entities(external_entity_name, last_synchronization_date = nil)
    Maestrano::Connector::Rails::ConnectorLogger.log('info', @organization, "Fetching #{Maestrano::Connector::Rails::External.external_name} #{self.class.external_entity_name.pluralize}")
    entities = @external_client.find(self.class.external_entity_name)
    Maestrano::Connector::Rails::ConnectorLogger.log('info', @organization, "Received data: Source=#{Maestrano::Connector::Rails::External.external_name}, Entity=#{self.class.external_entity_name}, Response=#{entities}")
    entities
  end

  def create_external_entity(mapped_connec_entity, external_entity_name)
    Maestrano::Connector::Rails::ConnectorLogger.log('info', @organization, "Sending create #{external_entity_name}: #{mapped_connec_entity} to #{Maestrano::Connector::Rails::External.external_name}")
    @external_client.create(external_entity_name, mapped_connec_entity)
  end

  def update_external_entity(mapped_connec_entity, external_id, external_entity_name)
    Maestrano::Connector::Rails::ConnectorLogger.log('info', @organization, "Sending update #{external_entity_name} (id=#{external_id}): #{mapped_connec_entity} to #{Maestrano::Connector::Rails::External.external_name}")
  end

  def self.id_from_external_entity_hash(entity)
    entity['ID']
  end

  def self.last_update_date_from_external_entity_hash(entity)
    # TODO update_date
    Time.now.beginning_of_year
  end

  def self.creation_date_from_external_entity_hash(entity)
    # TODO creation_date
    Time.now.beginning_of_year
  end

  def self.inactive_from_external_entity_hash?(entity)
    false
  end
end

class Maestrano::Connector::Rails::External
  include Maestrano::Connector::Rails::Concerns::External

  def self.external_name
    'workflowmax'
  end

  def self.get_client(organization)
    WorkflowmaxClient.new(organization.oauth_uid, organization.oauth_token)
  end

  def self.create_account_link(organization = nil)
    'https://www.workflowmax.com'
  end

  # Return an array of all the entities that the connector can synchronize
  # If you add new entities, you need to generate
  # a migration to add them to existing organizations
  def self.entities_list
    %w(person)
  end
end

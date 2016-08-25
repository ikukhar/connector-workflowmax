class WorkflowmaxClient
  require 'rest-client'

  attr_reader :api_key
  attr_reader :account_key

  def initialize(api_key, account_key)
    @api_key = api_key
    @account_key = account_key
  end

  def find(external_entity_name, params = {})
    DataParser.from_xml(RestClient.get url(external_entity_name, 'list'))
  end

  def create(external_entity_name, mapped_connec_entity)
    body = DataParser.to_xml(mapped_connec_entity, external_entity_name)
    # RestClient.post url(external_entity_name, 'add'), body
  end

  def update(external_entity_name, mapped_connec_entity)
    body = DataParser.to_xml(mapped_connec_entity, external_entity_name)
    RestClient.put url(external_entity_name, 'update'), body
  end

  private

  def url(entity_name, action)
    "https://api.workflowmax.com/#{entity_name.downcase}.api/#{action}?apiKey=#{@api_key}&accountKey=#{@account_key}&detailed=true"
  end

end

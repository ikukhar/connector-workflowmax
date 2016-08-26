class WorkflowmaxClient
  require 'rest-client'

  attr_reader :api_key
  attr_reader :account_key

  def initialize(api_key, account_key)
    @api_key = api_key
    @account_key = account_key
  end

  def self.auth_check(api_key, account_key)
    RestClient.get "https://api.workflowmax.com/client.api/list?apiKey=#{api_key}&accountKey=#{account_key}"
    true
  rescue => e
    Rails.logger.warn "Error auth checking. Error: #{e}"
    false
  end

  def get_entities(external_entity_name, params = {})
    DataParser.from_xml(RestClient.get url(external_entity_name, 'list'))
  rescue => e
    Rails.logger.warn "Error while fetching #{entity_name.pluralize}. Error: #{e}"
    raise "Error while fetching #{entity_name}. Error: #{e}"
  end

  def create(external_entity_name, mapped_connec_entity)
    body = DataParser.to_xml(mapped_connec_entity, external_entity_name)
    response = RestClient.post url(external_entity_name, 'add'), body
    id = DataParser.from_xml(response)['Response'][external_entity_name]['ID']
    puts 'create response ID'
    puts id
    id
  rescue => e
    standard_rescue(e, external_entity_name)
  end

  def update(external_entity_name, mapped_connec_entity)
    body = DataParser.to_xml(mapped_connec_entity, external_entity_name)
    response = RestClient.put url(external_entity_name, 'update'), body
    data = DataParser.from_xml(response)['Response'][external_entity_name]
    puts 'update response'
    puts data
    data
  rescue => e
    if e.class == RestClient::ResourceNotFound
      raise Exceptions::RecordNotFound.new("The record has been deleted in BaseCRM")
    else
      standard_rescue(e, external_entity_name)
    end
  end

  private

  def url(entity_name, action)
    "https://api.workflowmax.com/#{entity_name.downcase}.api/#{action}?apiKey=#{@api_key}&accountKey=#{@account_key}&detailed=true"
  end

  def standard_rescue(e, external_entity_name)
    err = e.respond_to?(:response) ? e.response : e
    Rails.logger.warn "Error while posting to #{external_entity_name}: #{err}"
    raise "Error while sending data: #{err}"
  end
end
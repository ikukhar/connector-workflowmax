require 'singleton'

class DataParser
  include Singleton

  def self.from_xml(xml_str)
    JSON.parse(Hash.from_xml(xml_str).to_json)
  end

  def self.to_xml(entity, entity_name)
    entity.to_h.to_xml(:root => entity_name)
  end
end
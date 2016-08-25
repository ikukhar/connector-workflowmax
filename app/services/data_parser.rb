require 'singleton'

class DataParser
  include Singleton

  def self.from_xml(xml_str)
    JSON.parse(Hash.from_xml(xml_str).to_json)
  end

  def self.to_xml(entity, entity_name)
    entity.to_h.to_xml(:root => entity_name)
  end

  def deep_find(key, object=self, found=nil)
    if object.respond_to?(:key?) && object.key?(key)
      return object[key]
    elsif object.is_a? Enumerable
      object.find { |*a| found = deep_find(key, a.last) }
      return found
    end
  end

  def save_pair(parent, myHash)
    myHash.each {|key, value|
      value.is_a?(Hash) ? save_pair(key, value) :
          puts("parent=#{parent.nil? ? 'none':parent}, (#{key}, #{value})")
    }
  end

end
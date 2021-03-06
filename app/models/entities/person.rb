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
    entities = super['Clients']
    puts '--------------------entities---------------------'
    puts entities
    if entities
      entities = entities['Client']
      entities.is_a?(Hash) ? [entities] : entities
    else
      []
    end
  end


  class NotesLineMapper
    extend HashMapper

    map from('description'), to('Title')
    map from('value'), to('Text')
  end


  class PersonMapper
    extend HashMapper

    # Mapping to WorkflowMax
    after_normalize do |input, output|
      output['Name'] = [output[:first_name], output[:last_name]].join(' ')
      output.delete(:first_name)
      output.delete(:last_name)

      notes = output[:Notes]
      if notes && notes.count == 1
        notes = notes.first
      end
      output['Notes'] = { 'Note' => notes }

      output
    end

    # Mapping to Connec!
    before_denormalize do |input, output|
      head, *tail = input['Name'].split(",")[0].split(" ")
      input['first_name'] = head
      input['last_name'] = tail.join(" ")

      if input['Notes']
        notes = input['Notes']['Note']
        notes = notes.is_a?(Hash) ? [notes] : notes
        input['Notes'] =  notes
      end

      input
    end


    map from('first_name'), to('first_name')
    map from('last_name'), to('last_name')
    map from('email/address'), to('Email')
    map from('phone_work/landline'), to('Phone')

    map from('address_work/billing/line1'), to('Address')
    map from('address_work/billing/city'), to('City')
    map from('address_work/billing/region'), to('Region')
    map from('address_work/billing/postal_code'), to('PostCode')
    map from('address_work/billing/country'), to('Country')
    map from('notes'), to('Notes'), using: NotesLineMapper

  end

end

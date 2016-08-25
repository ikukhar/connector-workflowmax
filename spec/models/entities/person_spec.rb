require 'spec_helper'

describe Entities::Person do
  describe 'class methods' do
    subject { Entities::Person }

    it { expect(subject.connec_entity_name).to eql('Person') }
    it { expect(subject.external_entity_name).to eql('Client') }
    it { expect(subject.mapper_class).to eql(Entities::Person::PersonMapper) }
    it { expect(subject.object_name_from_connec_entity_hash({'first_name' => 'Robert', 'last_name' => 'Patinson'})).to eql('Robert Patinson') }
    it { expect(subject.object_name_from_external_entity_hash({'Name' => 'Robert Patinson'})).to eql('Robert Patinson') }
  end

  describe 'instance methods' do
    let!(:organization) { create(:organization) }
    subject { Entities::Person.new(organization,nil,nil) }

    describe 'connec_model_to_external_model' do
      let(:connec_hash) {
        {
            first_name: 'Robert',
            last_name: 'Patinson',
            email: {
                address: 'robert.patinson@touilaight.com'
            },
            phone_work: '(02) 1723 5265',
            address_work: {
                billing: {
                    line1:  "Level 32, PWC Building\n        188 Quay Street\n        Auckland Central",
                    city: 'Auckland',
                    region: 'Auckland',
                    postal_code: '1001',
                    country: 'New Zealand'
                }
            },
            notes: {
              description: 'Krakens sing with beauty1',
              value: 'Heu, mirabilis navis!'

            }
        }
      }
      let(:external_hash) { DataParser.from_xml(File.read('spec/fixtures/entities/external_clients.xml'))['Response']['Clients']['Client'] }

      it { expect(subject.map_to_connec(external_hash.with_indifferent_access)).to eql(connec_hash.merge({id:[{id:'id', provider: organization.oauth_provider, realm: organization.oauth_uid}]}).with_indifferent_access) }
      it { expect(subject.map_to_external(connec_hash.with_indifferent_access)).to eql(external_hash.with_indifferent_access.except('ID')) }

    end
  end
end

require 'spec_helper'

describe Entities::LeadPerson do
  describe 'class methods' do
    subject { Entities::LeadPerson }

    it { expect(subject.connec_entity_name).to eql('Person') }
    it { expect(subject.external_entity_name).to eql('Lead') }
    it { expect(subject.mapper_class).to eql(Entities::LeadPerson::LeadPersonMapper) }
    it { expect(subject.object_name_from_connec_entity_hash({'first_name' => 'Brochure', 'last_name' => 'Design'})).to eql('Brochure Design') }
    it { expect(subject.object_name_from_external_entity_hash({'Name' => 'Brochure Design'})).to eql('Brochure Design') }

  end

  describe 'instance methods' do
    let!(:organization) { create(:organization) }
    subject { Entities::LeadPerson.new(organization,nil,nil) }

    describe 'connec_model_to_external_model' do
      let(:connec_hash) {
        {
            first_name: 'Brochure',
            last_name: 'Design',
            is_lead: true
        }
      }
      let(:external_hash) { DataParser.from_xml(File.read('spec/fixtures/entities/external_leads.xml'))['Response']['Leads']['Lead'] }

      it { expect(subject.map_to_connec(external_hash.with_indifferent_access)).to eql(connec_hash.merge({id:[{id:'id', provider: organization.oauth_provider, realm: organization.oauth_uid}]}).with_indifferent_access) }
      it { expect(subject.map_to_external(connec_hash.with_indifferent_access)).to eql(external_hash.with_indifferent_access.except('ID')) }

    end
  end
end

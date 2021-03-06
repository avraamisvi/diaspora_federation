module DiasporaFederation
  describe Validators::StatusMessageValidator do
    let(:entity) { :status_message_entity }

    it_behaves_like "a common validator"

    it_behaves_like "a diaspora id validator" do
      let(:property) { :author }
      let(:mandatory) { true }
    end

    it_behaves_like "a guid validator" do
      let(:property) { :guid }
    end

    describe "#photos" do
      it_behaves_like "a property with a value validation/restriction" do
        let(:property) { :photos }
        let(:wrong_values) { [nil] }
        let(:correct_values) { [[], [FactoryGirl.build(:photo_entity)]] }
      end
    end

    it_behaves_like "a boolean validator" do
      let(:property) { :public }
    end
  end
end

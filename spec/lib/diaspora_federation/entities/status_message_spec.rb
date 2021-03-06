module DiasporaFederation
  describe Entities::StatusMessage do
    let(:photo1) { FactoryGirl.build(:photo_entity) }
    let(:photo2) { FactoryGirl.build(:photo_entity) }
    let(:location) { FactoryGirl.build(:location_entity) }
    let(:data) {
      FactoryGirl.attributes_for(:status_message_entity).merge!(
        photos:                [photo1, photo2],
        location:              location,
        poll:                  nil,
        provider_display_name: "something"
      )
    }

    let(:xml) {
      <<-XML
<status_message>
  <diaspora_handle>#{data[:author]}</diaspora_handle>
  <guid>#{data[:guid]}</guid>
  <created_at>#{data[:created_at]}</created_at>
  <provider_display_name>#{data[:provider_display_name]}</provider_display_name>
  <raw_message>#{data[:raw_message]}</raw_message>
  <photo>
    <guid>#{photo1.guid}</guid>
    <diaspora_handle>#{photo1.author}</diaspora_handle>
    <public>#{photo1.public}</public>
    <created_at>#{photo1.created_at}</created_at>
    <remote_photo_path>#{photo1.remote_photo_path}</remote_photo_path>
    <remote_photo_name>#{photo1.remote_photo_name}</remote_photo_name>
    <text>#{photo1.text}</text>
    <status_message_guid>#{photo1.status_message_guid}</status_message_guid>
    <height>#{photo1.height}</height>
    <width>#{photo1.width}</width>
  </photo>
  <photo>
    <guid>#{photo2.guid}</guid>
    <diaspora_handle>#{photo2.author}</diaspora_handle>
    <public>#{photo2.public}</public>
    <created_at>#{photo2.created_at}</created_at>
    <remote_photo_path>#{photo2.remote_photo_path}</remote_photo_path>
    <remote_photo_name>#{photo2.remote_photo_name}</remote_photo_name>
    <text>#{photo2.text}</text>
    <status_message_guid>#{photo2.status_message_guid}</status_message_guid>
    <height>#{photo2.height}</height>
    <width>#{photo2.width}</width>
  </photo>
  <location>
    <address>#{location.address}</address>
    <lat>#{location.lat}</lat>
    <lng>#{location.lng}</lng>
  </location>
  <public>#{data[:public]}</public>
</status_message>
      XML
    }
    let(:string) { "StatusMessage:#{data[:guid]}" }

    it_behaves_like "an Entity subclass"

    it_behaves_like "an XML Entity"

    context "default values" do
      let(:minimal_xml) {
        <<-XML
<status_message>
  <author>#{data[:author]}</author>
  <guid>#{data[:guid]}</guid>
  <created_at>#{data[:created_at]}</created_at>
  <raw_message>#{data[:raw_message]}</raw_message>
</status_message>
        XML
      }

      it "uses default values" do
        parsed_instance = DiasporaFederation::Salmon::XmlPayload.unpack(Nokogiri::XML::Document.parse(minimal_xml).root)
        expect(parsed_instance.photos).to eq([])
        expect(parsed_instance.location).to be_nil
        expect(parsed_instance.poll).to be_nil
        expect(parsed_instance.public).to be_falsey
        expect(parsed_instance.provider_display_name).to be_nil
      end
    end
  end
end

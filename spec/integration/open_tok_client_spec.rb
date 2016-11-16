describe OpenTokClient do
  describe 'dump and load session' do
    let(:session) do
      VCR.use_cassette('open_tok_create_session') do
        described_class.new.create_session
      end
    end

    let(:dump) { described_class.dump_session(session) }
    let(:loaded_session) { described_class.load_session(dump) }
    let(:attributes) { %i(api_key api_secret archive_mode location media_mode session_id) }

    it 'should serialize and deserialize all attributes' do
      attributes.each do |attribute|
        expect(loaded_session.public_send(attribute)).to eq session.public_send(attribute)
      end
    end
  end
end
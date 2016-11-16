class OpenTokClient
  def initialize
    @client = OpenTok::OpenTok.new(api_key, api_secret)
  end

  def create_session
    @client.create_session(media_mode: :relayed)
  end

  class << self
    def dump_session(session)
      {
        api_key: session.api_key,
        api_secret: session.api_secret,
        session_id: session.session_id,
        media_mode: session.media_mode,
        location: session.location,
        archive_mode: session.archive_mode,
      }
    end

    def load_session(json)
      json = json.symbolize_keys
      api_key = json.delete(:api_key)
      api_secret = json.delete(:api_secret)
      session_id = json.delete(:session_id)

      OpenTok::Session.new(api_key, api_secret, session_id, json)
    end
  end

  private

  def api_key
    Settings.open_tok.api_key
  end

  def api_secret
    Settings.open_tok.api_secret
  end
end
class ChatRoom < ActiveRecord::Base
  validates :name, :session_dump, presence: true
  validates :name, uniqueness: true

  def session
    if session_dump
      OpenTokClient.load_session(session_dump)
    end
  end

  def session=(value)
    self.session_dump = OpenTokClient.dump_session(value)
  end
end

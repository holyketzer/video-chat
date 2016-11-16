class ChatRoomsController < ApplicationController
  before_action :load_chat_room, only: [:show, :edit, :update, :destroy, :join]

  def index
    @chat_rooms = ChatRoom.all
  end

  def show
  end

  def join
    session = @chat_room.session
    token = session.generate_token(role: :moderator, data: { username: 'Alex' }.to_json)

    render json: {
      api_key: session.api_key,
      session_id: session.session_id,
      token: token,
    }
  end

  def new
    @chat_room = ChatRoom.new
    render 'form'
  end

  def create
    @chat_room = ChatRoom.new(chat_room_params)
    @chat_room.session = OpenTokClient.new.create_session

    if @chat_room.save
      render 'show'
    else
      render 'form'
    end
  end

  def edit
    render 'form'
  end

  def update
    if @chat_room.update_attributes(chat_room_params)
      render 'show'
    else
      render 'form'
    end
  end

  def destroy
    @chat_room.destroy
    redirect_to :index
  end

  private

  def load_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def chat_room_params
    params.require(:chat_room).permit(:name)
  end
end
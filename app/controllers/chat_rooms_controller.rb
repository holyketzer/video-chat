class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_chat_room, only: [:show, :edit, :update, :destroy, :join]

  def index
    @chat_rooms = ChatRoom.all
  end

  def show
  end

  def join
    session = @chat_room.session
    role = can?(:manage, @chat_room) ? :moderator : :publisher

    token = session.generate_token(role: role, data: { username: current_user.email }.to_json)

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
    @chat_room = ChatRoom.new(
      session: OpenTokClient.new.create_session,
      owner: current_user,
      **chat_room_params.symbolize_keys,
    )

    if @chat_room.save
      render 'show'
    else
      render 'form'
    end
  end

  def edit
    authorize! :manage, @chat_room
    render 'form'
  end

  def update
    authorize! :manage, @chat_room
    if @chat_room.update_attributes(chat_room_params)
      render 'show'
    else
      render 'form'
    end
  end

  def destroy
    authorize! :manage, @chat_room
    @chat_room.destroy
    redirect_to [:chat_rooms]
  end

  private

  def load_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def chat_room_params
    params.require(:chat_room).permit(:name)
  end
end
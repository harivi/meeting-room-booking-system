class MeetingRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_meeting_room, only: [:edit, :update, :destroy]

  def index
    @meeting_rooms = MeetingRoom.all
    
    
  end

  def new
    @meeting_room = MeetingRoom.new
  end

  def create
    @meeting_room = MeetingRoom.new(meeting_room_params)
    if @meeting_room.save
      redirect_to meeting_rooms_path, notice: "Meeting room successfully created!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @meeting_room.update(meeting_room_params)
      redirect_to meeting_rooms_path, notice: "Meeting room updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    if @meeting_room.bookings.any?
      redirect_to meeting_rooms_path, alert: "Cannot delete a room with existing bookings!"
    else
      @meeting_room.destroy
      redirect_to meeting_rooms_path, notice: "Meeting room deleted successfully!"
    end
  end

  private

  def check_admin
    redirect_to root_path, alert: "Access Denied" unless current_user.role == "admin"
  end

  def set_meeting_room
    @meeting_room = MeetingRoom.find(params[:id])
  end

  def meeting_room_params
    params.require(:meeting_room).permit(:room_name, :capacity, :location)
  end
end

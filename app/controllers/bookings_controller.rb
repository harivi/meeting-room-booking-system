class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_employee, except: [:availability] 
  before_action :set_booking, only: [:destroy]

  def index
    @meeting_rooms = MeetingRoom.all
    @bookings = Booking.where(user: current_user)
  end

  def new
    @booking = Booking.new
    @meeting_rooms = MeetingRoom.all
  end

  def create
    @booking = current_user.bookings.build(booking_params)

    
    overlapping_booking = Booking.where(meeting_room_id: @booking.meeting_room_id, date: @booking.date)
                                 .where("start_time < ? AND end_time > ?", @booking.end_time, @booking.start_time)
                                 .exists?

    
    total_booked_hours = Booking.where(user: current_user, date: @booking.date)
                                .sum("EXTRACT(EPOCH FROM (end_time - start_time))/3600") # Converts seconds to hours

    if overlapping_booking
      redirect_to bookings_path, alert: "This time slot is already booked!"
    elsif total_booked_hours + ((@booking.end_time - @booking.start_time) / 1.hour) > 2
      redirect_to bookings_path, alert: "You cannot book more than 2 hours per day!"
    elsif @booking.save
      redirect_to bookings_path, notice: "Room successfully booked!"
    else
      render :new
    end
  end

  def destroy
    # @booking = Booking.find(params[:id])

    if @booking.date > Date.today || (@booking.date == Date.today && @booking.start_time > Time.now)
      @booking.destroy
      redirect_to bookings_path, notice: "Booking successfully cancelled!"
    else
      redirect_to bookings_path, alert: "You cannot cancel a past or ongoing booking!"
    end
  end

  
  def availability
    @date = params[:date] || Date.today
    booked_room_ids = Booking.where(date: @date).pluck(:meeting_room_id)
  
    
    @available_rooms = booked_room_ids.present? ? MeetingRoom.where.not(id: booked_room_ids) : MeetingRoom.all
  
    
    Rails.logger.info "Available Rooms: #{@available_rooms.inspect}"
  end
  

  private

  def check_employee
    redirect_to root_path, alert: "Access Denied" unless current_user.role == "employee"
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:meeting_room_id, :date, :start_time, :end_time)
  end
end

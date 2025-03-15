class CreateMeetingRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :meeting_rooms do |t|
      t.string :room_name
      t.integer :capacity
      t.string :location

      t.timestamps
    end
  end
end

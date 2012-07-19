class AddSegmentsToStates < ActiveRecord::Migration
  def change
    add_column :states, :daily_segment_id, :integer
    add_column :states, :weekly_segment_id, :integer
  end
end

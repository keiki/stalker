class TrackFbKeys < ActiveRecord::Migration
  def change
    create_table :facebook_keys do |t|
      t.string :key
      t.timestamps
    end
  end
end

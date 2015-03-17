class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :check_ins do |t|
      t.string :city
      t.string :state
      t.string :country
      t.string :continent
      t.string :medium #should be an enum; whatevs
      t.datetime :when
      t.timestamps
    end
  end
end

class IndexCheckins < ActiveRecord::Migration
  def change
    add_index :check_ins, :when
  end
end

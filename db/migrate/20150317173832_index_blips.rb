class IndexBlips < ActiveRecord::Migration
  def change
    add_index :blips, :when
  end
end

class AddPathToMontages < ActiveRecord::Migration
  def change
    add_column :montages, :path, :string
  end
end

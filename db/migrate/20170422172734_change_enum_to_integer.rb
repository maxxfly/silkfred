class ChangeEnumToInteger < ActiveRecord::Migration
  def up
    change_column :batch_montages, :status, :integer
    change_column :montages, :status, :integer
  end

  def down
    change_column :batch_montages, :status, :string
    change_column :montages, :status, :string
  end
end

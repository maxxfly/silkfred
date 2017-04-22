class AddBase64ToMontages < ActiveRecord::Migration
  def change
    add_column :montages, :base64, :text
  end
end

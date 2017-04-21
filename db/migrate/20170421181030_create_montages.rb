class CreateMontages < ActiveRecord::Migration
  def change
    create_table :montages do |t|
      t.string  :photo_url_1, null: false
      t.string  :photo_url_2, null: false
      t.integer :batch_montage_id, null: false, index: true
      t.string  :status, null: false
      t.timestamps
    end
  end
end

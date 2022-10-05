class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.string :description
      t.date :due_date
      t.integer :priority, default: 0

      t.timestamps
    end
  end
end

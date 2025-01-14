class CreateEventTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :event_tasks do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :status, null: false
      t.integer :is_mandatory, null: false

      t.timestamps
    end
  end
end

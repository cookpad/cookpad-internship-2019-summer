class CreateTodosTable < ActiveRecord::Migration[5.2]
  def change
    create_table :todos do |t|
      t.belongs_to :user
      t.string :name
      t.timestamp
    end
  end
end

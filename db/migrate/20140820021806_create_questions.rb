class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :survey_id
      t.string :title
      t.string :help_text
      t.integer :position, default: 0

      t.timestamps
    end
  end
end

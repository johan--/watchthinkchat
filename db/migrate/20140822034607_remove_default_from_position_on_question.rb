class RemoveDefaultFromPositionOnQuestion < ActiveRecord::Migration
  def change
    change_column_default :questions, :position, nil
  end
end

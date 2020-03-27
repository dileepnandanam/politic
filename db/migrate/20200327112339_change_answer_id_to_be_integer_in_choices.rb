class ChangeAnswerIdToBeIntegerInChoices < ActiveRecord::Migration[5.2]
  def up
    change_column :choices, :answer_id, 'integer USING CAST(answer_id AS integer)'
  end

  def down
    change_column :choices, :answer_id, 'string USING CAST(answer_id AS string)'
  end
end

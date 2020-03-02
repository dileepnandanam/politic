class AddAttachmentImageToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_attachment :surveys, :image
  end
end

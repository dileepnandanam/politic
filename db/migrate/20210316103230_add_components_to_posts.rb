class AddComponentsToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :components, :text, default: 'phone sociallinks videos galeries group survey quickpoll'
  end
end

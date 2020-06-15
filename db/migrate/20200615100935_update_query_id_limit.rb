class UpdateQueryIdLimit < ActiveRecord::Migration[5.2]
  def up
    execute('ALTER TABLE queries ALTER COLUMN id SET DATA TYPE BIGINT')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

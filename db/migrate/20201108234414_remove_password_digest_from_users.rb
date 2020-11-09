class RemovePasswordDigestFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :passwordigest
  end
end

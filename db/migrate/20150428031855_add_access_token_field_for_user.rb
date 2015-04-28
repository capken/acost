class AddAccessTokenFieldForUser < ActiveRecord::Migration
  def change
    add_column :users, :access_token, :string, :default => ''
  end
end

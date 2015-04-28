class SetupMainSchema < ActiveRecord::Migration
  def change
    create_table :users do |u|
      u.string :name
      u.string :email
      u.string :password_digest
      u.string :account_id
      u.string :time_zone

      u.timestamps null: false
    end

    create_table :buckets do |b|
      b.string :name
      b.string :region
      b.boolean :is_verified

      b.belongs_to :user, index: true
    end

    create_table :validations do |e|
      e.string :code
      e.string :purpose

      e.string :email

      e.timestamps null: false
    end
  end
end

$: << File.join(__FILE__, '..', 'lib')

require 'rubygems'
require 'bundler/setup'

Bundler.require(:default, :dev)

require 'ar_after_transaction'
require 'logger'

ActiveRecord::Base.establish_connection(
  :adapter => "mysql", # need something that has transactions...
  :database => "ar_after_transaction"
)

ActiveRecord::Base.connection.execute('DROP TABLE IF EXISTS users')

ActiveRecord::Schema.define(:version => 1) do
  create_table :users do |t|
    t.string :name
    t.timestamps
  end
end

class User < ActiveRecord::Base
end

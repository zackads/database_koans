require 'sequel'
require 'pg'

database_connection = nil

koan 'creating a connection' do
  database_connection = __change_me__

  o = INeedADatabaseConnection.new(
    database: database_connection
  )

  expect(o.query_data).to eq([{ one: 1 }])
end

koan 'disconnecting a connection' do
  #__change_me__

  number_of_connections = `netstat -atp | grep ESTABLISHED | wc -l`.chomp
  expect(number_of_connections.to_i).to eq(0)
end

dont_edit_this_bit do
  class INeedADatabaseConnection
    def initialize(database:)
      @database = database
    end

    def query_data
      @database.fetch('SELECT 1 as one').all
    end
  end
end


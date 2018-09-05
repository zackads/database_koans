require 'sequel'
require 'pg'

koan 'creating a connection' do
  database_connection = __change_me__

  o = INeedADatabaseConnection.new(
    database: database_connection
  )

  expect(o.query_data).to eq([{ one: 1 }])
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


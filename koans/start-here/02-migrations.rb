koan 'loading the migration extension' do
  Sequel.extension __change_me__

  expect(Sequel::Migrator).not_to be_nil
end

koan 'running the migrator to upgrade to latest' do
  migration_directory = "#{__dir__}/02-no-migrations"
  database_connection = MigrationKoan.database_connection

  __change_me__

  expect(
    database_connection[:schema_info].first
  ).to(
    eq(version: 2)
  )
end

koan 'running the migrator to upgrade to version 1' do
  migration_directory = "#{__dir__}/02-no-migrations"
  database_connection = MigrationKoan.database_connection

  __change_me__

  expect(
    database_connection[:schema_info].first
  ).to(
    eq(version: 1)
  )
end

koan 'creating the fruit table' do
  migration_directory = "#{__dir__}/02-migrations"
  database_connection = MigrationKoan.database_connection

  __change_me__

  expect(
    MigrationKoan.fruit_table_exists?(database_connection)
  ).to be_truthy

  columns = MigrationKoan.column_information(
    database_connection
  )

  expect(columns.length).to eq(2), 'there should be two columns'

  first_column = columns[0]
  expect(first_column[:column_name]).to eq('id')
  expect(first_column[:data_type]).to eq('integer')
  expect(first_column[:is_nullable]).to eq('NO')
  expect(first_column[:identity_increment]).to eq('1')
  expect(first_column[:ordinal_position]).to eq(1)

  second_column = columns[1]
  expect(second_column[:column_name]).to eq('name')
  expect(second_column[:data_type]).to eq('text')
  expect(second_column[:is_nullable]).to eq('NO')
  expect(second_column[:identity_increment]).to be_nil
  expect(second_column[:ordinal_position]).to eq(2)

  database_connection.disconnect
end

koan 'creating the harvest table' do
  migration_directory = "#{__dir__}/02-migrations"
  database_connection = MigrationKoan.database_connection

  __change_me__

  columns = MigrationKoan.column_information(
    database_connection,
    'harvest'
  )

  expect(columns.length).to eq(4)

  first_column = columns[0]
  expect(first_column[:column_name]).to eq('id')
  expect(first_column[:data_type]).to eq('integer')
  expect(first_column[:is_nullable]).to eq('NO')
  expect(first_column[:identity_increment]).to eq('1')
  expect(first_column[:ordinal_position]).to eq(1)

  second_column = columns[1]
  expect(second_column[:column_name]).to eq('fruit_id')
  expect(second_column[:data_type]).to eq('integer')
  expect(second_column[:is_nullable]).to eq('NO')
  expect(second_column[:identity_increment]).to be_nil
  expect(second_column[:ordinal_position]).to eq(2)

  third_column = columns[2]
  expect(third_column[:column_name]).to eq('date')
  expect(third_column[:data_type]).to eq('date')
  expect(third_column[:is_nullable]).to eq('NO')
  expect(third_column[:identity_increment]).to be_nil
  expect(third_column[:ordinal_position]).to eq(3)

  fourth_column = columns[3]
  expect(fourth_column[:column_name]).to eq('yield')
  expect(fourth_column[:data_type]).to eq('integer')
  expect(fourth_column[:is_nullable]).to eq('NO')
  expect(fourth_column[:identity_increment]).to be_nil
  expect(fourth_column[:ordinal_position]).to eq(4)

  database_connection.disconnect
end

dont_edit_this_bit do
  class MigrationKoan
    def self.database_connection
      Sequel.postgres(
        host: 'postgres',
        user: 'workshop',
        password: 'secretpassword',
        database: 'workshop_one'
      )
    end

    def self.column_information(db, table='fruit')
      columns = db.fetch(
        "SELECT column_name, 
                data_type, 
                is_nullable, 
                identity_increment,
                ordinal_position
        FROM information_schema.columns
        WHERE table_name = '#{table}'" 
      ).all
    end

    def self.fruit_table_exists?(db)
      db.fetch(
        "SELECT * FROM pg_catalog.pg_tables 
        WHERE tablename = 'fruit'" 
      ).all
    end
  end
end

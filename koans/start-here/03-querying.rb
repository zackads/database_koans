koan 'inserting data' do
  q = QueryingKoan.new
  database = q.database_connection

  row = {
    number: 'GB1000001',
    total: '50.00',
    currency: 'GBP'
  }

  __change_me__

  q.expect_row_for_first_koan_to_exist

  database.disconnect
end

koan 'select all rows' do
  q = QueryingKoan.new
  database = q.database_connection

  q.insert_some_rows

  __change_me__

  expect(rows.length).to eq(2)

  totals = rows.map { |r| r[:total] }
  parsed_totals = totals.map { |t| BigDecimal(t) }
  sum_of_totals = parsed_totals.sum
  formatted_sum = '%.2f' % sum_of_totals

  expect(formatted_sum).to eq('35.30')

  database.disconnect
end

koan 'select specific columns' do
  q = QueryingKoan.new
  database = q.database_connection

  q.insert_some_rows

  rows = __change_me__

  expect(rows.length).to eq(2)
  expect(rows.map(&:keys).flatten.uniq).to(
    eq([:number, :total])
  )

  database.disconnect
end

koan 'we can filter' do
  q = QueryingKoan.new
  database = q.database_connection

  q.insert_some_rows

  row = database[:order]
    .where(__change_me__)
    .first

  expect(row).to(
    eq(
      id: 1,
      number: 'GB00001',
      currency: 'GBP',
      total: '23.20'
    )
  )
end

koan 'we can filter with a block' do
  q = QueryingKoan.new
  database = q.database_connection

  q.insert_some_rows

  row = database[:order]
    .where { |o| o.total > __change_me__ }
    .order_by(Sequel.desc(:id))

  row = row.first
  expect(row).to(
    eq(
      id: 1,
      number: 'GB00001',
      currency: 'GBP',
      total: '23.20'
    )
  )
end

koan 'we can filter with an instance eval-ed block' do
  q = QueryingKoan.new
  database = q.database_connection

  q.insert_some_rows

  row = database[:order]
    .where { total > __change_me__ }
    .order_by(Sequel.desc(:id))

  row = row.first
  expect(row).to(
    eq(
      id: 1,
      number: 'GB00001',
      currency: 'GBP',
      total: '23.20'
    )
  )
end


dont_edit_this_bit do
  Sequel.extension :migration

  class QueryingKoan
    def database_connection 
      @database = Sequel.postgres(
        host: 'postgres',
        user: 'workshop',
        password: 'secretpassword',
        database: 'workshop_one'
      )
      migrate
      @database
    end

    def migrate
      Sequel::Migrator.run(
        @database,
        "#{__dir__}/03-querying/"
      )
    end

    def expect_row_for_first_koan_to_exist
      row = {
        number: 'GB1000001',
        total: '50.00',
        currency: 'GBP'
      }
      rows = @database[:order]
        .select(:number, :total, :currency)
      expect(rows.first).to eq(row)
    end

    def insert_some_rows
      @database[:order].insert(
        number: 'GB00001',
        total: '23.20',
        currency: 'GBP'
      )

      @database[:order].insert(
        number: 'GB00002',
        total: '12.10',
        currency: 'GBP'
      )
    end
  end
end


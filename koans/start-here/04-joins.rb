koan 'join two tables together' do
  j = JoinsKoan.new
  database = j.database_connection

  j.insert_some_rows


  line_items = database[:line_item]
    .join(__change_me__)
    .all

  expect(line_items.length).to eq(1)

  formatted_price = "%.2f" % line_items.first[:price]
  expect(formatted_price).to eq('123.17')
end

koan 'derive a new column from two tables' do
  j = JoinsKoan.new
  database = j.database_connection

  j.insert_some_rows

  line_items = database[:line_item]
    .select do 
      [
        description, 
        price, 
        quantity, 
        (__change_me__).as(:total)
      ]
    end
    .join(:product, id: :product_id)
    .all

  expect(line_items.first).to eq(
    description: 'Interesting gem',
    price: BigDecimal('123.17'),
    quantity: BigDecimal('10'),
    total: BigDecimal('1231.70')
  )

  pp line_items
  expect(line_items.length).to eq(1)

  formatted_price = "%.2f" % line_items.first[:price]
  expect(formatted_price).to eq('123.17')
end

dont_edit_this_bit do
  Sequel.extension :migration

  class JoinsKoan
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
        "#{__dir__}/04-joins/"
      )
    end

    def insert_some_rows
      id1 = @database[:product].insert(
        description: 'Interesting gem',
        price: '123.17'
      )

      id2 = @database[:product].insert(
        description: 'A shiny piece of metal',
        price: '1.90'
      )

      @database[:line_item].insert(
        quantity: 10,
        product_id: id1
      )
    end
  end
end


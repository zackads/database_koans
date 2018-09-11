Sequel.migration do
  change do
    create_table :order do
      primary_key :id
      String :number, null: false
      String :total, null: false
      String :currency, null: false
    end
  end
end

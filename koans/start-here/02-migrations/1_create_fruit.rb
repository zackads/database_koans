Sequel.migration do
  up do
    create_table(:fruit) do
      primary_key :id
      String :name, null: false
    end
  end
end

Sequel.migration do
  up do
    create_table(:harvest) do
      primary_key :id
      Integer :fruit_id, null: false
      Date :date, null: false
      Integer :yield, null: false
    end
  end
end

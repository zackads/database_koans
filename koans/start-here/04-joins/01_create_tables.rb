Sequel.migration do
  change do
    create_table :product do
      primary_key :id
      BigDecimal :price, size: [10, 2]
      String :description
    end

    create_table :line_item do
      primary_key :id
      BigDecimal :quantity, size: [10, 2] 
      foreign_key :product_id, :product
    end
  end
end

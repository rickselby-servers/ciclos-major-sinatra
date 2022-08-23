# frozen_string_literal: true

Sequel.migration do
  up do
    create_table? :text do
      String :key, primary_key: true, null: false
      String :text, text: true
    end
  end

  down do
    drop_table :text
  end
end

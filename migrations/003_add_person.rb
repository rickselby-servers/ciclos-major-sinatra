# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :text_history do
      add_column :person, String
    end
  end
end

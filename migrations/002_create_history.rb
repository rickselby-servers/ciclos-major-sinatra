# frozen_string_literal: true

Sequel.migration do
  up do
    create_table :text_history do
      String :key, null: false
      String :text, null: false, text: true
      DateTime :datetime, null: false, default: Sequel::CURRENT_TIMESTAMP
      TrueClass :current, null: false, default: true
    end

    from(:text_history).insert([:key, :text], from(:text).select(:key, :text))
  end

  down do
    drop_table :text_history
  end
end

class AddEventableToEvents < ActiveRecord::Migration[8.1]
    def change
       add_reference :events, :eventable, polymorphic: true, index: true

       # Helpful indexes for queries like "vehicle_view last 7 days"
       add_index :events, [:action, :created_at]
       add_index :events, [:user_id, :action, :created_at]
     end
end

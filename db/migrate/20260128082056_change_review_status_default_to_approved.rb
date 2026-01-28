class ChangeReviewStatusDefaultToApproved < ActiveRecord::Migration[8.1]
  def change
    change_column_default :reviews, :status, from: 0, to: 1
  end
end

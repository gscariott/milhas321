class MilesOffer < ApplicationRecord
  belongs_to :user
  before_destroy :restore_user_miles

  # Restores the miles quantity of a miles_offer (before destroying it) to the user
  # 
  # @return [Boolean] to inform the success (or not) of the update
  def restore_user_miles
    qty = self.quantity
    user_miles = self.user.miles
    self.user.update(miles: user_miles + qty)
  end

end

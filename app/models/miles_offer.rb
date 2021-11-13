class MilesOffer < ApplicationRecord
  belongs_to :user
  before_destroy :restore_user_miles

  def restore_user_miles
    qty = self.quantity
    user_miles = self.user.miles
    self.user.update(miles: user_miles + qty)
  end

end

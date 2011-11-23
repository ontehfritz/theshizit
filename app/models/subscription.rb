class Subscription < ActiveRecord::Base

  def self.notify(object)
    subscriptions = Subscription.where(:type_name => object.class.name, :type_id => object.id).all
    
    subscriptions.each do |subscription|
      Notification.create(:user_id => subscription.user_id, :type_id => object.id, :type_name => object.class.name)
    end
  end
end

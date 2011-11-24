class Subscription < ActiveRecord::Base

  def self.notify(object)
    
    if object.class.name == "Comment"
      subscriptions = Subscription.where(:type_name => object.content.class.name, :type_id => object.content.id).all
    else
      subscriptions = Subscription.where(:type_name => object.class.name, :type_id => object.id).all
    end
    
    subscriptions.each do |subscription|
      Notification.create(:user_id => subscription.user_id, :type_id => object.id, :type_name => object.class.name)
    end
  end
end

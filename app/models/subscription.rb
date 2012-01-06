class Subscription < ActiveRecord::Base

  def self.notify(object, current_user)
    #performance hit cache or hardcode
    content = ContentType.find(:all, :select => "type_name").map(&:type_name)
    #puts content
    
    if object.class.name == "Comment"
      subscriptions = Subscription.where(:type_name => object.content.class.name, :type_id => object.content.id).all
    #elsif object.class.name == "Content"
    #  subscriptions = Subscription.where(:type_name => object.class.name, :type_id => object.id).all
    else
      subscriptions = Subscription.where(:type_name => object.class.name, :type_id => object.id).all
    end
    
    subscriptions.each do |subscription|
      if subscription.user_id != current_user.id
        
        if object.class.name == "Comment"
          parent_id = object.content.id
        elsif content.index(object.class.name) != nil
          parent_id = object.category.id
        else
          parent_id = 0
        end
        
        Notification.create(:user_id => subscription.user_id, :type_id => object.id, :type_name => object.class.name,
                                    :parent_type_id => parent_id)
      end
    end
  end
end

class VoteLog < ActiveRecord::Base
  def self.has_user_voted(current_user, object_vote)
    vote = VoteLog.find_all_by_user_id_and_type_id_and_type_name(current_user.id, object_vote.id, 
                                          object_vote.class.name).first
                                          
    if vote == nil
      false
    else
      true
    end                                    
  end
end

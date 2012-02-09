class User < ActiveRecord::Base
	validates :username, :uniqueness => { :case_sensitive => false }
	validates :password, :presence =>true,
                    :length => { :minimum => 5, :maximum => 40 },
                    :confirmation =>true
    validates_confirmation_of :password
	
    has_and_belongs_to_many :roles
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         #:recoverable, 
		 :rememberable, :trackable#, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  
  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end
 
end

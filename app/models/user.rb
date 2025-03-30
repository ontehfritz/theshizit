class User < ActiveRecord::Base
  # validations
  validates :username, uniqueness: { case_sensitive: false }
  validates :password, presence: true,
            length: { minimum: 5, maximum: 40 },
            confirmation: true
  validates_confirmation_of :password

  # associations
  has_and_belongs_to_many :roles

  # devise modules
  devise :database_authenticatable,
         :rememberable,
         :trackable

  # helper methods
  def role?(role)
    roles.exists?(name: role.to_s.camelize)
  end
end

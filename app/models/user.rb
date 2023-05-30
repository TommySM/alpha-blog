class User < ApplicationRecord
  has_many :articles
    validates :username, presence: true,
     uniqueness: { case_sensitive: false},
      length: { minimum:3, maximum: 25 }
      
    VALID_EMAIL_REGEX = /\A\S+@.+\.\S+\z/

    validates :email, presence: true,
     uniqueness: { case_sensitive: false},
      length: { maximum: 105 },
      format: { with: VALID_EMAIL_REGEX }

end
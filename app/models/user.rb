class User < ApplicationRecord
  before_save { self.email = email.downcase }
  has_many :articles, dependent: :destroy

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 25 }

  VALID_EMAIL_REGEX = /\A\S+@.+\.\S+\z/
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 105 },
                    format: { with: VALID_EMAIL_REGEX }
  has_secure_password
  has_many_attached :profile_images

  validate :profile_images_format, if: -> { profile_images.attached? }

  private

  def profile_images_format
    profile_images.each do |image|
      unless image.content_type.in?(%w(image/jpeg image/png))
        errors.add(:profile_images, "must be a JPEG or PNG file")
      end
    end
  end
end

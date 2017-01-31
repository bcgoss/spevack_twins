class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :database_authenticatable, :registerable, :rememberable, :validatable, :recoverable,
  devise :trackable, :omniauthable,
         :omniauth_providers => [:twitter, :facebook, :linkedin, :google_oauth2,
                                  *(:developer if Rails.env.development?)]

  validates_uniqueness_of :email

  validates_presence_of   :email
  validates_presence_of   :name
  validates_presence_of   :image
  validates_presence_of   :provider
  validates_presence_of   :uid


  class << self
    def from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.name = auth.info.name
        user.image = auth.info.image
        user.provider = auth.provider
        user.uid = auth.uid
        user.save!
      end
    end
  end
end

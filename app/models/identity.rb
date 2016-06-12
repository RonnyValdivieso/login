class Identity < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  def self.find_for_oauth(auth)
  	identity = find_by(provider: auth.provider, uid: auth.uid) || create_for_oauth(auth)
  end

  def self.create_for_oauth(auth)
  	identity = create(
  		provider: auth.provider,
  		uid: auth.uid,
  		name: auth.info.name,
  		nickname: auth.info.nickname,
  		email: auth.info.name,
  		image: auth.info.photo,
  		accesstoken: auth.credentials.token,
  		refreshtoken: auth.credentials.refresh_token
  	)
  end
end

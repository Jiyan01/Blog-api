class User < ApplicationRecord
	# Il faut ajouter les deux modules commençant par jwt
	devise :database_authenticatable, :registerable,
	:jwt_authenticatable,
	jwt_revocation_strategy: JwtDenylist

  has_many :articles

	def jwt_payload
		{
			'sub' => id,
			'email' => email
		}
	end
	
end

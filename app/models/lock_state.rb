class LockState < ActiveRecord::Base
	has_one :expiration_date
end

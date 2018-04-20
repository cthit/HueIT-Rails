class User < ActiveResource::Base
	self.primary_key = :cid
  self.site = Rails.configuration.account_ip

	@@ADMIN_GROUPS = [:digit, :prit]
	@@FILTER = [:digit, :styrit, :prit, :nollkit, :sexit, :fanbarerit, :'8bit', :drawit, :armit, :hookit, :fritid, :snit, :flashit]

  def admin?
	  (self.groups & @@ADMIN_GROUPS).present?
	end

  def in_group?(group)
	  self.groups.include? group
  end

  def valid_groups
    self.groups & @@FILTER
  end

	def user_profile_path
		"https://chalmers.it/author/#{cid}/"
	end

	def to_s
		"#{first_name} '#{nick}' #{last_name}"
	end

  alias_method :full_name, :to_s

  def self.oauth_bearer_token=(token)
    @@oauth_bearer_token = token
  end

  def self.oauth_bearer_token
    @@oauth_bearer_token
  end

	private
		def self.find(id)
	    return nil unless id.present?
	    Rails.cache.fetch("users/#{id}.json") do
        super id
	    end
    end

	  def self.headers
      { 'authorization' => "Bearer #{self.oauth_bearer_token}"}
  	end


end

class Symbol
	def itize
		case self
			when :digit, :styrit, :sexit, :fritid, :snit
				self.to_s.gsub /it/, 'IT'
			when :drawit, :armit, :hookit, :flashit
				self.to_s.titleize.gsub /it/, 'IT'
			when :'8bit'
				'8-bIT'
			when :nollkit
				'NollKIT'
			when :prit
				'P.R.I.T.'
			when :fanbarerit
				'FanbärerIT'
			else
				self.to_s
		end
	end
end

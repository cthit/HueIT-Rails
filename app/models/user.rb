require 'active_resource'

class User < ActiveResource::Base
	self.primary_key = :cid
  self.site = Rails.configuration.account_ip

	attr_reader :groups

	@@ADMIN_GROUPS = [:digit, :prit]
	@@FILTER = [:digit, :styrit, :prit, :nollkit, :sexit, :fanbarerit, :'8bit', :drawit, :armit, :hookit, :fritid, :snit, :flashit]

	def admin?
		(groups & @@ADMIN_GROUPS).present?
	end

	def in_group?(group)
		groups.include? group.to_sym
	end

	def user_profile_path
		"https://chalmers.it/author/#{cid}/"
	end

	def to_s
		"#{first_name} '#{nick}' #{last_name}"
	end

	alias_method :full_name, :to_s

	private
		def self.find(id)
	    return nil unless id.present?
	    Rails.cache.fetch("users/#{id}.json") do
	      user = super id
	      groups = (user['groups']  || []).uniq.map { |g| g.downcase.to_sym }
				user.groups = groups & @@FILTER
	      user
	    end
	  end

	  def self.headers
      { 'authorization' => "Bearer #{ActiveResource::Base.auth_token}"}
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

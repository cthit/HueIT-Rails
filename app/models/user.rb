# == Schema Information
#
# Table name: users
#
#  cid        :string(255)      primary key
#  first_name :string(255)
#  last_name  :string(255)
#  nick       :string(255)
#  mail       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	include HTTParty
	self.primary_key = :cid

	validates :cid, :nick, :mail, :first_name, :last_name, presence: true
	validates :cid, :mail, uniqueness: true

	attr_accessor :groups


	base_uri "https://account.chalmers.it/userInfo.php"

	@@ADMIN_GROUPS = [:digit, :prit]
	@@FILTER = [:digit, :styrit, :prit, :nollkit, :sexit, :fanbarerit, :'8bit', :drawit, :armit, :hookit, :fritid, :snit, :flashit]


	def groups
		@groups ||= refresh_groups
	end

	def admin?
		(groups & @@ADMIN_GROUPS).present?
	end

	def in_group?(group)
		groups.include? group
	end

	def self.find_by_token(token)
		send_request query: { token: token }
	end

	def self.find(cid)
		super
	rescue ActiveRecord::RecordNotFound
		user = send_request query: { cid: cid }
		user.save!
		user
	end

	def user_profile_path
		"https://chalmers.it/author/#{cid}/"
	end

	def to_s
		"#{first_name} '#{nick}' #{last_name}"
	end

	alias_method :full_name, :to_s

	private
		def refresh_groups
			user = HTTParty.get('https://account.chalmers.it/userInfo.php', query: { cid: cid })
			groups = (user['groups']  || []).uniq.map { |g| g.downcase.to_sym }
			@groups = groups & @@FILTER
		end

		def self.send_request(options)
			resp = get("", options)
			if resp.success? && resp['cid'].present?
				groups = resp['groups'].uniq.map { |g| g.downcase.to_sym }
				@groups = groups & @@FILTER
				self.new(cid: resp['cid'], first_name: resp['firstname'], last_name: resp['lastname'],
					nick: resp['nick'], mail: resp['mail'])
			else
				raise SecurityError, 'Not signed in!'
			end
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

class AdminController < ApplicationController
	def index
		@log_entries = LogEntry.all.reverse_order
		@is_locked = locked?
	end

	def lock
		index
	end

	def locked?
		true
	end
end

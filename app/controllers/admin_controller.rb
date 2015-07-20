class AdminController < ApplicationController
	def index
		@log_entries = LogEntry.all
	end
end

( rake db:migrate && rake db:seed && echo "i have migrated"|| (rake db:setup && rake db:seed && echo "done with seedin'")) && \

rails server -b 0.0.0.0

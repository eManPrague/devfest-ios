#
# Rake tasks
#
# Created by Pavel Dolezal on 23.02.15.
# Copyright (c) 2013 eMan s.r.o. All rights reserved.
#

# MARK: - Helper functions

# Print and execute bash command.
def sh cmd
  puts cmd
  put `#{cmd}`
end

# Execute locs.swift script with pre-filled author and project.
def locs_cmd
  author = `git config user.name`.strip
  if author != ''
      author_modifier = "--author '#{author}'"
  end
  
  project = `echo $(find . -name *.xcworkspace)`.strip
  if project != ''
      project = project.split('/')[1].split('.').first
      project_modifier = "--project '#{project}'"
  end
  
  cmd = "./scripts/locs #{author_modifier} #{project_modifier}"
end


# MARK: - Tasks

desc 'Generate localization'
task :locs do
  sh locs_cmd
end

namespace :locs do
  desc 'Generate localizations and remove unused ones'
  task :prune do
    sh "#{locs_cmd} --remove-unused"
  end
end


desc 'Download seed data to resources'
task :seed do
	url = "curl -X GET -H 'Accept: application/json' -H 'Authorization: aW9zOn1kMkR3XkNNO0dmcCx2blQ=' 'http://cokdyz.dev.eman.cz/api/database'"
	file = './App/Resources/seed.json'
	timestamp_file = './App/Resources/seed_timestamp.txt'

	# Download and save seed
	sh "curl #{url} > #{file}"

	# Save timestamp
	sh "date +%s > #{timestamp_file}"

	# Print size of the file
	size = `du -h #{file}`
	puts "#{size}"
end

# Some tips...

# desc 'Generate model classes'
# task :model do
#   sh "mogenerator --v2 --model ./App/Resources/XXX.xcdatamodeld -M ./App/Model/mogenerated -H ./App/Model"
# end

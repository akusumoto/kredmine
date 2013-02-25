require 'active_record/fixtures'

task :load_default_answer_data => :environment do
   ActiveRecord::Base.establish_connection(:development)
   ActiveRecord::Fixtures.create_fixtures('./plugins/event_management/lib/default_data/', 'def_answer_data')
end
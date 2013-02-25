class EventUser < ActiveRecord::Base
  unloadable
  belongs_to :event_model
end

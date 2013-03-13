module Gdrivestrg
  class Folder < ActiveRecord::Base
    attr_accessible :folder_name, :remote_id, :user_id

    belongs_to :user, :class_name => Gdrivestrg.user_class
  end
end

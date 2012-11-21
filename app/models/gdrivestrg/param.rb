module Gdrivestrg
  class Param < ActiveRecord::Base
    attr_accessible :expires_in, :issued_at, :refresh_token

    belongs_to :user, :class_name => Gdrivestrg.user_class
  end
end

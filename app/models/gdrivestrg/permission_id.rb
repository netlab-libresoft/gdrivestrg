module Gdrivestrg
  class PermissionId < ActiveRecord::Base
    attr_accessible :permission_id, :remoteobject_id, :user_id

    belongs_to :remoteobject
    belongs_to :user, :class_name => Cloudstrg.user_class
  end
end

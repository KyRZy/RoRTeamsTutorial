class Team < ApplicationRecord
    has_one :leader, :class_name => 'User'
    has_many :users

    validates :name, presence: true, uniqueness: {case_sensitive: false}
end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true #no corresponding table to the database
end

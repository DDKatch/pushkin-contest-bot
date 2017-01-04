class Line < ApplicationRecord
  belongs_to :poem, dependent: :destroy
end

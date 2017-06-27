class User < ApplicationRecord
    #So rails can return the name of the user when it needs to
    def to_s
        name
    end
end

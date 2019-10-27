module Memorable
    module ClassMethods
        def reset_all
           self.all.clear
        end
    end
end
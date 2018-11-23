class Trophy < ApplicationRecord
    enum mail_type:{
        test_feed: -1,
        no_feed: 0,
        pt1: 1,
        pt2: 2,
        pt3: 3, 
        pt4: 4
    }
end

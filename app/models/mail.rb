class Mail < ApplicationRecord
  enum mail_type:{
    trophy: -1,
    no_feed: 0,
    test_feed: 1,
    pt2: 2,
    pt3: 3, 
    pt4: 4
  }
end

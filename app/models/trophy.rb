class Trophy < ApplicationRecord
    # メールにリレーション貼ると訳わからなくなったので、あえてやめた。
    # Mail に id メモって、Mailからid経由で（手動で）呼び出す形にした。
    # Trophy側からメールを呼び出す機会はなさそうなので無視。
    has_many :achieve_trophy, dependent: :destroy
end

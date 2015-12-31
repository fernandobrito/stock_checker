require 'tzinfo'

module TimeZone
  def self.get_cet_time
    TZInfo::Timezone.get('CET').now
  end
end
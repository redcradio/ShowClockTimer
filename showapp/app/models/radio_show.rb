class RadioShow < ActiveRecord::Base
validate :valid_show_timing, on: :create or :update
validates_presence_of :name
validates_presence_of :description
#validate :day, on: :create or :update
belongs_to :user
has_many :show_timings
  accepts_nested_attributes_for :show_timings, :reject_if => :all_blank, :allow_destroy => true

  def valid_show_timing
    show_timings.each do |show_timing|
  if (show_timing.endTime <= show_timing.startTime)
    errors.add( :Show, " Timing Info Error: END_TIME <= START_TIME !!!");
  end
      @radio_shows_list1 = (RadioShow.all.where("user_id" => user_id).includes(:show_timings).where('show_timings.day' => show_timing.day, 'show_timings.startTime' => show_timing.startTime..show_timing.endTime )).uniq;
  @radio_shows_list2 = (RadioShow.all.where("user_id" => user_id).includes(:show_timings).where('show_timings.day' => show_timing.day, ('show_timings.endTime') => (show_timing.startTime+1)..(show_timing.endTime) )).uniq;

      if (!@radio_shows_list1.empty?)
    @radio_shows_list1.each do |radio_show|
      list = " Timings Overlap with existing show event: "+radio_show.name + " !!! "
      errors.add( :Show, list);
    end
      end
      if (!@radio_shows_list2.empty?)
    @radio_shows_list2.each do |radio_show|
      list = " Timings Overlap with existing show event: "+radio_show.name + " !!! "
      errors.add( :Show, list);
    end
      end
    end
    show_timings.permutation(2).select{|a, b|
    if ( (b.startTime >= a.startTime) && (b.startTime <= a.endTime) )
   errors.add(:Show, " Timings Overlap in Submitted Info!!!! ");
    end
    }
  end

end
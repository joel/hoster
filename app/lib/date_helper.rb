class DateHelper
  def distance_of_time_in_words(duration)
    mm, ss = duration.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)
    "%d days, %d hours, %d minutes and %d seconds" % [dd, hh, mm, ss]
  end
end

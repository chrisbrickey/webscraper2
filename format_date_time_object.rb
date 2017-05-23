require 'date'

module FormatDateTimeObject

  def format(date_raw, start_time_raw, end_time_raw)

    date_string = Date.parse(date_raw)

    #determines a.m. or p.m. for start_time if isn't already noted
    meridiem = String.new
    unless start_time_raw.chars.any? { |l| ["A", "a", "P", "p"].include?(l) }
      if end_time_raw.chars.any? { |l| ["A", "a"].include?(l) }
        meridiem = "a.m."
      else
        meridiem = "p.m."
      end

      start_time_raw += " #{meridiem}"
    end

    start_time_24hr = DateTime.parse(start_time_raw).strftime("%H:%M")
    end_time_24hr = DateTime.parse(end_time_raw).strftime("%H:%M")

    start_formatted = "#{date_string} #{start_time_24hr} +0000"
    end_formatted = "#{date_string} #{end_time_24hr} +0000"

    [start_formatted, end_formatted]
  end


end

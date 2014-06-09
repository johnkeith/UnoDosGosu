class PauseTimer
  attr_reader :hours
  attr_reader :minutes
  attr_reader :seconds
  attr_reader :state

  def initialize
    @seconds = 0
    @last_time = Gosu::milliseconds()
    @state = :running
  end

  def stop
    @state = :lost
  end

  def reset
    @seconds = 0
  end

  def update_time
    if @state == :running
      if (Gosu::milliseconds - @last_time) / 1000 == 1
        @seconds += 1
        @last_time = Gosu::milliseconds()
      end

      if @seconds > 5
        stop
      end
    end

    if @seconds < 10
      time = "Time: 0" + @seconds.to_s
    else
      time = "Time: 0" + @seconds.to_s
    end
  end
end

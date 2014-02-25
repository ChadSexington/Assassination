class RoundHandler
  
  def initialize
    @queue = Queue.new
  end

  def enqueue(work)
    Rails.logger.info "Adding work to queue: #{work.inspect}."
    @queue << work
    if running?
      Rails.logger.info "Thread already started, not starting again"
    else
      Rails.logger.info "Starting round handler thread..."
      start
    end
  end
  
  def running?
    @thread && @thread.alive?
  end
  
  def start
    @thread = Thread.new do
      loop do
        while @queue.empty? do    
          sleep 30
        end
        work = @queue.pop
        if work[:time] > DateTime.now
          do_work(work[:action], work[:time], work[:round_id])
        else
          @queue.push(work)
        end
      end
    end
  end

  def do_work(action, time, round_id)
    case action
    when "start"
      Rails.logger.info "ROUNDHANDLER: Starting round"
      current_round.start_round
    when "stop"
      Rails.logger.info "ROUNDHANDLER: Stopping round"
      current_round.stop_round
    end
  end

end


class RoundHandler
  
  def initialize
    @queue = Queue.new
  end

  def enqueue(work)
    Rails.logger.info "ROUNDHANDLER: Adding work to queue: #{work.inspect}."
    @queue << work
    if running?
      Rails.logger.info "ROUNDHANDLER: Thread already started, not starting again"
    else
      Rails.logger.info "ROUNDHANDLER: Starting round handler thread..."
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
        if work[:time] < DateTime.now
          do_work(work[:action], work[:time], work[:round_id])
        else
          Rails.logger.info "ROUNDHANDLER: Work in the queue but not ready. Waiting..."
          @queue.push(work)
          sleep 30
        end
      end
    end
  end

  def do_work(action, time, round_id)
    case action
    when "start"
      Rails.logger.info "ROUNDHANDLER: Starting round"
      begin
        Round.find(round_id).start_round
      rescue => e
        Rails.logger.error "ROUNDHANDLER: ERROR could not start round #{e.inspect}"
      end
    when "stop"
      Rails.logger.info "ROUNDHANDLER: Stopping round"
      Round.find(round_id).stop_round
    end
  end

end


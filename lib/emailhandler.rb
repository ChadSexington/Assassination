class EmailHandler
  
  def initialize
    @queue = Queue.new
  end

  def enqueue(email)
    Rails.logger.info "EMAILHANDLER: Adding email to queue: #{email.inspect}."
    @queue << email
    if running?
      Rails.logger.info "EMAILHANDLER: Thread already started, not starting again"
    else
      Rails.logger.info "EMAILHANDLER: Starting email handler thread..."
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
        email = @queue.pop
        safe_mail(email[:method_name], email[:args])
        sleep 10
      end
    end
  end

  def safe_mail(method_name, args)
    attempts = 1
    Rails.logger.info "EMAILHANDLER: Sending email \"#{method_name}\" with arguments: \"#{args.to_s}\"."
    begin
      PlayerMailer.send(method_name, *args).deliver
    rescue Timeout::Error => e
      Rails.logger.error "EMAILHANDLER: Email timed out on attempt ##{attempts}."
      Rails.logger.error e.inspect
      if attempts < 2
        attempts += 1
        retry
      else
        enqueue({:method_name => method_name, :args => args})
        Rails.logger.error "EMAILHANDLER: Giving up on sending email \"#{method_name}\" after #{attempts} attempts. Adding to the end of the queue to attempt at a later time."
      end
    rescue => e
      Rails.logger.error "EMAILHANDLER: Email \"#{method_name}\" failed to send due to \"#{e.inspect}\""
    end
  end 

end


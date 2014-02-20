class EmailHandler
  
  def initialize
    @queue = Queue.new
  end

  def enqueue(email)
    Rails.logger.info "Adding email to queue: #{email.inspect}."
    start unless running?
    @queue << email
  end
  
  def running?
    @thread && @thread.alive?
  end
  
  def start
    @thread = Thread.new do
      Rails.logger.info "Waiting for next email in queue. Current queue: #{@queue.inspect}"
      email = @queue.pop
      puts "Got #{email.inspect} out of queue"
      safe_mail(email[:method_name], email[:args])
      sleep 10
    end
  end

  def safe_mail(method_name, args)
    attempts = 1
    Rails.logger.info "Sending email \"#{method_name}\" with arguments: \"#{args.to_s}\"."
    begin
      PlayerMailer.send(method_name, *args).deliver
    rescue Timeout::Error => e
      Rails.logger.error "Email timed out on attempt ##{attempts}."
      Rails.logger.error e.inspect
      if attempts < 5
        attempts += 1
        retry
      else
        enqueue({:method_name => method_name, :args => args})
        Rails.logger.error "Giving up on sending email \"#{method_name}\" after #{attempts} attempts. Adding to the end of the queue to attempt at a later time."
      end
    rescue => e
      Rails.logger.error "Email \"#{method_name}\" failed to send due to \"#{e.inspect}\""
    end
  end 

end


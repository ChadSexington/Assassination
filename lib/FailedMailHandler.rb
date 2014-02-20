class FailedMailHandler
  
  def initialize
    @queue = Queue.new
  end

  def add(email)
    start unless running?
    @queue << email
  end
  
  def running?
    @thread && @thread.alive?
  end
  
  def start
    @thread = Thread.new do
      email = @queue.pop
      safe_mail(email[:method_name], email[:args])
      sleep 10
    end
  end

end


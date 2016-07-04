if (defined?(Net) && defined?(Net::HTTP))

  Net::HTTP.class_eval do
    def request_with_mini_profiler(*args, &block)
      request = args[0]
      Rack::MiniProfiler.step("Net::HTTP #{request.method} #{request.path}") do
        request_without_mini_profiler(*args, &block)
      end
    end
    alias request_without_mini_profiler request
    alias request request_with_mini_profiler
  end

end

if (defined?(Net) && defined?(Net::IMAP))

  Net::IMAP.class_eval do
    def send_command_with_mini_profiler(cmd, *args, &block)
      Rack::MiniProfiler.step("Net::IMAP #{cmd}") do
        send_command_without_mini_profiler(cmd, *args, &block)
      end
    end
    alias send_command_without_mini_profiler send_command
    alias send_command send_command_with_mini_profiler
  end

end

if (defined?(Mail) && defined?(Mail::SMTP))

  Mail::SMTP.class_eval do
    def deliver_with_mini_profiler(mail)
      Rack::MiniProfiler.step("Mail::SMTP #{settings[:address]}:#{settings[:port]}") do
        deliver_without_mini_profiler(mail)
      end
    end
    alias deliver_without_mini_profiler deliver!
    alias deliver! deliver_with_mini_profiler
  end

end
class Parser
  def run
    options = get_options
    parse(options[:file_path], $stdout)
  rescue ArgumentError => e
    puts e.message
    raise e
  end

  def parse(file_path, out)
    out.puts "Hello"
  end

  private

  def get_options
    raise ArgumentError, "Usage: #{$0} webserver.log" if ARGV.length != 1
    file_path = ARGV[0]

    { file_path: file_path }
  end
end

Parser.new.run
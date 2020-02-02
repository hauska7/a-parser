class Parser
  module MyFile
    def self.each_line(file_path, &block)
      File.readlines(file_path).each(&block)
    end
  end

  def run
    options = get_options
    parse(options[:file_path], $stdout)
  rescue ArgumentError, Errno::ENOENT => e
    puts e.message
    exit 1
  end

  def parse(file_path, out)
    MyFile.each_line(file_path) do |line|
      out.puts line
    end
  end

  private

  def get_options
    raise ArgumentError, "Usage: #{$0} webserver.log -unique/-most_visits" if ARGV.length == 0
    file_path = ARGV[0]

    if ARGV.length > 1
      if ARGV[1] == "-unique"
        parse_mode = "unique"
      elsif ARGV[1] == "-most_visits"
        parse_mode = "most_visits"
      else
        raise ArgumentError, "Usage: #{$0} webserver.log -unique/-most_visits"
      end
    end

    parse_mode = "most_visits" if parse_mode.nil?

    { file_path: file_path, parse_mode: parse_mode }
  end
end

Parser.new.run
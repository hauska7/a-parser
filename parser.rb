class Parser
  module MyFile
    def self.each_line(file_path, &block)
      File.readlines(file_path).each(&block)
    end
  end

  def run
    options = get_options
    parse(options[:file_path], $stdout, options[:parse_mode])
  rescue ArgumentError, Errno::ENOENT => e
    puts e.message
    exit 1
  end

  def parse(file_path, out, mode)
    if mode == "most_visits"
      parse_most_visits(file_path, out)
    elsif mode == "unique_visits"
      parse_unique_visits(file_path, out)
    else fail
    end
  end

  def parse_most_visits(file_path, out)
    result = {}
    result.default = 0
    MyFile.each_line(file_path) do |line|
      page, ip = line.split
      result[page] = result[page] + 1
    end

    result.sort_by { |k, v| -v }.each do |page, visits_count|
      out.puts "#{page} #{visits_count} visits"
    end
  end

  def parse_unique_visits(file_path, out)
    fail
  end

  private

  def get_options
    raise ArgumentError, "Usage: #{$0} webserver.log -unique_visits/-most_visits" if ARGV.length == 0
    file_path = ARGV[0]

    if ARGV.length > 1
      if ARGV[1] == "-unique_visits"
        parse_mode = "unique_visits"
      elsif ARGV[1] == "-most_visits"
        parse_mode = "most_visits"
      else
        raise ArgumentError, "Usage: #{$0} webserver.log -unique_visits/-most_visits"
      end
    end

    parse_mode = "most_visits" if parse_mode.nil?

    { file_path: file_path, parse_mode: parse_mode }
  end
end

Parser.new.run
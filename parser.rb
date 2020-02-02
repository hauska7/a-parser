require 'set'

class Parser
  module Input
    def self.each_line(&block)
      ARGF.each_line(&block)
    end
  end

  def run
    options = get_options
    parse($stdout, options[:parse_mode])
  rescue ArgumentError, Errno::ENOENT => e
    puts e.message
    exit 1
  end

  def parse(out, mode)
    if mode == "most_visits"
      parse_most_visits(out)
    elsif mode == "unique_visits"
      parse_unique_visits(out)
    else fail
    end
  end

  def parse_most_visits(out)
    result = {}
    result.default = 0
    Input.each_line do |line|
      page, ip = line.split
      result[page] = result[page] + 1
    end

    result.sort_by { |k, v| -v }.each do |page, visits_count|
      out.puts "#{page} #{visits_count} visits"
    end
  end

  def parse_unique_visits(out)
    result = Hash.new do |hash, page|
      hash[page] = Set.new
    end

    Input.each_line do |line|
      page, ip = line.split
      result[page] << ip
    end

    result.transform_values! { |ips| ips.size }

    result.sort_by { |page, visits_count| -visits_count }.each do |page, visits_count|
      out.puts "#{page} #{visits_count} unique views"
    end
  end

  private

  def get_options
    help_flag = ARGV.delete("-help")
    raise ArgumentError, "Usage: #{$0} webserver.log -unique_visits OR -most_visits" if help_flag

    unique_visits_flag = ARGV.delete("-unique_visits")
    most_visits_flag = ARGV.delete("-most_visits")
    if unique_visits_flag && most_visits_flag
      raise ArgumentError, "Usage: #{$0} webserver.log -unique_visits OR -most_visits"
    end

    if unique_visits_flag
      parse_mode = "unique_visits"
    elsif most_visits_flag
      parse_mode = "most_visits"
    else
      parse_mode = "most_visits"
    end

    { parse_mode: parse_mode }
  end
end

Parser.new.run
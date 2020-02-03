require 'set'

class Parser
  module Input
    def self.each_line(&block)
      ARGF.each_line(&block)
    end

    def self.fetch_options
      ARGV.select { |arg| arg[0] == "-" }
    end

    def self.remove_options
      ARGV.reject! { |arg| arg[0] == "-" }
    end
  end

  module Output
    def self.puts(message)
      $stdout.puts(message)
    end
  end

  def validate_options(options)
    if ["help", "h"].any? { |help_option| options.include?(help_option) }
      raise ArgumentError, "Usage: #{$0} webserver.log -unique_visits OR -most_visits"
    end

    if options.include?("most_visits") && options.include?("unique_visits")
      raise ArgumentError, "Usage: #{$0} webserver.log -unique_visits OR -most_visits"
    end
    true
  end

  def take_options_and_clean_up_input_for_processing
    options = Input.fetch_options
    Input.remove_options
    options = options.map { |option| option.sub(/-+/, "") }
    options
  end

  def parse_mode(options)
    if options.include?("unique_visits")
      "unique_visits"
    elsif options.include?("most_visits")
      "most_visits"
    else
      "most_visits"
    end
  end

  def run
    options = take_options_and_clean_up_input_for_processing
    validate_options(options)

    parse(parse_mode(options))
  rescue ArgumentError, Errno::ENOENT => e
    Output.puts e.message
    exit 1
  end

  def parse(mode)
    if mode == "most_visits"
      parse_most_visits
    elsif mode == "unique_visits"
      parse_unique_visits
    else fail
    end
  end

  def parse_most_visits
    result = {}
    result.default = 0
    Input.each_line do |line|
      page, ip = line.split
      result[page] = result[page] + 1
    end

    result.sort_by { |k, v| -v }.each do |page, visits_count|
      Output.puts "#{page} #{visits_count} visits"
    end
  end

  def parse_unique_visits
    result = Hash.new do |hash, page|
      hash[page] = Set.new
    end

    Input.each_line do |line|
      page, ip = line.split
      result[page] << ip
    end

    result.transform_values! { |ips| ips.size }

    result.sort_by { |page, visits_count| -visits_count }.each do |page, visits_count|
      Output.puts "#{page} #{visits_count} unique views"
    end
  end
end

Parser.new.run
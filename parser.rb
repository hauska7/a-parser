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
    raise e
  end

  def parse(file_path, out)
    MyFile.each_line(file_path) do |line|
      out.puts line
    end
  end

  private

  def get_options
    raise ArgumentError, "Usage: #{$0} webserver.log" if ARGV.length != 1
    file_path = ARGV[0]

    { file_path: file_path }
  end
end

Parser.new.run
require "rspec"
require 'pry'

describe "test parser" do
  describe "ease of use" do
    it "prints usage message when called without arguments" do
      result = `ruby parser.rb`
      expect($?.exitstatus).to eq 1
      expect(result).to eq "Usage: parser.rb webserver.log -unique_visits/-most_visits\n"
    end

    it "prints error message when argument is not a file" do
      result = `ruby parser.rb no_such_file`
      expect($?.exitstatus).to eq 1
      expect(result).to include "No such file"
    end

    it "prints error message when parse mode is invalid" do
      result = `ruby parser.rb short_webserver.log -invalid_parse_mode`
      expect($?.exitstatus).to eq 1
      expect(result).to eq "Usage: parser.rb webserver.log -unique_visits/-most_visits\n"
    end

    it "script should work with unix pipes" do
      result = `cat short_webserver.log | ruby parser.rb`
      lines = result.lines

      expect(lines[0]).to eq "first line!"
    end
  end

  describe "correctness" do
    it "ordered page visites from most visits to less" do
      result = `ruby parser.rb short_webserver.log -most_visits`
      lines = result.lines

      expect(lines.size).to eq 3
      first_line = lines[0].split
      second_line = lines[1].split
      third_line = lines[2].split
      expect(first_line.size).to eq 3
      expect(first_line[0]).to eq "/help_page/1"
      expect(first_line[1]).to eq "3"
      expect(first_line[2]).to eq "visits"
      expect(second_line[0]).to eq "/home"
      expect(second_line[1]).to eq "2"
      expect(third_line[0]).to eq "/contact"
      expect(third_line[1]).to eq "1"
    end

    it "ordered page visites from most unique visits to less" do
      result = `ruby parser.rb short_webserver.log -unique_visits`
      lines = result.lines

      expect(lines.size).to eq 3
      first_line = lines[0].split
      second_line = lines[1].split
      third_line = lines[2].split
      expect(first_line.size).to eq 4
      expect(first_line[0]).to eq "/home"
      expect(first_line[1]).to eq "2"
      expect(first_line[2]).to eq "unique"
      expect(first_line[3]).to eq "views"
      expect([second_line[0], third_line[0]]).to match_array ["/help_page/1", "/contact"]
      expect([second_line[1], third_line[1]]).to match_array ["1", "1"]
    end
  end
end
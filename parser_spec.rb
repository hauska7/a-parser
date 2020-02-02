require "rspec"
require 'pry'

describe "test parser" do
  describe "ease of use" do
    it "prints usage message when called without arguments" do
      result = `ruby parser.rb`
      expect($?.exitstatus).to eq 1
      expect(result).to eq "Usage: parser.rb webserver.log\n"
    end

    it "prints error message when argument is not a file" do
      result = `ruby parser.rb no_such_file`
      expect($?.exitstatus).to eq 1
      expect(result).to include "No such file"
    end
  end

  describe "correctness" do
    it "ordered page visites from most visits to less" do
      result = `ruby parser.rb short_webserver.log`
      lines = result.lines

      expect(lines.size).to eq 3
      first_line = lines[0].split
      expect(first_line.size).to eq 3
      expect(first_line[0]).to eq "/help_page/1"
      expect(first_line[1]).to eq 3
      expect(first_line[2]).to eq "visits"
      second_line = lines[0].split
      expect(second_line[0]).to eq "/home"
      expect(first_line[1]).to eq 2
      third_line = lines[0].split
      expect(third_line[0]).to eq "/contact"
      expect(third_line[1]).to eq 1
    end

    it "ordered page visites from most unique visits to less" do
      result = `ruby parser.rb short_webserver.log`
      lines = result.lines

      expect(lines.size).to eq 3
      first_line = lines[0].split
      second_line = lines[1].split
      third_line = lines[2].split
      expect(first_line.size).to eq 4
      expect(first_line[0]).to eq "/home"
      expect(first_line[1]).to eq 2
      expect(first_line[2]).to eq "unique"
      expect(first_line[3]).to eq "views"
      expect([second_line[0], third_line[0]]).to match_array ["/home", "/contact"]
      expect([second_line[1], third_line[1]]).to match_array [1, 1]
    end
  end
end
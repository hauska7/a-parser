# README

* How to use program

`ruby parser.rb webserver.log -most_visits`

`ruby parser.rb webserver.log -unique_visits`

You can also use unix piping like `cat webserver.log | ruby parser.rb -most_visits`


* How to run the test suite

`rspec parser_spec.rb`

Tests are dependent on short_webserver.log and parser.rb files. Also on rspec gem (gem install rspec)
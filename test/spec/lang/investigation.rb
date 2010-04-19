require 'clipreasy'
p = CliPrEasy::Lang::Decoder.new.instance_eval do
  process(:identifier => "example") {
    sequence {
      activity(:label => "Do something")
      decision("drunk?") {
        upon(true) {
          parallel {
            activity(:label => "P1", :color => 'white')
            activity(:label => "P2", :color => 'blue')
            activity(:label => "P3")
          }
        }
        upon(false) {
          sequence {
            activity(:label => "Nothing")
            while_do("drunk?") {
              activity(:label => "Rest")
            }
            until_do("drunk?") {
              activity(:label => "Rest")
            }
          }
        }
      }
      activity(:label => "Do something else")
    }
  }
end

db = ::Rubyrel::connect("postgres://clipreasy@localhost/clipreasytest")
p.save_on_rubyrel_db(db)
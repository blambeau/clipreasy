require 'clipreasy'
require File.join(File.dirname(__FILE__), '..', '..', 'fixtures')
include ::CliPrEasy::Fixtures

p = CliPrEasy::Lang::Decoder.new.instance_eval do
  process(:identifier => "example") {
    sequence {
      activity(:label => "Do something") {
        description "coucou les jeunes"
      }
      decision(:condition => "drunk?") {
        upon(:value => true) {
          parallel {
            activity(:label => "P1", :color => 'white')
            activity(:label => "P2", :color => 'blue')
            activity(:label => "P3")
          }
        }
        upon(:value => false) {
          sequence {
            activity(:label => "Nothing")
            while_do(:condition => "drunk?") {
              activity(:label => "Rest")
            }
            until_do(:condition => "drunk?") {
              activity(:label => "Rest")
            }
          }
        }
      }
      activity(:label => "Do something else")
    }
  }
end

puts p.inspect

db = ::Rubyrel::connect("postgres://clipreasy@localhost/clipreasytest")
db.model.sequences.empty!
db.model.parallels.empty!
db.model.untils.empty!
db.model.whiles.empty!
db.model.activities.empty!
db.model.decision_when_clauses.empty!
db.model.decisions.empty!
db.model.statements.empty!
db.model.processes.empty!

db.transaction do |t|
  p.save_on_relational_model(db.model)
end

puts db.model.statements.inspect
puts db.model.decisions.inspect
puts db.model.activities.inspect
require 'clipreasy'
require File.join(File.dirname(__FILE__), '..', '..', '..', 'fixtures')
include ::CliPrEasy::Fixtures

file = process_file("rxth_v2.cpe")
puts file
p = ::CliPrEasy::Persistence::XML::Decoder.new.decode_file(file)

p.merge(:identifier => 'rxth_v2')
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
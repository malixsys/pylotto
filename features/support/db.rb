# encoding: utf-8
require 'datamapper'

class DB
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/my.db")

  class NameValue
    include DataMapper::Resource

    property :id,         Serial
    property :name,         String, :required => true
    property :value,         String
  end
  
  DataMapper.finalize
  DataMapper.auto_upgrade!
  
  def self.save(value)
    NameValue.all.destroy
    NameValue.create :name => "db", :value => value.to_json
  end

  def self.load
    res = NameValue.first(:name => "db")
    JSON.parse(res.value)
  rescue JSON::ParserError
    res.value
  end
end
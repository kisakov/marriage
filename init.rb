DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:///#{Dir.pwd}/files.db")

class Person
  include DataMapper::Resource

  property :id, Serial   # primary serial key
  property :last_name,  String,    :required => true
  property :first_name, String,    :required => true
  property :sex,        String,    :required => true
  property :age,        Integer,   :required => true
  property :marriage,   Boolean
  property :created_at, DateTime


  default_scope(:default).update(:order => [:last_name.asc])
end

class Marriage
  include DataMapper::Resource

  property :id, Serial   # primary serial key
  property :groom_id,   Integer,    :required => true
  property :bride_id,   Integer,    :required => true
  property :music,      String
  property :flowers,    String
  property :guests,     String
  property :created_at, DateTime


  default_scope(:default).update(:order => [:created_at.desc])
end

DataMapper.auto_upgrade!

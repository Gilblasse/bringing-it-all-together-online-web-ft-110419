class Dog 
  attr_accessor :name,:breed
  attr_reader :id
  
  def initialize(id: nil,name:,breed:)
    @id = id
    @name = name
    @breed = breed
  end
  
  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
        )
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql =  <<-SQL
      DROP TABLE IF EXISTS dogs
    SQL
    DB[:conn].execute(sql)
  end
  
  def save
    sql =  <<-SQL
      INSERT INTO dogs(name,breed) VALUES(?,?)
    SQL
    DB[:conn].execute(sql,self.name,self.breed)
    @id = DB[:conn].execute("SELECT * FROM dogs").last.first
    self
  end
  
  def self.create(hash)
    new_dog = self.new(name: hash[:name],breed: hash[:breed])
    dog = new_dog.save
    dog
  end
  
  def self.new_from_db(row)
    dog = self.new(id: row[0],name: row[1], breed: row[2])
    dog
  end
end
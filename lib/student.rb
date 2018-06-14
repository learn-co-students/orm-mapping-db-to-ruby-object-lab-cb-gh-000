require 'pry'

class Student
  attr_accessor :name, :grade, :id 


  def self.new_from_db(row)
    # create a new Student object given a row from the database
    row.flatten!
    new = self.new
    new.id = row[0]
    new.name = row[1]
    new.grade = row[2]
    new 
    
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL 
              SELECT * 
              FROM students 
              SQL
              
    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
    
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL 
            SELECT * 
            FROM students 
            WHERE name = ?
            LIMIT 1 
            SQL
            
    row = DB[:conn].execute(sql, name)
    ret = self.new_from_db(row)
    ret 
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  
  def self.count_all_students_in_grade_9
    
    sql = <<-SQL 
            SELECT *
            FROM students 
            WHERE grade = ?
              SQL
              
    ret = DB[:conn].execute(sql, "9")
    # binding.pry 
    ret 
  end 
  
  def self.students_below_12th_grade 
    
    ret = []
    sql = <<-SQL 
            SELECT * 
            FROM students 
            WHERE grade = ?
            SQL
    
    grades = [1,2,3,4,5,6,7,8,9,10,11]
    grades.each do |grade|
      ret += DB[:conn].execute(sql, grade.to_s)
    end   
    
    ret.map do |row|
      self.new_from_db(row)
    end 
    
  end 

  def self.first_X_students_in_grade_10(num)
    
    sql = <<-SQL 
              SELECT *
              FROM students 
              WHERE grade = "10"
              LIMIT ?
              SQL
  
    DB[:conn].execute(sql, num)
    
  end 
  
  def self.first_student_in_grade_10
    
    sql = <<-SQL 
            SELECT *
            FROM students 
            WHERE grade = "10"
            LIMIT 1
            SQL
      
    row = DB[:conn].execute(sql)
    self.new_from_db(row)
  end 
  
  def self.all_students_in_grade_X(grade)
    
    sql = <<-SQL 
              SELECT *
              FROM students 
              WHERE grade = ?
              SQL
              
    DB[:conn].execute(sql, grade.to_s)
    
  end 
  
end 


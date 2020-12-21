class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    s=Student.new
    s.id=row[0]
    s.name=row[1]
    s.grade=row[2]
    return s
  end

  def self.all_students_in_grade_9
    sql="SELECT * FROM students WHERE grade=9"
    arr=DB[:conn].execute(sql)
    arr2=arr.collect do |row|
      Student.new_from_db(row)
    end
    return arr2
  end

  def self.students_below_12th_grade
    sql="SELECT * FROM students WHERE grade<12"
    arr=DB[:conn].execute(sql)
    arr2=arr.collect do |row|
      Student.new_from_db(row)
    end
    return arr2
  end

  def self.first_X_students_in_grade_10(number)
    sql="SELECT * FROM students WHERE grade=10 LIMIT ?"
    arr=DB[:conn].execute(sql,number)
    arr.collect do |row|
      Student.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql="SELECT * FROM students WHERE grade=10 LIMIT 1"
    arr=DB[:conn].execute(sql)
    arr.collect do |row|
      Student.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(number)
    sql="SELECT * FROM students WHERE grade=?"
    arr=DB[:conn].execute(sql,number)
    arr.collect do |row|
      Student.new_from_db(row)
    end
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql="SELECT * FROM students"
    arr=DB[:conn].execute(sql)
    arr2=arr.collect do |row|
      Student.new_from_db(row)
    end
    return arr2
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql="SELECT * FROM students WHERE name=?"
    arr=DB[:conn].execute(sql,name)
    return Student.new_from_db(arr[0])
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
end

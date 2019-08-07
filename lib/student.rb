class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT id, name, grade FROM students WHERE name = ?
    SQL

    usr = DB[:conn].execute(sql, name)
    Student.new_from_db(usr[0])

  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT id, name, grade FROM students WHERE grade = 9
    SQL

    usrs = []
    DB[:conn].execute(sql).each do |us|
      usrs << Student.new_from_db(us)
    end
    return usrs
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT id, name, grade FROM students WHERE grade < 12
    SQL

    usrs = []
    DB[:conn].execute(sql).each do |us|
      usrs << Student.new_from_db(us)
    end
    return usrs
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    usrs = []
    DB[:conn].execute(sql).each do |us|
      usrs << Student.new_from_db(us)
    end
    return usrs
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL

    usrs = []
    DB[:conn].execute(sql, x).each do |us|
      usrs << Student.new_from_db(us)
    end
    return usrs
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL

    us = DB[:conn].execute(sql)
    Student.new_from_db(us[0])
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    usrs = []
    DB[:conn].execute(sql, x).each do |us|
      usrs << Student.new_from_db(us)
    end
    return usrs
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

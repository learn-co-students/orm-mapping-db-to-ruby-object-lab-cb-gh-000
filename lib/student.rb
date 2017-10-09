class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id    = row[0]
    student.name  = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students;"
    students = []
    DB[:conn].execute(sql).each do |row|
      students << Student.new_from_db(row)
    end
    students
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    DB[:conn].execute(sql,name).map { |row| Student.new_from_db(row) }.first
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
    # sql = "SELECT * FROM students WHERE grade = 9;"
    # students = []
    # DB[:conn].execute(sql).each { |row| students << Student.new_from_db(row) }
    # students
    Student.all_students_in_grade_x(9)
  end

  def self.students_below_12th_grade
    students = Student.all.reject { |student| student.grade.to_i >= 12 }
  end

  def self.first_x_students_in_grade_10(number_desired)
    sql = "SELECT * FROM students WHERE grade = 10;"
    students = []
    DB[:conn].execute(sql).each { |row| students << Student.new_from_db(row) }
    students[0..(number_desired-1)]
  end

  def self.first_student_in_grade_10
    Student.first_x_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_x(grade_desired)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?;
    SQL
    students = []
    DB[:conn].execute(sql,grade_desired).each { |row| students << Student.new_from_db(row) }
    students
  end

end

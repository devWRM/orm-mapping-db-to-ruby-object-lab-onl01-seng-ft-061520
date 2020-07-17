class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    
    # create a new Student object given a row from the database
    retrieved_student = self.new
    retrieved_student.id = row[0]
    retrieved_student.name = row[1]
    retrieved_student.grade = row[2]
    
    retrieved_student
    #retrieved_student => #<Student:0x00007f9bf612b300 @grade=12, @id=1, @name="Pat">
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students;
    SQL
    # sql =>    "      SELECT * FROM students;\n"
  
    ans = DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end



  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    @name = name

    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1;
    SQL
    # sql =>  "      SELECT * FROM students\n      WHERE name = ?\n      LIMIT 1;\n"
    # retrieved_name_row =>    [[1, "Pat", "12"]]
    retrieved_name_row = DB[:conn].execute(sql, name)

    retrieved_to_instance = retrieved_name_row.map do |row|
      self.new_from_db(row)
    end
    retrieved_to_instance[0]
    # retrieved_to_instance => [#<Student:0x00007f8f87343ac8 @grade="12", @id=1, @name="Pat">]   
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

  def self.all_students_in_grade_9
    self.all.select do |student|
      student.grade == "9"
    end
  end

  def self.students_below_12th_grade
    self.all.select do |student|
      student.grade.to_i < 12
    end
  end

  def self.first_X_students_in_grade_10(x)
    students = self.all.select do |student|
      student.grade == "10"
    end

    ans = []
    index = x - 1
    x.times do
      ans << students[index]
      index -= 1
    end
    ans
  end

  def self.first_student_in_grade_10
    self.all.find do |student|
      student.grade == "10"
    end
  end

  def self.all_students_in_grade_X(x)
    self.all.select do |student|
      student.grade.to_i == x
    end
  end







end

class Student < ActiveRecord::Base
  mount_uploader :photo, AvatarUploader

  enum gender: [:male, :female]

  belongs_to :agency
  belongs_to :iclass
  has_many :behaviors
  has_and_belongs_to_many :class_roles, -> { uniq }

  validates :sid, presence: true, uniqueness: { scope: :agency,  
		message: ": One school should not have 2 same student sid." }
  validates :name, presence: true

  def self.import(file, agency)
    s = open_spreadsheet(file)
    s.default_sheet = s.sheets.first
    new_count = 0
    (2..s.last_row).each do |i|
      row = s.row(i)
      (1..4).each do |col|
        if row[col].nil? || row[col] == "" 
          return [-1,0]
        end
      end
      # student = Student.find_by(agency: agency, sid: row[4]) || new
      student = Student.find_by(agency: agency, sid: row[4])
      if student.nil?
        student = Student.new
        new_count += 1
      end
      if Grade.find_by(agency: agency, name: row[1]).nil?
        Grade.create(name: row[1], description: row[1], agency: agency)
      end
      if Iclass.find_by(agency: agency, name: row[2]).nil?
        Iclass.create(name: row[2], grade: Grade.find_by(agency: agency, name: row[1]), agency: agency)
      end
      student_sid = row[4].to_s
      student.attributes = {
        agency: agency,
        iclass: Iclass.find_by(agency: agency, name: row[2]),
        name: row[3],
        sid: student_sid.include?(".")? student_sid.slice(0, student_sid.index(".")) : student_sid,
        id_number: row[5],
        phone: row[6],
        card_type: row[7],
        card_status: row[8],
        open_date: row[9],
        bank_account: row[10]
      }
      student.save!
    end
    return [s.last_row - 1, new_count]
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".CSV" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)  
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
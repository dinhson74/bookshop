class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable, :confirmable

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_PHONE_REGEX = /\d[0-9]\)*\z/

  has_many :books, dependent: :destroy,foreign_key: 'creator_id'
  has_many :comments, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :phone, presence: true, length: { minimum: 9, maximum: 11 },
            format: { with: VALID_PHONE_REGEX ,
            message: :invalid_phone }
  validates :address, presence: true
  validates :phone, presence: true
  validates :birthday, presence: true
  validates :password, presence: true, on: :create
  # callback
  before_save { email.downcase }

  validate :valid_age, if: -> { birthday.present? }

  def self.to_csv
    attributes = %w{name email address phone birthday admin created_at updated_at encrypted_password}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

  def self.import_file(file)
    begin
    CSV.foreach(file.path, headers: true ) do |row|
      User.create! row.to_hash
    end
    rescue Exception => e
      return "Error: #{e}"
    end
  end

  private
    def valid_age
      return if valid_date_range.include?(birthday)
      errors.add(:birthday, message: :invalid_birthday)
    end

    def valid_date_range
      maximum_date..minimum_date
    end

    def minimum_date
      Date.new(Date.today.year - 6)
    end

    def maximum_date
      Date.new(Date.today.year - 120)
    end
end

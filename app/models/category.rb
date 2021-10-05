class Category < ApplicationRecord
  has_many :books, dependent: :destroy

  validates :name, presence: true

  scope :sort_by_name, -> {order :name}

  def self.to_csv
    attributes = %w{name created_at updated_at}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |category|
        csv << attributes.map{ |attr| category.send(attr) }
      end
    end
  end

  def self.import_file(file)
    begin
    CSV.foreach(file.path, headers: true ) do |row|
      Category.create! row.to_hash
    end
    rescue Exception => e
      return "Error: #{e}"
    end
  end
end

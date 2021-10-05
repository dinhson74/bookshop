module ApplicationHelper
  def load_categories
    @categories = Category.sort_by_name.map{|category| [category.name, category.id]}
  end
end

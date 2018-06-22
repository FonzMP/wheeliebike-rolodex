class User < ActiveRecord::Base
  has_many :motorcycles

  def slug
    @slug = self.username.downcase.gsub(" ", "-")
  end
  
  def self.find_by_slug(slug_name)
    self.all.each do |user|
      if user.slug = slug_name
        return user
      end
    end
  end

end
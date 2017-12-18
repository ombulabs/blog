module Jekyll
  module Drops
    class UrlDrop < Drop

    # override UrlDrop method in order to return categories names as slug
    # instead of strings
    #
    # An category like "category with space" will be
    # slugified for : /category-with-space
    # instead of url encoded form : /category%20with%20space
    #
    # @see utils.slugify
      def categories
        category_set = Set.new
        Array(@obj.data["categories"]).each do |category|
          category_set << Utils.slugify(category).to_s.downcase
        end
        category_set.to_a.join("/")
      end
    end
  end
end

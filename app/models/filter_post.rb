class FilterPost

  def self.filter(collection, attrs, words)
    return collection if collection.count == 0
    collection.where(match_stmt(collection.first, attrs, words))
  end

  def self.match_stmt(object, attrs, words)
    attrs.map do |attr|
      words.split(/[. ,\n|]/).map do |word|
        "#{object.class.table_name}.#{attr} !~* '#{word}'"
      end.join(' and ')
    end.join(' and ')
  end
end

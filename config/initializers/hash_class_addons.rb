# for policy system
# recursivly hash merging
# keep hesh key's as symbol

class Hash 
  def recursive_merge!(hash= nil)
    return self unless hash.is_a?(Hash)
    base= self
    hash.each do |key, v|
      if base[key.to_sym].is_a?(Hash) && hash[key.to_sym].is_a?(Hash)
        base[key.to_sym]= base[key.to_sym].recursive_merge!(hash[key.to_sym])
      else
        base[key.to_sym]= hash[key.to_sym]
      end
    end
    base.to_hash
  end#recursive_merge!
  
  def recursive_set_values_on_default!(default_value= false)
    base= self
    base.each do |key, v|
      if base[key.to_sym].is_a?(Hash)
        base[key.to_sym]= base[key.to_sym].recursive_set_values_on_default!(default_value)
      else
        base[key.to_sym]= default_value
      end
    end
  end#recursive_set_values_on_default
  
  def recursive_merge_with_default!(hash= nil, default_value= true)
    return self unless hash.is_a?(Hash)
    base= self
    hash.each do |key, v|
      if base[key.to_sym].is_a?(Hash) && hash[key.to_sym].is_a?(Hash)
        base[key.to_sym]= base[key.to_sym].recursive_merge_with_default!(hash[key.to_sym], default_value)
      else
        base[key.to_sym]= default_value
      end
    end
    base.to_hash
  end#recursive_merge_with_default
end#Hash

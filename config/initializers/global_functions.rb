def class_exists?(name)
  begin
    true if Kernel.const_get(name)
  rescue NameError
    false
  end
end

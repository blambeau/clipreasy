class Module
  
  def short_name
    if /::([A-Z0-9a-z]+)$/ =~ name.to_s
      $1.to_sym
    else
      name
    end
  end
  
end
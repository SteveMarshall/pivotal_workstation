action :write do
  execute "#{new_resource.description} - #{new_resource.domain} - #{new_resource.key}"  do
    command %Q{defaults write #{new_resource.domain} "#{new_resource.key}" #{type_flag} '#{value}'}
    user WS_USER
    not_if %Q{defaults read #{new_resource.domain} "#{new_resource.key}" | grep ^#{value}$}, :user => WS_USER
  end
end
action :delete do
  execute "#{new_resource.description} - #{new_resource.domain}"  do
    command %Q{defaults delete #{new_resource.domain} "#{new_resource.key}"}
    user WS_USER
    only_if %Q{defaults read #{new_resource.domain} "#{new_resource.key}"}, :user => WS_USER
  end
end

def type_flag
  return '-array' if new_resource.array
  return '-int' if new_resource.integer
  return '-string' if new_resource.string
  return '-float' if new_resource.float
  return '-boolean' unless new_resource.boolean.nil?
  ''
end

def value
  (new_resource.array && new_resource.array.join("' '")) ||
    new_resource.integer ||
    new_resource.string ||
    (new_resource.float && new_resource.float.to_f) ||
    new_resource.boolean
end

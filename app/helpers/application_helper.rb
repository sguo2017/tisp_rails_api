module ApplicationHelper

  # 常量哈希表翻译
  def tc(origin_value, target_name)
    return '' if origin_value.blank? or target_name.blank?
    origin_value = origin_value.to_s
    target = eval(target_name.to_s)
    translator_name =  target_name + '_TRANSLATE'
    translator = eval(translator_name)
    found = target.select{|k,v| v == origin_value}.keys
    key = found[0] if found.size > 0
    if key and translator[key]
      translator[key.to_sym] || translator[key.to_s]
    else
      origin_value
    end
  end

  def tcl(list,target_name)
    return '' if list.blank? or target_name.blank?
    list.map{|to_translate,origin| tc(to_translate,target_name)}
  end

  def tb(boolean_value)
    case boolean_value
    when true
      '是'
    when false
      '否'
    else
      boolean_value
    end
  end


end

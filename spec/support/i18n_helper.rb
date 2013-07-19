module I18nHelper
  def t(*args)
    I18n.t(*args)
  end

  def l(*args)
    I18n.l(*args)
  end

  def tmid(key)
    t("mongoid.attributes.#{key}")
  end
end

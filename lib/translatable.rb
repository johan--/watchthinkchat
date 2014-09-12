module Translatable
  def translatable(*methods)
    methods.each do |method_name|
      # setter
      define_method "#{method_name}=" do |value|
        super(value)
        t = translations.base.find_or_initialize_by(field: method_name,
                                                    resource: self)
        translations << t unless persisted?
        t.content = value
        t.save if persisted?
      end
    end
  end
end

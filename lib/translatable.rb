module Translatable
  def translatable(*methods)
    methods.each do |method_name|
      # setter
      define_method "#{method_name}=" do |value|
        super(value)
        t = Translation.find_or_initialize_by(field: method_name,
                                              resource: self,
                                              base: true)
        translations << t unless t.persisted?
        t.content = value
        t.save if t.persisted?
      end
    end
  end
end

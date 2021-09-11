# frozen_string_literal: true

module SGC::SDK
  #
  # SGCのコンフィグ用のModule。
  #
  module Config
    # @!attribute [rw] types
    #   @return [Array<Class>] Eventクラスを継承したクラスのリスト。
    #   @raise [ClassNotInheritEvent] Eventクラスを継承していないクラスが指定された場合。
    attr_reader :types

    def types=(types)
      not_inherited_classes = types.filter { |type| not type < Event }
      if !not_inherited_classes.empty?
        raise ClassNotInheritEvent, "Eventクラスを継承した型を指定する必要があります。\n#{not_inherited_classes.join(", ")}"
      end
      @types = types
    end

    # @return [Boolean] typesを自動設定するかどうか。
    attr_accessor :auto_types

    # @return [Boolean] {SGC::SDK::RawEventData#event_type}をSymbolにしてスネークケースに変換するかどうか。
    attr_accessor :rubyize_event_type

    @types = []
    @auto_types = false
    @rubyize_event_type = true

    module_function :types, :types=, :auto_types, :auto_types=, :rubyize_event_type, :rubyize_event_type=
  end
end

# frozen_string_literal: true

require "discorb"
require "json"

module SGC::SDK
  #
  # 生データと各イベントクラスの橋渡し役になるクラス。
  #
  class RawEventData
    # @return [Discorb::Member, nil] イベントを送ったBotユーザーオブジェクト。
    attr_reader :user
    # @return [Discorb::Message, nil] 送られてきたメッセージオブジェクト。
    attr_reader :message
    # @return [Hash{Symbol => Object}] 解析済みのJSONデータ。
    attr_reader :data

    # @!attribute [r] event_type
    #   @return [String, Symbol] イベントの種類。{SGC::SDK::Config#rubyize_event_type}がtrueの場合はSymbolに変換され、スネークケースになります。
    def event_type
      if SGC::SDK::Config.rubyize_event_type
        raw = @data[:type]
        raw.gsub!(/[A-Z]/, '_\0')
        raw.gsub!(/-_?/, "_")
        raw.downcase.to_sym
      else
        @data[:type]
      end
    end

    #
    # RawEventDataクラスのインスタンスを生成する。
    #
    # @param [Discorb::Message, Hash] data 送られてきたメッセージ、または解析済みのJSONデータ。
    # @note dataにハッシュを指定した場合は{SGC::SDK::RawEventData#user}はnilを返します。
    #
    def initialize(data)
      if data.is_a?(Discorb::Message)
        @message = message
        @user = message.author
        @data = JSON.parse(message.content, symbolize_names: true)
      else
        @message = nil
        @user = nil
        @data = JSON.parse(JSON[data], symbolize_names: true)
      end
    end

    #
    # {SGC::SDK::Event} をデータから生成する。
    #
    # @return [SGC::SDK::Event] {SGC::SDK::Event} のインスタンス。
    # @raise [SGC::SDK::TypeNotDefined] イベントクラスが見つからなかった場合。
    #
    def emit
      event_classes = SGC::SDK::Config.auto_types ? get_event_descendents : SGC::SDK::Config.types
      event_class = event_classes.find { |klass| klass.event_type == data[:type] }
      event_class.new(self)
    end

    private

    def get_event_descendents
      ObjectSpace.each_object(Class).select { |klass| klass < SGC::SDK::Event }
    end
  end
end

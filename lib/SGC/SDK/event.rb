# frozen_string_literal: true

module SGC::SDK
  #
  # SGCのイベントを扱うクラス。
  # @abstract
  #
  class Event
    # @return [Hash] イベントのデータ。
    attr_reader :data

    #
    # dataからイベントを作成する。
    #
    # @param [Hash] data イベントのデータ。
    #
    def initialize(data)
      @data = data
    end

    #
    # イベントを手動で生成する。
    # @note これは継承したクラスで使用します。{SGC::SDK::Event.create_event}をそのまま呼び出すとNotImplementedErrorが発生します。
    #
    def self.create_event(...)
      raise NotImplementedError
    end

    class << self
      attr_reader :event_type
    end
  end
end

# frozen_string_literal: true

module SGC::SDK
  # SGC::SDKのエラーを表すクラス。
  class Error < StandardError; end

  # {SGC::SDK::Config.types} のクラスが{SGC::SDK::Event}を継承していない場合に発生するエラー。
  class ClassNotInheritEvent < Error; end

  # {SGC::SDK::RawEventData.emit} で対応するイベントが存在しない場合に発生するエラー。
  class TypeNotDefined < Error; end
end

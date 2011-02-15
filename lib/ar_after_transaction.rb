module ARAfterTransaction
  extend ActiveSupport::Concern

  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

  module ClassMethods
    @@after_transaction_callbacks = []

    def transaction(&block)
      super(&block).tap do
        delete_after_transaction_callbacks.map(&:call) unless transactions_open?
      end
    ensure
      delete_after_transaction_callbacks unless transactions_open?
    end

    def after_transaction(&block)
      if transactions_open?
        @@after_transaction_callbacks << block
      else
        yield
      end
    end

    def normally_open_transactions
      @@normally_open_transactions ||= 0
    end

    def normally_open_transactions=(transactions)
      @@normally_open_transactions = transactions
    end

    private

    def transactions_open?
      connection.open_transactions > normally_open_transactions
    end

    def delete_after_transaction_callbacks
      result = @@after_transaction_callbacks
      @@after_transaction_callbacks = []
      result
    end
  end

  def after_transaction(&block)
    self.class.after_transaction(&block)
  end
end

if defined? Rails && defined? Rails::Railtie
  class Railtie < Rails::Railtie
    initializer "ar_after_transaction.initialize" do |app|
      ::ActiveRecord::Base.send :include, ARAfterTransaction if defined? ::ActiveRecord::Base
    end
  end
else
  ::ActiveRecord::Base.send :include, ARAfterTransaction
end
module ARAfterTransaction
  extend ActiveSupport::Concern

  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

  module ClassMethods
    @@after_transaction_callbacks = []

    def transaction(&block)
      super(&block)
      delete_after_transaction_callbacks.map(&:call) unless transactions_open?
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

    private

    def transactions_open?
      connection.open_transactions > normally_open_transactions
    end

    def normally_open_transactions
      Rails.env.test? ? 1 : 0
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

ActiveRecord::Base.send(:include, ARAfterTransaction)

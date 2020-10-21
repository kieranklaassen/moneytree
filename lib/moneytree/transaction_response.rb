module Moneytree
  class TransactionResponse
    attr_reader :message, :status

    def initialize(status, message = '')
      @status = status
      @message = message
    end

    def success?
      @status == :success
    end
  end
end

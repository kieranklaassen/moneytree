module Moneytree
  class TransactionResponse
    attr_reader :message, :status, :body

    def initialize(status, message = '', body)
      @status = status
      @message = message
      @body = body
    end

    def success?
      @status == :success
    end
  end
end

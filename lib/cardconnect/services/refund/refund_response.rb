module CardConnect
  module Service
    class RefundResponse
      include Utils

      FIELDS = [:merchid, :amount, :retref, :respcode, :respproc, :respstat, :resptext]

      attr_accessor *FIELDS
      attr_reader :errors

      STATUS_APPROVED = 'A'
      STATUS_RETRY = 'B'
      STATUS_DECLINED = 'C'

      def initialize(response)
        set_attributes(response, FIELDS)
        @errors = []
        process_errors
      end

      def success?
        errors.empty?
      end

      def body
        body = {}
        FIELDS.each do |attr|
          body.merge!({attr => send(attr)})
        end
        body
      end

      private

      def process_errors
        @errors << resptext if [STATUS_RETRY, STATUS_DECLINED].include?(respstat)
      end
    end
  end
end
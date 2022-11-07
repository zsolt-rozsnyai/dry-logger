# frozen_string_literal: true

require "dry/logger/formatters/structured"

module Dry
  module Logger
    module Formatters
      # Basic string formatter.
      #
      # This formatter returns log entries in key=value format.
      #
      # @since 1.0.0
      # @api public
      class String < Structured
        # @since 1.0.0
        # @api private
        SEPARATOR = " "

        # @since 1.0.0
        # @api private
        HASH_SEPARATOR = ","

        # @since 1.0.0
        # @api private
        EXCEPTION_SEPARATOR = ": "

        # @since 1.0.0
        # @api private
        DEFAULT_TEMPLATE = "%<message>s"

        # @since 1.0.0
        # @api private
        attr_reader :template

        # @since 1.0.0
        # @api private
        def initialize(template: DEFAULT_TEMPLATE, **options)
          super(**options)
          @template = template
        end

        private

        # @since 1.0.0
        # @api private
        def format(entry)
          "#{template % entry.meta.merge(message: format_entry(entry))}#{NEW_LINE}"
        end

        # @since 1.0.0
        # @api private
        def format_entry(entry)
          if entry.exception?
            format_exception(entry)
          elsif entry.message
            if entry.payload.empty?
              entry.message
            else
              "#{entry.message}#{SEPARATOR}#{format_payload(entry)}"
            end
          else
            format_payload(entry)
          end
        end

        # @since 1.0.0
        # @api private
        def format_exception(entry)
          hash = entry.payload
          message = hash.values_at(:error, :message).compact.join(EXCEPTION_SEPARATOR)
          "#{message}#{NEW_LINE}#{hash[:backtrace].map { |line| "from #{line}" }.join(NEW_LINE)}"
        end

        # @since 1.0.0
        # @api private
        def format_payload(entry)
          entry.map { |key, value| "#{key}=#{value.inspect}" }.join(HASH_SEPARATOR)
        end
      end
    end
  end
end

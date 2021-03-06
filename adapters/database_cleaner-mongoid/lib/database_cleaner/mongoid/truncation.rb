require 'database_cleaner/mongoid/base'
require 'database_cleaner/generic/truncation'
require 'database_cleaner/mongo/truncation_mixin'
require 'database_cleaner/mongo2/truncation_mixin'
require 'database_cleaner/moped/truncation_base'
require 'mongoid/version'

module DatabaseCleaner
  module Mongoid
    class Truncation
      include ::DatabaseCleaner::Mongoid::Base
      include ::DatabaseCleaner::Generic::Truncation

      if ::Mongoid::VERSION < '3'

        include ::DatabaseCleaner::Mongo::TruncationMixin

        private

        def database
          ::Mongoid.database
        end

      elsif ::Mongoid::VERSION < '5'

        include ::DatabaseCleaner::Moped::TruncationBase

        private

        def session
          ::Mongoid::VERSION > "5.0.0" ? ::Mongoid.default_client : ::Mongoid.default_session
        end

        def database
          if not(@db.nil? or @db == :default)
            ::Mongoid.databases[@db]
          else
            ::Mongoid.database
          end
        end

      else

        include ::DatabaseCleaner::Mongo2::TruncationMixin

        alias super_database database

        private

        def database
          if ::Mongoid::VERSION > '5'
            ::Mongoid.default_client.database
          else
            super_database
          end
        end

      end
    end
  end
end

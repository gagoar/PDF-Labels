require File.expand_path(File.dirname(__FILE__) + '/alias')
require File.expand_path(File.dirname(__FILE__) + '/label')
require File.expand_path(File.dirname(__FILE__) + '/markup')

module Pdf
  module Label
    class Template
      include XML::Mapping
      attr_accessor :labels

      text_node   :name,         '@name'
      text_node   :size,         '@size'
      text_node   :description,  '@description',  default_value: ''
      text_node   :_description, '@_description', default_value: ''

      length_node :width,        '@width',        default_value: nil
      length_node :height,       '@height',       default_value: nil

      #TODO this could be cleaner, but I'm not sure how yet
      hash_node :labelRectangles, 'Label-rectangle', '@id', class: LabelRectangle, default_value: nil
      hash_node :labelRounds,     'Label-round',     '@id', class: LabelRound,     default_value: nil
      hash_node :labelCDs,        'Label-cd',        '@id', class: LabelCD,        default_value: nil

      hash_node :alias, 'Alias', '@name', class: Alias, default_value: Hash.new

      def initialize

      end

      def labels
        @labels ||= [ @labelRectangles, @labelRounds, @labelCDs ].reduce(:merge)
      end

      def nx
        first_layout.nx if first_layout
      end

      def ny
        first_layout.ny if first_layout
      end

      def find_description
        _description || description
      end

      private

      def first_layout
        label = labels["0"]
        label.layouts.first if label
      end
    end
  end
end

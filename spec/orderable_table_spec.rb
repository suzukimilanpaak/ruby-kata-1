# frozen_string_literal: true
require 'spec_helper'
require_relative '../lib/orderable_table'

describe OrderableTable do
  describe "#sort_by" do
    let(:table) do
      OrderableTable.new('data/books.csv')
    end

    let(:expected) do
      {}
    end

    it { expect(table.sort_by(:title)).to eq(expected) }
  end
end


# frozen_string_literal: true
require 'csv'
require 'pp'

class OrderableTable
  def initialize()
    @table = table(file)
  end

  def sort_by(col)
    col = col.to_sym
    raise ArgumentError, "Undefined Column: #{col}" unless @table.headers.include?(col)

    @table.sort {|a, b| a[col] <=> b[col]}
  end

  def select_by(col, val)
    col = col.to_sym
    raise ArgumentError, "Undefined Column: #{col}" unless @table.headers.include?(col)

    @table.select {|a| a[col] == val}
  end

  def find_by(col, val)
    col = col.to_sym
    raise ArgumentError, "Undefined Column: #{col}" unless @table.headers.include?(col)

    @table.find {|a| a[col] == val}
  end

  private

  def file
    ''
  end

  def table(file)
    options = { col_sep: ';', headers: true, header_converters: [:symbol] }
    CSV.read(file, **options)
  end
end

class Authors < OrderableTable
  private

  def file
    'data/authors.csv'
  end
end

class Magazines < OrderableTable
  private

  def file
    'data/magazines.csv'
  end
end

class Books < OrderableTable
  private

  def file
    'data/books.csv'
  end
end

class Publishment
  def initialize(row)
  end

  def to_s
    summary << "\n"
  end

  private

  def summary
    publishment.summary
  end

  private

  attr_reader :publishment
end

class MagazineSummary
  def initialize(row)
    @authors = Authors.new
    @row = row
  end

  def author
    authors.find_by(:email, row[:authors])
  end

  def summary
    <<EOM
    Title: #{row[:title]}
    Author: #{author[:firstname]} ${author[:lastname]}
    ISBN: #{row[:isbn]}
    Published At: #{row[:publishedat]}
EOM
  end

  private

  attr_reader :row, :authors
end

class Magazine < Publishment
  def initialize(row)
    @publishment = MagazineSummary.new(row)
  end
end

Magazines.new.select_by(:authors, 'null-walter@echocat.org').each do |row|
  puts Magazine.new(row)
end

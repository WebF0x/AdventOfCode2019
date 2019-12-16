# frozen_string_literal: true

file_content = File.open('input.sql').read
masses = file_content.split("\n").map(&:to_i)
fuels = masses.map { |mass| mass / 3 - 2 }
solution = fuels.reduce(0, :+)
puts solution

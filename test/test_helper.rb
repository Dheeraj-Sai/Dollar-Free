# frozen_string_literal: true

if ENV["COVERAGE"] == "true"
  require "coverage"
  Coverage.start
end

require "minitest/autorun"
require "stringio"
require_relative "../lib/main_menu"

Minitest.after_run do
  next unless ENV["COVERAGE"] == "true"

  require "fileutils"
  project_root = File.expand_path("..", __dir__)
  library_path = File.join(project_root, "lib")
  total_lines = 0
  covered_lines = 0

  Coverage.result.each do |file, line_counts|
    next unless file.start_with?(library_path)

    relevant_lines = line_counts.compact
    total_lines += relevant_lines.length
    covered_lines += relevant_lines.count { |count| count.positive? }
  end

  percentage = total_lines.zero? ? 0 : (covered_lines.to_f / total_lines * 100).round(2)
  report_folder = File.join(project_root, "coverage")
  FileUtils.mkdir_p(report_folder)
  File.write(File.join(report_folder, "coverage.txt"), "Line coverage: #{percentage}% (#{covered_lines}/#{total_lines})\n")
  puts "Coverage report written to coverage/coverage.txt: #{percentage}%"
end

module TestNav

  TEST_FILE_REGEX = /(_|-)?([Ss]pec|[Tt]est)\Z/
  TEST_FILE_WITH_END_PERIOD_REGEX = /(_|-)?([Ss]pec|[Tt]est)\./

  class << self

    def toggle
      current_directory = VIM::evaluate("getcwd()")
      current_buffer = VIM::Buffer.current
      current_file = current_buffer.name
      return if current_file.nil?
      alternate_file = find_alternate_file_path(current_directory, current_file)
      return if alternate_file.nil?
      VIM.command(":edit #{alternate_file}")
    end

    def find_alternate_file_path(working_directory, current_file_path)
      full_file_path = File.join(working_directory, current_file_path)
      current_file_name_without_ext = File.basename(full_file_path, File.extname(full_file_path))

      if current_file_name_without_ext =~ /[Ss]pec\Z|[Tt]est\Z/
        find_prod_file(working_directory, full_file_path, current_file_name_without_ext)
      else
        find_test_file(working_directory, full_file_path, current_file_name_without_ext)
      end
    end


    private

    Score = Struct.new(:alt_file, :score)

    def find_prod_file(working_directory, full_file_path, current_file_name)
      production_file_name = current_file_name.gsub(TEST_FILE_REGEX, "")
      files = `find #{working_directory} #{exclude_directories_clause(working_directory)} -name "#{production_file_name}*" -type f -print`.split(/\n/)
      prod_files = files.select { |f| f !~ TEST_FILE_WITH_END_PERIOD_REGEX }
      if prod_files.size > 1
        prod_file = find_best_match(prod_files, full_file_path, current_file_name)
      else
        prod_file = prod_files.first
      end
      prod_file.gsub("#{working_directory}#{File::SEPARATOR}", "") if prod_file
    end

    def find_test_file(working_directory, full_file_path, current_file_name)
      files = `find #{working_directory} #{exclude_directories_clause(working_directory)} -name "#{current_file_name}*" -type f -print`.split(/\n/)
      test_files = files.select { |f| f =~ TEST_FILE_WITH_END_PERIOD_REGEX }
      if test_files.size > 1
        test_file = find_best_match(test_files, full_file_path, current_file_name)
      else
        test_file = test_files.first
      end
      test_file.gsub("#{working_directory}#{File::SEPARATOR}", "") if test_file
    end

    def find_best_match(alt_files, full_file_path, current_file_name)
      file_parts = full_file_path.split("/").reverse.drop(1)

      scores = alt_files.map do |file|
        alt_file_parts = file.split("/").reverse.drop(1)
        score = 0
        alt_file_parts.each_with_index do |part, index|
          if part == file_parts[index]
            score += 1
          else
            break
          end
        end

        file_name_without_ext = File.basename(file, File.extname(file))
        if current_file_name.gsub(TEST_FILE_REGEX, "") == file_name_without_ext.gsub(TEST_FILE_REGEX, "")
          score += 1
        end
        Score.new(file, score)
      end

      scores.max_by { |score| score.score }.alt_file
    end

    def exclude_directories_clause(working_directory)
      "-type d -name '.git' -prune -o -type d -name 'node_modules' -prune -o -type d -name '.svn' -prune -o"
    end

  end

end

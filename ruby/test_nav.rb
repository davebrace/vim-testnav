module TestNav

  class << self

    def toggle
      current_directory = VIM.command(":pwd")
      current_buffer = VIM::Buffer.current
      current_file = current_buffer.name
      alternate_file = find_alternate_file_path(current_directory, current_file)
      VIM.command(":edit #{alternate_file}")
    end

    def find_alternate_file_path(working_directory, current_file_path)
      full_file_path = File.join(working_directory, current_file_path)
      current_file_name = File.basename(full_file_path)

      if current_file_name =~ /spec|test/
        find_prod_file(working_directory, current_file_name)
      else
        find_test_file(working_directory, current_file_name)
      end
    end


    private

    def find_prod_file(working_directory, current_file_name)
      production_file_name = current_file_name.gsub(/_(spec|test)/, "")
      files = `find #{working_directory} -name "#{production_file_name}" -print`.split(/\n/)
      production_file_full_path = files.first
      production_file_full_path.gsub("#{working_directory}#{File::SEPARATOR}", "") if production_file_full_path
    end

    def find_test_file(working_directory, current_file_name)
      filename_without_suffix = current_file_name.split(".").first
      files = `find #{working_directory} -name "#{filename_without_suffix}*" -print`.split(/\n/)
      test_file_full_path = files.select { |f| f =~ /_(spec|test)\./ }.first
      test_file_full_path.gsub("#{working_directory}#{File::SEPARATOR}", "") if test_file_full_path
    end

  end

end

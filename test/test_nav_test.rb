require "minitest/autorun"
require_relative "../ruby/test_nav"

describe TestNav do

  describe ".find_alternate_file" do

    describe "given a working directory with a production file and test file with the same name" do
      describe "given the test file is passed as the argument to navigate" do
        it "returns the production code file" do
          FileUtils.rm_rf("tmp")
          FileUtils.mkdir_p("tmp/app/controllers")
          FileUtils.mkdir_p("tmp/spec/controllers")
          FileUtils.touch("tmp/app/controllers/welcome_controller.rb")
          FileUtils.touch("tmp/spec/controllers/welcome_controller_spec.rb")

          result = TestNav.find_alternate_file_path("#{Dir.pwd}/tmp", "spec/controllers/welcome_controller_spec.rb")
          assert_equal "app/controllers/welcome_controller.rb", result
        end
      end

      describe "given the production file is passed as the argument to navigate" do
        it "returns the production code file" do
          FileUtils.rm_rf("tmp")
          FileUtils.mkdir_p("tmp/app/controllers")
          FileUtils.mkdir_p("tmp/spec/controllers")
          FileUtils.touch("tmp/app/controllers/welcome_controller.rb")
          FileUtils.touch("tmp/spec/controllers/welcome_controller_spec.rb")

          result = TestNav.find_alternate_file_path("#{Dir.pwd}/tmp", "app/controllers/welcome_controller.rb")
          assert_equal "spec/controllers/welcome_controller_spec.rb", result
        end
      end

      describe "given the production file is passed as the argument to navigate" do
        it "returns the production code file" do
          FileUtils.rm_rf("tmp")
          FileUtils.mkdir_p("tmp/app/controllers")
          FileUtils.mkdir_p("tmp/.git/controllers")
          FileUtils.touch("tmp/app/controllers/welcome_controller.rb")
          FileUtils.touch("tmp/.git/controllers/welcome_controller_spec.rb")

          result = TestNav.find_alternate_file_path("#{Dir.pwd}/tmp", "app/controllers/welcome_controller.rb")
          assert_equal nil, result
        end
      end
    end
  end
end

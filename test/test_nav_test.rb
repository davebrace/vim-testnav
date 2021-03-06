require "minitest/autorun"
require_relative "../ruby/test_nav"

describe TestNav do

  describe ".find_alternate_file" do

    describe "given the test file is passed as the argument to navigate and there is a production file match" do
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

    describe "given the production file is passed as the argument to navigate and there is a test file match" do
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

    describe "given the production file is passed as the argument to navigate and there is a test file match with multiple similar options" do
      it "returns the production code file" do
        FileUtils.rm_rf("tmp")
        FileUtils.mkdir_p("tmp/app/models")
        FileUtils.mkdir_p("tmp/spec/models")
        FileUtils.touch("tmp/app/models/user.rb")
        FileUtils.touch("tmp/spec/models/user_metrics_spec.rb")
        FileUtils.touch("tmp/spec/models/user_spec.rb")

        result = TestNav.find_alternate_file_path("#{Dir.pwd}/tmp", "app/models/user.rb")
        assert_equal "spec/models/user_spec.rb", result
      end
    end

    describe "given there is a test alternate in a .git folder" do
      it "does not return the alterate" do
        FileUtils.rm_rf("tmp")
        FileUtils.mkdir_p("tmp/app/controllers")
        FileUtils.mkdir_p("tmp/.git/controllers")
        FileUtils.touch("tmp/app/controllers/welcome_controller.rb")
        FileUtils.touch("tmp/.git/controllers/welcome_controller_spec.rb")

        result = TestNav.find_alternate_file_path("#{Dir.pwd}/tmp", "app/controllers/welcome_controller.rb")
        assert_equal nil, result
      end
    end

    describe "given there are multiple test alternates that match a production file" do
      it "recursively checks the parent directory structure for matches" do
        FileUtils.rm_rf("tmp")
        FileUtils.mkdir_p("tmp/test/app/controllers/v1/companies/")
        FileUtils.mkdir_p("tmp/test/app/controllers/v1/people/")
        FileUtils.mkdir_p("tmp/test/app/controllers/v2/companies/")
        FileUtils.touch("tmp/test/app/controllers/v1/companies/news_controller_test.rb")
        FileUtils.touch("tmp/test/app/controllers/v1/people/news_controller_test.rb")
        FileUtils.touch("tmp/test/app/controllers/v2/companies/news_controller_test.rb")

        result = TestNav.find_alternate_file_path("#{Dir.pwd}/tmp", "app/controllers/v2/companies/news_controller.rb")
        assert_equal "test/app/controllers/v2/companies/news_controller_test.rb", result
      end
    end

    describe "given there are multiple production files that match a test alternate" do
      it "recursively checks the parent directory structure for matches" do
        FileUtils.rm_rf("tmp")
        FileUtils.mkdir_p("tmp/app/controllers/v1/companies/")
        FileUtils.mkdir_p("tmp/app/controllers/v1/people/")
        FileUtils.mkdir_p("tmp/app/controllers/v2/companies/")
        FileUtils.touch("tmp/app/controllers/v1/companies/news_controller.rb")
        FileUtils.touch("tmp/app/controllers/v1/people/news_controller.rb")
        FileUtils.touch("tmp/app/controllers/v2/companies/news_controller.rb")

        result = TestNav.find_alternate_file_path("#{Dir.pwd}/tmp", "test/controllers/v2/companies/news_controller_test.rb")
        assert_equal "app/controllers/v2/companies/news_controller.rb", result
      end
    end

    describe "given there is a directory that matches a test alternate" do
      it "returns nil" do
        FileUtils.rm_rf("tmp")
        FileUtils.mkdir_p("tmp/app/controllers/v2/companies/news_controller/")

        result = TestNav.find_alternate_file_path("#{Dir.pwd}/tmp", "test/controllers/v2/companies/news_controller_test.rb")
        assert_equal nil, result
      end
    end

    describe "given an elixir production file with an elixir script test file" do
      it "identifies the script file as the alternate test file" do
        FileUtils.rm_rf("tmp")
        FileUtils.mkdir_p("tmp/test/app/controllers/v1/companies/")
        FileUtils.touch("tmp/test/app/controllers/v1/companies/news_controller_test.exs")

        result = TestNav.find_alternate_file_path("#{Dir.pwd}/tmp", "app/controllers/v1/companies/news_controller.ex")
        assert_equal "test/app/controllers/v1/companies/news_controller_test.exs", result
      end
    end

    describe "given a java production file with a java test file in idiomatic capitalized format" do
      it "identifies the capitalized file with a similar name and Test as the alternate test file" do
        FileUtils.rm_rf("tmp")
        FileUtils.mkdir_p("tmp/test/app/controllers/v1/companies/")
        FileUtils.touch("tmp/test/app/controllers/v1/companies/NewsControllerTest.java")

        result = TestNav.find_alternate_file_path("#{Dir.pwd}/tmp", "app/controllers/v1/companies/NewsController.java")
        assert_equal "test/app/controllers/v1/companies/NewsControllerTest.java", result
      end
    end
  end
end

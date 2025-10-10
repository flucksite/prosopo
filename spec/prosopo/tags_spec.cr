require "../spec_helper"

describe Prosopo::Tags do
  helper = TestTagsHelper.new

  describe "#prosopo_script" do
    it "renders a basic tag without arguments" do
      helper.prosopo_script.should eq(<<-HTML)
      <script type="module" src="https://js.prosopo.io/js/procaptcha.bundle.js" async defer></script>
      HTML
    end

    it "renders the tag without defer and async" do
      helper.prosopo_script(defer: false, async: false).should eq(<<-HTML)
      <script type="module" src="https://js.prosopo.io/js/procaptcha.bundle.js"></script>
      HTML
    end

    it "renders the tag with custom attributes" do
      helper.prosopo_script(data_some: "value").should eq(<<-HTML)
      <script type="module" src="https://js.prosopo.io/js/procaptcha.bundle.js" async defer data-some="value"></script>
      HTML
    end
  end

  describe "#lucky_prosopo_script" do
    it "renders a basic tag" do
      helper.lucky_prosopo_script
        .should eq(helper.prosopo_script)
    end
  end

  describe "#prosopo_container" do
    it "renders a basic tag without arguments" do
      helper.prosopo_container.should eq(<<-HTML)
      <div class="procaptcha " data-sitekey="aBcDeFgH"></div>
      HTML
    end

    it "renders the tag with an additional class name" do
      helper.prosopo_container(class_name: "my-class-name").should eq(<<-HTML)
      <div class="procaptcha my-class-name" data-sitekey="aBcDeFgH"></div>
      HTML
    end

    it "renders the tag with custom attributes" do
      helper.prosopo_container(data_theme: "dark").should eq(<<-HTML)
      <div class="procaptcha " data-sitekey="aBcDeFgH" data-theme="dark"></div>
      HTML
    end
  end

  describe "#lucky_prosopo_container" do
    it "renders a basic tag" do
      helper.lucky_prosopo_container(data_theme: "dark")
        .should eq(helper.prosopo_container(data_theme: "dark"))
    end
  end
end

struct TestTagsHelper
  include Prosopo::Tags

  def raw(value)
    value
  end
end

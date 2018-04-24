require 'rails_helper'

def visit_fill_click_link
  visit "/"
  fill_in "Long URL", with: "http://ryanbigg.com/2016/04/hiring-juniors"
  click_button "Shorten"
end

RSpec.feature "Creating a new link" do
  scenario "successfully creates a new link" do
    visit_fill_click_link
    link = Link.first
    expect(link.short_url).to be_present
    expect(page).to have_content("Your link is #{link.short_url}")
  end
end

RSpec.feature "When entering an existing link" do
  scenario "returns the corresponding short url" do
    visit_fill_click_link
    visit_fill_click_link
    link = Link.where(long_url: "http://ryanbigg.com/2016/04/hiring-juniors")
    expect(link.count).to eq(1)
    expect(page).to have_content("Your link is #{link.first.short_url}")
  end
end

RSpec.feature "When no url is entered" do
  scenario "returns the fill in link error mesage" do
    visit '/'
    click_button "Shorten"
    expect(page).to have_content("Long url can't be blank")
  end
end

RSpec.feature "When user inputs short url" do
  scenario "they can specify their own short url" do
    visit "/"
    fill_in "Long URL", with: "ryanbigg.com/2016/04/hiring-juniors"
    fill_in "Unique Short URL", with: "rbjuniors"
    click_button "Shorten"
    expect(page).to have_content("Your link is rbjuniors")
  end
end

RSpec.feature "When user inputs short url" do
  scenario "they can specify their own short url" do
    visit "/"
    fill_in "Long URL", with: "originaryanbigg.com/2016/04/hiring-juniors"
    fill_in "Unique Short URL", with: "dot.test"
    click_button "Shorten"
    expect(page).to have_content("Your link is dot.test")
  end
end

RSpec.feature "When user inputs invalid long url" do
  scenario "they can specify their own short url" do
    visit "/"
    fill_in "Long URL", with: "some junk"
    click_button "Shorten"
    expect(page).to have_content("Long url is not a valid URL")
  end
end

RSpec.feature "When user inputs another short-link service link inot long-url" do
  scenario "they get an error message" do
    visit '/'
    fill_in "Long URL", with: "http://bit.ly/2oG0C3v"
    click_button "Shorten"
    expect(page).to have_content("is already a shortened URL")
  end
end

RSpec.feature "When user inputs another short-link service link into short-url" do
  scenario "they get an error message" do
    visit '/'
    fill_in "Long URL", with: "cultureamp.com"
    fill_in "Short URL", with: "https://goo.gl/5PnQ4y"
    click_button "Shorten"
    expect(page).to have_content("is already a shortened URL")
  end
end

RSpec.feature "When user is signed in" do
  scenario "the link is accociated with that user" do
    user = FactoryBot.create(:user, api_key: 'abc123')
    sign_in(user)
    visit_fill_click_link
    link = Link.first
    expect(link.user).to eq(user)
    expect(user.links.count).to eq(1)
    expect(user.links.target).to eq("http://ryanbigg.com/2016/04/hiring-juniors")
  end
end

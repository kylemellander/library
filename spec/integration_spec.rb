require 'spec_helper'
require 'capybara/rspec'
require './app'

Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('/', {:type => :feature}) do
  it 'displays index page with books' do
    visit('/')
    expect(page).to have_content("Library")
  end
end

describe('book/add', {:type => :feature}) do
  it 'displays index page with books' do
    visit('/book/add')
    fill_in "title", with: "The Foundation"
    fill_in "author", with: "Isaac Asimov"
    click_button "Add Book"
    expect(page).to have_content("The Foundation")
    expect(page).to have_content("Isaac Asimov")
    visit('/')
    expect(page).to have_content("The Foundation")
    expect(page).to have_content("Isaac Asimov")
  end
end

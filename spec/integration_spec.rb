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

describe('/book/add', {:type => :feature}) do
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

describe('/book/available', {:type => :feature}) do
  it 'displays only books available' do
    @book1 = Book.new({title: "Heart of Darkness"})
    @book2 = Book.new({title: "The Name of the Wind"})
    @patron1 = Patron.new({name: 'Dave'})
    @book1.save
    @book2.save
    @patron1.save
    @author1 = Author.new({name: 'David Patorn'})
    @author2 = Author.new({name: 'Dr. Seuss'})
    @author1.save
    @author2.save
    @book2.update({author_ids: [@author1.id, @author2.id] })
    @book1.update({patron_ids: [@patron1.id], author_ids: [@author1.id, @author2.id] })
    visit('/book/available')
    expect(page).to have_content("The Name of the Wind")
    expect(page).to have_no_content("Heart of Darkness")
  end
end

describe('/patron', {:type => :feature}) do
  it 'displays all patrons' do
    @patron1 = Patron.new({name: 'Dave'})
    @patron1.save
    visit('/patron')
    expect(page).to have_content("Dave")
  end
end

describe('/patron/add', {:type => :feature}) do
  it 'displays patron page with patrons' do
    visit('/patron/add')
    fill_in "name", with: "David Patorn"
    click_button "Add Patron"
    expect(page).to have_content("David Patorn")
    visit('/patron')
    expect(page).to have_content("David Patorn")
  end
end

describe('/author', {:type => :feature}) do
  it 'displays all authors' do
    @author1 = Author.new({name: 'David Patorn'})
    @author1.save
    visit('/author')
    expect(page).to have_content("David Patorn")
  end
end

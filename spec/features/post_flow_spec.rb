require 'rails_helper'

RSpec.feature "PostFlows", type: :feature do

  describe "post index page" do
    let!(:post_one) { FactoryBot.create(:post) }
    let!(:post_two) { FactoryBot.create(:post) }
    it "displays a list of posts" do
      visit posts_path
      expect(page).to have_content(post_one.title)
      expect(page).to have_content(post_excerpt(post_one))
      expect(page).to have_link(post_one.author.formatted_name, href: author_path(post_one.author))
      expect(page).to have_link("Read More", href: post_path(post_one))
      expect(page).to have_content(post_two.title)
      expect(page).to have_content(post_excerpt(post_two))
      expect(page).to have_link(post_two.author.formatted_name, href: author_path(post_two.author))
      expect(page).to have_link("Read More", href: post_path(post_two))
    end
  end

  describe "post show page" do
    let!(:post) { FactoryBot.create(:post) }
    it "displays the post's content andauthor" do
      visit post_path(post)
      expect(page).to have_content(post.body)
      expect(page).to have_link(post.author.formatted_name, href: author_path(post.author))
    end

    it "displays a link to the edit page" do
      visit post_path(post)
      expect(page).to have_link("Edit Post", href: edit_post_path(post))
    end
  end

  describe "post new page" do
    let!(:author) { FactoryBot.create(:author) }
    it "displays a form to add a new post" do
      visit new_post_path
      fill_in("Title", with: "here is my title")
      fill_in("Body", with: "here is my post")
      select("#{author.formatted_name}", from: "Author")
      click_button("Create Post")
      expect(page).to have_content("#{Post.last.title} was successfully saved.")
      expect(page).to have_current_path(post_path(Post.last))
    end

    it "renders reasons why form did not save" do
      visit new_post_path
      fill_in("Title", with: "")
      click_button("Create Post")
      expect(page).to have_content("prohibited this post from being saved:")
    end
  end

  describe "post edit page" do
    let!(:post) { FactoryBot.create(:post) }
    it "displays a form to edit the post" do
      visit edit_post_path(post)
      fill_in("Title", with: "new title")
      click_button("Update Post")
      expect(page).to have_content("new title was successfully updated.")
    end

    it "has a button to delete the post" do
      visit edit_post_path(post)
      click_link("Delete Post", href: post_path(post))
      expect(page).to have_content("#{post.title} was successfully deleted.")
    end
  end
end

require "rails_helper"

describe "/photos - Create photo form" do
  it "automatically populates owner_id of new photo with id of the signed in user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end
    
    visit "/photos"
    within(:css, "form") do
      fill_in "Image", with: "https://some.test/image-#{Time.now.to_i}.jpg"
      fill_in "Caption", with: "Some test caption #{Time.now.to_i}"
      click_on "Add photo"
    end
    

    expect(page).to have_text("Some test caption #{Time.now.to_i}")
  end
end

describe "/photos/[ID] - Update photo form" do
  it "displays Update photo form when photo belongs to current user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end
    
    visit "/photos/#{photo.id}"


    expect(page).to have_text("Update photo")
  end
end

describe "/photos/[ID] - Delete this photo button" do
  it "displays Delete this photo button when photo belongs to current user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit "/user_sign_in"
    
    
    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end
    
    visit "/photos/#{photo.id}"

    expect(page).to have_content(first_user.username)

    expect(page).to have_link("Delete this photo")
  end
end

describe "/photos/[ID] — Add comment form" do
  it "automatically associates comment with signed in user and current photo", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end

    test_comment = "Hey, what a nice app you're building!"

    visit "/photos/#{photo.id}"

    fill_in "Comment", with: test_comment

    click_on "Add comment"

    added_comment = Comment.where({ :author_id => first_user.id, :photo_id => photo.id, :body => test_comment }).at(0)

    expect(added_comment).to_not be_nil
  end
end

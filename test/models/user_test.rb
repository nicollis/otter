require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Austin Powers", email: "Yaybaby@apowers.uk", password: "britain1", password_confirmation: 'britain1')
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email should be unique" do # Looking at you amazon.... #InsideJokeInsideCode
    dup_user = @user.dup
    dup_user.email = dup_user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    test = users(:test)
    test2  = users(:test2)
    assert_not test.following?(test2)
    test.follow(test2)
    assert test.following?(test2)
    assert test2.followers.include? test
    test.unfollow(test2)
    assert_not test.following?(test2)
  end

  test "feed should have the right posts" do
    test = users(:test)
    test2  = users(:test2)
    user_2    = users(:user_2)
    # Posts from followed user
    user_2.microposts.each do |post_following|
      assert test.feed.include?(post_following)
    end
    # Posts from self
    test.microposts.each do |post_self|
      assert test.feed.include?(post_self)
    end
    # Posts from unfollowed user
    test2.microposts.each do |post_unfollowed|
      assert_not test.feed.include?(post_unfollowed)
    end
  end
end

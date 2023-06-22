require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'require a name' do
    @user = User.new(name: '', email: 'rokas@gmail.com')
    assert_not @user.valid?
    @user.name = 'Rokas'
    assert @user.valid?
  end

  test 'requires a valid email' do
    @user = User.new(name: 'Rokas', email: '')
    assert_not @user.valid?

    @user.email = 'invalid'
    assert_not @user.valid?

    @user.email = 'rokas@gmail.com'
    assert @user.valid?
  end

  test 'requires a unique email' do
    @existing_user = User.create(name: 'Rokas', email: 'rokas@gmail.com')
    assert @existing_user.persisted?

    @user = User.new(name: 'Rok', email: 'rokas@gmail.com')
    assert_not @user.valid?
  end

  test 'name and email is stripped of spaces before saving' do
    @user = User.create(name: ' Rokas ', email: ' rokas@gmail.com ')

    assert_equal 'Rokas', @user.name
    assert_equal 'rokas@gmail.com', @user.email
  end

  test "password length must be between 8 and ActiveModel's maximum" do
    @user = User.new(name: 'Rokas', email: 'rokas@gmail.com', password: '')
    assert_not @user.valid?

    @user.password = 'password'
    assert @user.valid?

    max_length = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    @user.password = 'a' * (max_length + 1)
    assert_not @user.valid?
  end
end

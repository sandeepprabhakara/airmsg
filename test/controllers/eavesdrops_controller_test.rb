require 'test_helper'

class EavesdropsControllerTest < ActionController::TestCase
  setup do
    @eavesdrop = eavesdrops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:eavesdrops)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create eavesdrop" do
    assert_difference('Eavesdrop.count') do
      post :create, eavesdrop: { initiator_id: @eavesdrop.initiator_id, responder_id: @eavesdrop.responder_id, user_id: @eavesdrop.user_id }
    end

    assert_redirected_to eavesdrop_path(assigns(:eavesdrop))
  end

  test "should show eavesdrop" do
    get :show, id: @eavesdrop
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @eavesdrop
    assert_response :success
  end

  test "should update eavesdrop" do
    patch :update, id: @eavesdrop, eavesdrop: { initiator_id: @eavesdrop.initiator_id, responder_id: @eavesdrop.responder_id, user_id: @eavesdrop.user_id }
    assert_redirected_to eavesdrop_path(assigns(:eavesdrop))
  end

  test "should destroy eavesdrop" do
    assert_difference('Eavesdrop.count', -1) do
      delete :destroy, id: @eavesdrop
    end

    assert_redirected_to eavesdrops_path
  end
end

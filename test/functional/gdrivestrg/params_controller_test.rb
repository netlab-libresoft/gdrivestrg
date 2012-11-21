require 'test_helper'

module Gdrivestrg
  class ParamsControllerTest < ActionController::TestCase
    setup do
      @param = params(:one)
    end
  
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:params)
    end
  
    test "should get new" do
      get :new
      assert_response :success
    end
  
    test "should create param" do
      assert_difference('Param.count') do
        post :create, param: { expires_in: @param.expires_in, issued_at: @param.issued_at, refresh_token: @param.refresh_token }
      end
  
      assert_redirected_to param_path(assigns(:param))
    end
  
    test "should show param" do
      get :show, id: @param
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, id: @param
      assert_response :success
    end
  
    test "should update param" do
      put :update, id: @param, param: { expires_in: @param.expires_in, issued_at: @param.issued_at, refresh_token: @param.refresh_token }
      assert_redirected_to param_path(assigns(:param))
    end
  
    test "should destroy param" do
      assert_difference('Param.count', -1) do
        delete :destroy, id: @param
      end
  
      assert_redirected_to params_path
    end
  end
end

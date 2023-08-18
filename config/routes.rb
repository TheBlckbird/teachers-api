Rails.application.routes.draw do
  scope "/api" do
    scope "/v1" do
      get "/teachers/:abbreviation", to: "teachers#index"
    end
  end
end

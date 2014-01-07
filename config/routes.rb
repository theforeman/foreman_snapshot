Rails.application.routes.draw do
  namespace :api, :defaults => {:format => 'json'} do

    # new v2 routes that point to v2
    scope "(:apiv)", :module => :v2, :defaults => {:apiv => 'v2'}, :apiv => /v1|v2/, :constraints     => ApiConstraints.new(:version => 2) do

      resources :hostgroups, :only => [:snapshot] do
        post 'snapshot', :on => :member
      end
    end
  end

end

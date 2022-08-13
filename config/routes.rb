Rails.application.routes.draw do
  authenticate :user do
    # routes created within this block can only be accessed by a user who has
    # logged in. For example:
    # resources :things
  end

  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  # TODO: I'm unsure where the cleanest place to mount this is? users seems sensbile but it kind of intrudes on the devise namespace?
  namespace :users do
    resource :mfa do
      member do
        post :reset_backup_codes
        delete :delete_backup_codes
        # TODO: route names still WIP, not sure the rest metaphor works here
      end
    end
  end
  ##
  # Workaround a "bug" in lighthouse CLI
  #
  # Lighthouse CLI (versions 5.4 - 5.6 tested) issues a `GET /asset-manifest.json`
  # request during its run - the URL seems to be hard-coded. This file does not
  # exist so, during tests, your test will fail because rails will die with a 404.
  #
  # Lighthouse run from Chrome Dev-tools does not have the same behaviour.
  #
  # This hack works around this. This behaviour might be fixed by the time you
  # read this. You can check by commenting out this block and running the
  # accessibility and performance tests. You are encouraged to remove this hack
  # as soon as it is no longer needed.
  #
  if defined?(Webpacker) && Rails.env.test?
    # manifest paths depend on your webpacker config so we inspect it
    manifest_path = Webpacker::Configuration
                    .new(root_path: Rails.root, config_path: Rails.root.join("config/webpacker.yml"), env: Rails.env)
                    .public_manifest_path
                    .relative_path_from(Rails.root.join("public"))
                    .to_s
    get "/asset-manifest.json", to: redirect(manifest_path)
  end

  root "home#index"
  mount OkComputer::Engine, at: "/healthchecks"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

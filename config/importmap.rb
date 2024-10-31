# config/importmap.rb
pin 'application', preload: true

pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'

# Utils
pin_all_from 'app/javascript/utils', under: 'utils'

# Add these lines to ensure your custom modules are properly loaded
pin "@stimulus-components/notification", to: "@stimulus-components--notification.js" # @3.0.0
pin "stimulus-use" # @0.52.2
pin "@stimulus-components/dropdown", to: "@stimulus-components--dropdown.js" # @3.0.0
pin "@stimulus-components/dialog", to: "@stimulus-components--dialog.js" # @1.0.1
pin "@stimulus-components/rails-nested-form", to: "@stimulus-components--rails-nested-form.js" # @5.0.0
pin "choices.js" # @11.0.2
pin "swiper" # @11.1.12
pin "cropperjs" # @1.6.2
pin "@stimulus-components/color-picker", to: "@stimulus-components--color-picker.js" # @2.0.0
pin "@simonwep/pickr", to: "@simonwep--pickr.js" # @1.9.0
pin "trix" # @2.1.6
pin "@rails/actiontext", to: "@rails--actiontext.js" # @7.2.100
# pin "quill", to: "quill.js" # @2.0.2

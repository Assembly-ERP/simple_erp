# config/importmap.rb
pin 'application', preload: true

pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'https://ga.jspm.io/npm:@hotwired/stimulus@3.2.1/dist/stimulus.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers', preload: false

pin 'jquery', to: 'https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js'
pin 'axios', to: 'https://cdn.jsdelivr.net/npm/axios@1.7.2/dist/axios.min.js'
pin '@rails/request.js', to: 'https://cdn.jsdelivr.net/npm/@rails/request.js@0.0.9/dist/requestjs.min.js'
pin '@rails/actioncable', to: 'actioncable.esm.js'
pin '@rails/activestorage', to: 'activestorage.esm.js'
pin '@rails/actiontext', to: 'actiontext.esm.js'
pin 'trix'

# Add these lines to ensure your custom modules are properly loaded
pin 'axiosHelper', to: 'axiosHelper.js'
pin 'customer_search', to: 'customer_search.js'
pin 'preview', to: 'preview.js'
pin "@stimulus-components/notification", to: "@stimulus-components--notification.js" # @3.0.0
pin "stimulus-use" # @0.52.2
pin "@stimulus-components/dropdown", to: "@stimulus-components--dropdown.js" # @3.0.0

# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

pin "htm", to: "https://cdn.esm.sh/v45/htm@3.1.0/es2021/htm.js"
pin "react", to: "https://cdn.esm.sh/v45/react@17.0.2/es2021/react.js"
pin "react-dom", to: "https://cdn.esm.sh/v45/react-dom@17.0.2/es2021/react-dom.js"
pin_all_from "app/javascript/components", under: "components"
pin "app/javascript/components/index.js", preload: true

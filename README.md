# README

This is a Hubspot form plugin for [Camaleon CMS](https://github.com/owen2345/camaleon-cms)

It creates a connection to the designated Hubspot account via the [ruby-hubspot gem](https://github.com/adimichele/hubspot-ruby), and pulls in forms and provides the user with a collection of shortcodes.

# Dependencies
* Camaleon CMS:
`gem "camaleon_cms",  '>= 2.4.5'`

* ruby-hubspot:
`gem "hubspot-ruby"`

# Installation
* Within your Camaleon installation, set up ruby-hubspot and ensure it's connected and running. (Can test in rails console by running `Hubspot::Form.all`)
* Add the plugin into your Gemfile
`gem "cama_hubspot_form", '0.0.5', github: "dannio/cama_hubspot_form"`
* Install `bundle install`
* Activate Plugin in Camaleon admin panel
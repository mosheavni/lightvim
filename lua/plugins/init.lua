local packs = require 'core.packs'

local plugins = {
  require 'plugins.lazydev',
  require 'plugins.mini',
}

packs.lazy_load(plugins)
packs.setup_cleanup(plugins)

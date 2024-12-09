local config = require('init').setup()

require('ui.color_scheme').setup(config)
require('ui.tab_bar').setup(config)
require('config.keys').setup(config)
require('ui.windows').setup(config)
require('ui.zen-mode').setup()
require('ui.startup').setup()

return config
